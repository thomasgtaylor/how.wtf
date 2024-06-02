---
author: Thomas Taylor
categories:
- ai
- database
date: '2024-06-02T13:25:00:00-04:00'
description: A step-by-step guide for using the Amazon Bedrock Converse API in Python
tags:
- generative-ai
- python
title: A step-by-step guide on how to use the Amazon Bedrock Converse API
---

On May 30th, 2024, Amazon announced the [release of the Bedrock Converse API][1]. This API is designed to provide a consistent experience for "conversing" with Amazon Bedrock models.

The API supports:
1. Conversations with multiple turns
2. System messages
3. Tool use
4. Image and text input

In this post, we'll walk through how to use the Amazon Bedrock Converse API with the Claude Haiku foundational model.

Please keep in mind that not all foundational models may support all the features of the Converse API. For more details per model, see the [Amazon Bedrock documentation][2].

## Getting started

To get started, let's install the `boto3` package.

```shell
pip install boto3
```

Next, we'll create a new Python script and import the necessary dependencies.

```python
import boto3

client = boto3.client("bedrock-runtime")
```

## Step 1 - Starting a conversation

To start off simple, let's send a single message to Claude.

```python
import boto3

client = boto3.client("bedrock-runtime")

messages = [{"role": "user", "content": [{"text": "What is your name?"}]}]

response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

print(response)
```

The response is a dictionary containing the response and other metadata information from the API. For more information regarding the output, please refer to the [Amazon Bedrock documentation][3].

For the purposes of this post, I'll print the response as JSON.

```json
{
  "ResponseMetadata": {
    "RequestId": "6984dcf2-c6aa-4000-a3d6-22e34a43df12",
    "HTTPStatusCode": 200,
    "HTTPHeaders": {
      "date": "Sun, 02 Jun 2024 14:54:08 GMT",
      "content-type": "application/json",
      "content-length": "222",
      "connection": "keep-alive",
      "x-amzn-requestid": "6984dcf2-c6aa-4000-a3d6-22e34a43df12"
    },
    "RetryAttempts": 0
  },
  "output": {
    "message": {
      "role": "assistant",
      "content": [
        {
          "text": "My name is Claude. It's nice to meet you!"
        }
      ]
    }
  },
  "stopReason": "end_turn",
  "usage": {
    "inputTokens": 12,
    "outputTokens": 15,
    "totalTokens": 27
  },
  "metrics": {
    "latencyMs": 560
  }
}
```

To retrieve the contents of the message, we can access the `output` key in the response.

```python
import boto3

client = boto3.client("bedrock-runtime")

messages = [{"role": "user", "content": [{"text": "What is your name?"}]}]

response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

ai_message = response["output"]["message"]
output_text = ai_message["content"][0]["text"]
print(output_text)
```

Output:

```text
My name is Claude. It's nice to meet you!
```

## Step 2 - Continuing a conversation

Let's continue the conversation by appending the AI's message to the original list of messages. This will allow us to have a multi-turn conversation.

```python
import boto3

client = boto3.client("bedrock-runtime")

messages = [{"role": "user", "content": [{"text": "What is your name?"}]}]

response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

ai_message = response["output"]["message"]
messages.append(ai_message)

# Let's ask another question

messages.append({"role": "user", "content": [{"text": "Can you help me?"}]})
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

print(response["output"]["message"]["content"][0]["text"])
```

Output:

```text
Yes, I'd be happy to try and help you with whatever you need assistance with. What can I help you with?
```

## Step 3 - Using images

The Amazon Bedrock Converse API supports images as input. Let's send an image to Claude and see how it responds. I'll download an [image of a cat from Wikipedia][4] and send it to claude.

For this example, I used the `requests` library to download the image. If you don't have it installed, you can install it using `pip install requests`.

```shell
pip install requests
```

```python
import boto3
import requests

client = boto3.client("bedrock-runtime")

messages = [{"role": "user", "content": [{"text": "What is your name?"}]}]

response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

ai_message = response["output"]["message"]
messages.append(ai_message)

messages.append({"role": "user", "content": [{"text": "Can you help me?"}]})
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)
ai_message = response["output"]["message"]
messages.append(ai_message)

image_bytes = requests.get(
    "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"
).content
messages.append(
    {
        "role": "user",
        "content": [
            {"text": "What is in this image?"},
            {"image": {"format": "jpeg", "source": {"bytes": image_bytes}}},
        ],
    }
)
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
)

ai_message = response["output"]["message"]
print(ai_message)
```

Output:

```json
{
  "role": "assistant",
  "content": [
    {
      "text": "The image shows a domestic cat. The cat appears to be a tabby cat with a striped coat pattern. The cat is sitting upright and its green eyes are clearly visible, with a focused and alert expression. The background suggests an outdoor, snowy environment, with some blurred branches or vegetation visible behind the cat."
    }
  ]
}
```

As you can see, the AI was able to identify the image as a cat and provide a detailed description of the image within a conversational context.

## Step 4 - Using a single tool

For this section, let's start a new conversation with Claude and provide tools it can use.

```python
import boto3

client = boto3.client("bedrock-runtime")

tools = [
    {
        "toolSpec": {
            "name": "get_weather",
            "description": "Get the current weather in a given location",
            "inputSchema": {
                "json": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        },
                        "unit": {
                            "type": "string",
                            "enum": ["celsius", "fahrenheit"],
                            "description": "The unit of temperature, either 'celsius' or 'fahrenheit'",
                        },
                    },
                    "required": ["location"],
                }
            },
        }
    },
]
messages = [
    {
        "role": "user",
        "content": [{"text": "What is the weather like right now in New York?"}],
    }
]
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
    toolConfig={"tools": tools},
)

print(response["output"])
```

Output:

```json
{
  "message": {
    "role": "assistant",
    "content": [
      {
        "text": "Okay, let me check the current weather for New York:"
      },
      {
        "toolUse": {
          "toolUseId": "tooluse_rRwaOoldTeiRiDZhTadP0A",
          "name": "get_weather",
          "input": {
            "location": "New York, NY",
            "unit": "fahrenheit"
          }
        }
      }
    ]
  }
}
```

The output includes a `toolUse` object that indicates to us, the developers, that the AI is using the `get_weather` tool to fetch the current weather in New York. We must now fulfill the tool request by responding with the weather information.

But first, let's build a simplistic router that can handle the tool request and respond with the weather information.

```python
def get_weather(location: str, unit: str = "fahrenheit") -> dict:
    return {"temperature": "78"}

def tool_router(tool_name, input):
    match tool_name:
        case "get_weather":
            return get_weather(input["location"], input.get("unit", "fahrenheit"))
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")
```

Now, let's update the code to handle the tool request and respond with the weather information.

```python
import boto3

def get_weather(location: str, unit: str = "fahrenheit") -> dict:
    return {"temperature": "78"}

def tool_router(tool_name, input):
    match tool_name:
        case "get_weather":
            return get_weather(input["location"], input.get("unit", "fahrenheit"))
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")

client = boto3.client("bedrock-runtime")

tools = [
    {
        "toolSpec": {
            "name": "get_weather",
            "description": "Get the current weather in a given location",
            "inputSchema": {
                "json": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        },
                        "unit": {
                            "type": "string",
                            "enum": ["celsius", "fahrenheit"],
                            "description": "The unit of temperature, either 'celsius' or 'fahrenheit'",
                        },
                    },
                    "required": ["location"],
                }
            },
        }
    },
]
messages = [
    {
        "role": "user",
        "content": [{"text": "What is the weather like right now in New York?"}],
    }
]
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
    toolConfig={"tools": tools},
)

ai_message = response["output"]["message"]
messages.append(ai_message)

if response["stopReason"] == "tool_use":
    contents = response["output"]["message"]["content"]
    for c in contents:
        if "toolUse" not in c:
            continue

        tool_use = c["toolUse"]
        tool_id = tool_use["toolUseId"]
        tool_name = tool_use["name"]
        input = tool_use["input"]

        tool_result = {"toolUseId": tool_id}
        try:
            output = tool_router(tool_name, input)
            if isinstance(output, dict):
                tool_result["content"] = [{"json": output}]
            elif isinstance(output, str):
                tool_result["content"] = [{"text": output}]
            # Add more cases, such as images, if needed
            else:
                raise ValueError(f"Unsupported output type: {type(output)}")
        except Exception as e:
            tool_result["content"] = [{"text": f"An unknown error occurred: {str(e)}"}]
            tool_result["status"] = "error"

        message = {"role": "user", "content": [{"toolResult": tool_result}]}
        messages.append(message)

    response = client.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=messages,
        toolConfig={"tools": tools},
    )

print(response["output"])
```

Output:

```json
{
  "message": {
    "role": "assistant",
    "content": [
      {
        "text": "According to the weather data, the current temperature in New York, NY is 78 degrees Fahrenheit."
      }
    ]
  }
}
```

Great! We have successfully responded to the AI tool request and provided the weather information for New York.

## Step 5 - Using multiple tools

For reference, I'm adapting the [Anthropic AI Tool examples][5] from their documentation to the Bedrock Converse API.

In the previous example, we only used one tool to fetch the weather information. However, we can use multiple tools in a single conversation.

Let's add another tool to the conversation to fetch the current time and introduce a loop to handle multiple tool requests.

```python
import boto3

def get_weather(location: str, unit: str = "fahrenheit") -> dict:
    return {"temperature": "78"}

def get_time(timezone: str) -> str:
    return "12:00PM"

def tool_router(tool_name, input):
    match tool_name:
        case "get_weather":
            return get_weather(input["location"], input.get("unit", "fahrenheit"))
        case "get_time":
            return get_time(input["timezone"])
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")

client = boto3.client("bedrock-runtime")

tools = [
    {
        "toolSpec": {
            "name": "get_weather",
            "description": "Get the current weather in a given location",
            "inputSchema": {
                "json": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        },
                        "unit": {
                            "type": "string",
                            "enum": ["celsius", "fahrenheit"],
                            "description": "The unit of temperature, either 'celsius' or 'fahrenheit'",
                        },
                    },
                    "required": ["location"],
                }
            },
        }
    },
    {
        "toolSpec": {
            "name": "get_time",
            "description": "Get the current time in a given timezone",
            "inputSchema": {
                "json": {
                    "type": "object",
                    "properties": {
                        "timezone": {
                            "type": "string",
                            "description": "The IANA time zone name, e.g. America/Los_Angeles",
                        }
                    },
                    "required": ["timezone"],
                }
            },
        }
    },
]
messages = [
    {
        "role": "user",
        "content": [
            {
                "text": "What is the weather like right now in New York and what time is it there?"
            }
        ],
    }
]
response = client.converse(
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
    messages=messages,
    toolConfig={"tools": tools},
)

ai_message = response["output"]["message"]
messages.append(ai_message)

tool_use_count = 0
while response["stopReason"] == "tool_use":
    if response["stopReason"] == "tool_use":
        contents = response["output"]["message"]["content"]
        for c in contents:
            if "toolUse" not in c:
                continue

            tool_use = c["toolUse"]
            tool_id = tool_use["toolUseId"]
            tool_name = tool_use["name"]
            input = tool_use["input"]

            tool_result = {"toolUseId": tool_id}
            try:
                output = tool_router(tool_name, input)
                if isinstance(output, dict):
                    tool_result["content"] = [{"json": output}]
                elif isinstance(output, str):
                    tool_result["content"] = [{"text": output}]
                # Add more cases such as images if needed
                else:
                    raise ValueError(f"Unsupported output type: {type(output)}")
            except Exception as e:
                tool_result["content"] = [
                    {"text": f"An unknown error occurred: {str(e)}"}
                ]
                tool_result["status"] = "error"

            message = {"role": "user", "content": [{"toolResult": tool_result}]}
            messages.append(message)

        response = client.converse(
            modelId="anthropic.claude-3-haiku-20240307-v1:0",
            messages=messages,
            toolConfig={"tools": tools},
        )
        ai_message = response["output"]["message"]
        messages.append(ai_message)
        tool_use_count += 1

print(tool_use_count)
print(response["output"])
```

Output:

```json
{
  "message": {
    "role": "assistant",
    "content": [
      {
        "text": "The current time in New York is 12:00 PM.\n\nSo in summary, the weather in New York right now is 78 degrees Celsius, and the time is 12:00 PM."
      }
    ]
  }
}
```

Tool use count: `2`

We have successfully responded to the AI's tool requests and provided the weather and time information for New York.

## Conclusion

In this post, we learned how to use the Amazon Bedrock Converse API to augment converations with AI models. Not only did we leverage text and images, but we also used tools to simulate fetching external data.

The Amazon Bedrock Converse API is a powerful tool that can be used to build conversational AI applications!

[1]: https://aws.amazon.com/about-aws/whats-new/2024/05/amazon-bedrock-new-converse-api/
[2]: https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference.html#conversation-inference-supported-models-features
[3]: https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html#API_runtime_Converse_ResponseSyntax
[4]: https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg
[5]: https://docs.anthropic.com/en/docs/tool-use-examples#multiple-tools
