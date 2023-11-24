---
author: Thomas Taylor
categories:
- ai
- programming
date: 2023-11-24T01:00:00-05:00
description: How to track Amazon Bedrock Anthropic tokens with Langchain
images:
- images/bmY6Bu.png
tags:
- generative-ai
- python 
title: How to count Amazon Bedrock Anthropic tokens with Langchain
---

![Count Amazon Bedrock Anthropic tokens with Langchain](images/bmY6Bu.png)

Tracking Amazon Bedrock Claude token usage is simple using Langchain!

## How to track tokens using Langchain

For OpenAI models, Langchain provides a native Callback handler for tracking token usage as [documented here][1].

```python
from langchain.callbacks import get_openai_callback
from langchain.llms import OpenAI

llm = OpenAI(temperature=0)
with get_openai_callback() as cb:
    llm("What is the square root of 4?")

total_tokens = cb.total_tokens
assert total_tokens > 0
```

However, other model families do not have this luxury.

## Counting Anthropic Bedrock Tokens

Anthropic released a Bedrock client for their models that provides a method for counting tokens. I wrote an entire article about how to use it [here][2].

Under the hood, Langchain uses the Anthropic client within the Bedrock LLM class to provide token counting.

## How to count tokens using Langchain Bedrock LLM Step-by-Step

Before starting, please review my post about using Bedrock with Langchain [here][3]. It describes how to use `boto3` with `langchain` to easily instantiate clients. For the sake of this tutorial, I'll assume you already have your AWS session configured.

### Installation

Firstly, install the required libraries:

```shell
pip3 install anthropic boto3 langchain
```

### Counting Bedrock LLM tokens

To keep it simple, we'll begin by importing the Bedrock LLM and counting the input and output tokens.

```python
from langchain.llms import Bedrock

import boto3

client = boto3.client("bedrock-runtime")

llm = Bedrock(client=client, model_id="anthropic.claude-instant-v1")
prompt = "who are you?"
print(llm.get_num_tokens(prompt))

result = llm(prompt)
print(result, llm.get_num_tokens(result))
```

Output:

```text
4
My name is Claude. I'm an AI assistant created by Anthropic. 16
```

In this case, 4 input tokens and 16 output tokens were used.

### Counting Bedrock LLM tokens in chain

For my use case, I need to count the tokens used in chains. We'll need to build a custom handler since Langchain does not provide native support for counting Bedrock tokens.

For more information on Callback handlers, please reference the Langchain documentation [here][4].

In the code below, I extended the `BaseCallbackHandler` class with `AnthropicTokenCounter`. In the constructor, a Bedrock LLM client is required since it contains the token counting function.

```python
from langchain.callbacks.base import BaseCallbackHandler

import boto3


class AnthropicTokenCounter(BaseCallbackHandler):
    def __init__(self, llm):
        self.llm = llm
        self.input_tokens = 0
        self.output_tokens = 0

    def on_llm_start(self, serialized, prompts, **kwargs):
        for p in prompts:
            self.input_tokens += self.llm.get_num_tokens(p)

    def on_llm_end(self, response, **kwargs):
        results = response.flatten()
        for r in results:
            self.output_tokens = self.llm.get_num_tokens(r.generations[0][0].text)
```

1. The `on_llm_start` function supplies a list of prompts. For each prompt, I add the tokens to an instance property named `input_tokens`.
2. The `on_llm_end` function supplies a `LLMResult`.
  1. The `LLMResult`, as I discovered in the [source code][5], has a `flatten()` method that converts a `LLMResult` to a list of `LLMResult`s with 1 generation.
  2. I add the tokens to an instance property named `output_tokens`.

I used the callback handler when calling the custom chain:

```python
from langchain.llms import Bedrock
from langchain.prompts import ChatPromptTemplate
from langchain.callbacks.base import BaseCallbackHandler

import boto3


class AnthropicTokenCounter(BaseCallbackHandler):
    def __init__(self, llm):
        self.llm = llm
        self.input_tokens = 0
        self.output_tokens = 0

    def on_llm_start(self, serialized, prompts, **kwargs):
        for p in prompts:
            self.input_tokens += self.llm.get_num_tokens(p)

    def on_llm_end(self, response, **kwargs):
        results = response.flatten()
        for r in results:
            self.output_tokens = self.llm.get_num_tokens(r.generations[0][0].text)


client = boto3.client("bedrock-runtime")

llm = Bedrock(client=client, model_id="anthropic.claude-instant-v1")

prompt = ChatPromptTemplate.from_template("tell me a joke about {subject}")
chain = prompt | llm

token_counter = AnthropicTokenCounter(llm)
print(chain.invoke({"subject": "ai"}, config={"callbacks": [token_counter]}))
print(token_counter.input_tokens)
print(token_counter.output_tokens)
```

Output:

```text
Here's one: Why can't AI assistants tell jokes? Because they lack a sense of humor!
8
20
```

[1]: https://python.langchain.com/docs/modules/callbacks/token_counting
[2]: https://how.wtf/how-to-count-amazon-bedrock-claude-tokens-step-by-step-guide.html
[3]: https://how.wtf/langchain-with-amazon-bedrock.html
[4]: https://python.langchain.com/docs/modules/callbacks/custom_callbacks
[5]: https://github.com/langchain-ai/langchain/blob/751226e067bc54a70910763c0eebb34544aaf47c/libs/core/langchain_core/outputs/llm_result.py#L22
