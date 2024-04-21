---
author: Thomas Taylor
categories:
- cloud
- ai
date: '2024-04-21T01:35:00-04:00'
description: "In this post, we dive into using Anthropic Claude tooling api with examples using the Anthropic SDK in Python."
tags:
- python
- generative-ai
title: "Anthropic Claude with tools using Python SDK"
---

On April 4th, 2024, Anthropic released [official support for tool use][1] through their API. This feature allows developers to define one or more tools that include parameters, descriptions, and schema definitions for Claude to process.

In this post, we'll go over how to leverage these tools using the Python Anthropic SDK.

## Claude with tools example in Python

Firstly, ensure that your Anthropic API key is available as an environment variable in your shell:

```shell
export ANTHROPIC_API_KEY="sk-......"
```

### Install the Anthropic SDK

Next, install the latest version of the Anthropic SDK using `pip`.

```shell
pip install anthropic
```

### Define the tools

Using the provided [JSON schema example in the Anthropic documentation][2], let's define a `get_current_stock_price` tool:

```json
{
  "name": "get_current_stock_price",
  "description": "Retrieves the current stock price for a given ticker symbol. The ticker symbol must be a valid symbol for a publicly traded company on a major US stock exchange like NYSE or NASDAQ. The tool will return the latest trade price in USD. It should be used when the user asks about the current or most recent price of a specific stock. It will not provide any other information about the stock or company.",
  "input_schema": {
    "type": "object",
    "properties": {
      "ticker": {
        "type": "string",
        "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
      }
    },
    "required": ["ticker"]
  }
}
```

In Python,

```python
import anthropic

tools = [
    {
        "name": "get_current_stock_price",
        "description": "Retrieves the current stock price for a given ticker symbol. The ticker symbol must be a valid symbol for a publicly traded company on a major US stock exchange like NYSE or NASDAQ. The tool will return the latest trade price in USD. It should be used when the user asks about the current or most recent price of a specific stock. It will not provide any other information about the stock or company.",
        "input_schema": {
            "type": "object",
            "properties": {
                "symbol": {
                    "type": "string",
                    "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
                }
            },
            "required": ["symbol"]
        }
    }
]
```

### Instantiate a client

To invoke Claude, we need to instantiate a client. The SDK uses the `ANTHROPIC_API_KEY` environment variable by default for authentication.

```python
import anthropic

client = anthropic.Anthropic()
```

### Invoke Claude with tools

Now, let's create a new message using Claude and the tools:

```python
import anthropic

tools = [
    {
        "name": "get_current_stock_price",
        "description": "Retrieves the current stock price for a given ticker symbol. The ticker symbol must be a valid symbol for a publicly traded company on a major US stock exchange like NYSE or NASDAQ. The tool will return the latest trade price in USD. It should be used when the user asks about the current or most recent price of a specific stock. It will not provide any other information about the stock or company.",
        "input_schema": {
            "type": "object",
            "properties": {
                "symbol": {
                    "type": "string",
                    "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
                }
            },
            "required": ["symbol"]
        }
    }
]

client = anthropic.Anthropic()

response = client.beta.tools.messages.create(
    model="claude-3-haiku-20240307",
    max_tokens=1024,
    tools=tools,
    messages=[
        {
            "role": "user",
            "content": "What is the stock price of Apple?"
        }
    ]
)

print(response)
```

Output:

```text
ToolsBetaMessage(id='msg_01Bedxru94A4Pe1sHgWtymSJ', content=[ToolUseBlock(id='toolu_01CbGgyko9mdkKSDPw6LsTvV', input={'symbol': 'AAPL'}, name='get_current_stock_price', type='tool_use')], model='claude-3-haiku-20240307', role='assistant', stop_reason='tool_use', stop_sequence=None, type='message', usage=Usage(input_tokens=433, output_tokens=60))
```

The output includes a `ToolUseBlock` with the input for the tool. We now need to process the tool and return the result to Claude.

### Building a tool router

Let's build a mock function that returns `150.0` for the stock price:

```python
def get_current_stock_price(symbol):
    # Fake implementation for demonstration purposes
    return 150.0
```

And then a "router" function that accepts the tool name and input:

```python
def process_tool(tool_name, input):
    match tool_name:
        case "get_current_stock_price":
            return get_current_stock_price(input["symbol"])
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")
```

### Responding with a tool result example

Anthropic provides a [Jupyter notebook that showcases a customer service example using tools][3]. We'll adapt some of the functionality to our script:

```python
while response.stop_reason == "tool_use":
    tool_use = next(block for block in response.content if block.type == "tool_use")
    tool_name = tool_use.name
    tool_input = tool_use.input
    tool_result = process_tool(tool_name, tool_input)

    messages = [
        {"role": "user", "content": user_message},
        {"role": "assistant", "content": response.content},
        {
            "role": "user",
            "content": [
                {
                    "type": "tool_result",
                    "tool_use_id": tool_use.id,
                    "content": str(tool_result),
                }
            ],
        },
    ]

    response = client.beta.tools.messages.create(
        model=model,
        max_tokens=4096,
        tools=tools,
        messages=messages
    )

final_response = next(
    (block.text for block in response.content if isinstance(block, TextBlock)),
    None,
)
```

The code does the following:

1. Loop while the response is `tool_use`
2. Extracts the current tool's name and input
3. Processes the tool by calling the router function
4. Creates a new Claude message using the prior messages and the tool result
5. Retrieves the final response from Claude and returns the text

### Putting it altogether

Here's the resulting code:

```python
import anthropic
from anthropic.types import TextBlock

client = anthropic.Anthropic()


def talk(client, tools, model, user_message):
    response = client.beta.tools.messages.create(
        model=model,
        max_tokens=1024,
        tools=tools,
        messages=[{"role": "user", "content": user_message}],
    )

    while response.stop_reason == "tool_use":
        tool_use = next(block for block in response.content if block.type == "tool_use")
        tool_name = tool_use.name
        tool_input = tool_use.input
        tool_result = process_tool(tool_name, tool_input)

        messages = [
            {"role": "user", "content": user_message},
            {"role": "assistant", "content": response.content},
            {
                "role": "user",
                "content": [
                    {
                        "type": "tool_result",
                        "tool_use_id": tool_use.id,
                        "content": str(tool_result),
                    }
                ],
            },
        ]

        response = client.beta.tools.messages.create(
            model=model, max_tokens=4096, tools=tools, messages=messages
        )

    final_response = next(
        (block.text for block in response.content if isinstance(block, TextBlock)),
        None,
    )

    return final_response


def get_current_stock_price(symbol: str):
    # Fake implementation for demonstration purposes
    return 150.0


def process_tool(tool_name: str, input):
    match tool_name:
        case "get_current_stock_price":
            return get_current_stock_price(input["symbol"])
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")


if __name__ == "__main__":
    client = anthropic.Anthropic()
    tools = [
        {
            "name": "get_current_stock_price",
            "description": "Retrieves the current stock price for a given ticker symbol. The ticker symbol must be a valid symbol for a publicly traded company on a major US stock exchange like NYSE or NASDAQ. The tool will return the latest trade price in USD. It should be used when the user asks about the current or most recent price of a specific stock. It will not provide any other information about the stock or company.",
            "input_schema": {
                "type": "object",
                "properties": {
                    "symbol": {
                        "type": "string",
                        "description": "The stock ticker symbol, e.g. AAPL for Apple Inc.",
                    }
                },
                "required": ["symbol"],
            },
        }
    ]
    response = talk(
        client, tools, "claude-3-haiku-20240307", "What is the price of Apple?"
    )
    print(response)

```

Here is the output:

```text
The current stock price for Apple (ticker symbol AAPL) is $150.00.
```

## Conclusion

In this post, we covered:

1. How to invoke Claude using tools
2. How to process tool calls using a switch statement
3. How to respond with a `tool_result` so that Claude can output a final answer

The purpose of this post was to get you started by providing a foundational understanding of Anthropic tool usage using the Python SDK. For more information about [tool best practices][4] or [multi-tool chaining][5], please refer to Anthropic's documentation.

[1]: https://docs.anthropic.com/claude/docs/tool-use
[2]: https://docs.anthropic.com/claude/docs/tool-use#best-practices-for-tool-definitions
[3]: https://github.com/anthropics/anthropic-cookbook/blob/main/tool_use/customer_service_agent.ipynb
[4]: https://docs.anthropic.com/claude/docs/tool-use#best-practices-for-tool-definitions
[5]: https://docs.anthropic.com/claude/docs/tool-use-examples#multiple-tools