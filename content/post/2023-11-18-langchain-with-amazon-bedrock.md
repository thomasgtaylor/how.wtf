---
author: Thomas Taylor
categories:
- ai
- programming
date: 2023-11-17T01:50:00-05:00
description: How to use Amazon Bedrock with Langchain
images:
- images/X6TLBR.png
tags:
- generative-ai
- python
title: Langchain with Amazon Bedrock
---

![How to use Langchain with Amazon Bedrock](images/X6TLBR.png)

In this article, we'll cover how to easily leverage Amazon Bedrock in Langchain.

## What is Amazon Bedrock?

[Amazon Bedrock](https://aws.amazon.com/bedrock) is a fully managed service that provides an API to invoke LLMs. At the time of writing, Amazon Bedrock supports:

- Anthropic Claude
- Meta Llama
- Cohere Command
- Stability AI SDXL
- A121 Labs Jurassic

with many more slated to come out!

## How to use Amazon Bedrock with Langchain

Langchain easily integrates with Amazon Bedrock via the `langchain.llms` module.

### Setup credentials

In the execution environment, ensure that the appropriate credentials are configured. This can be inferred from environment variables, the `~/.aws/credentials` configuration file, credentials in the Amazon Bedrock client, etc.

For the sake of this tutorial, I have exported my `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` pair.

```shell
export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx
```

### Create a bedrock client

Using `boto3`, a `bedrock-runtime` client can be created and passed as a parameter to the Langchain `Bedrock` class.

```python
from langchain.llms import Bedrock

import boto3

client = boto3.client("bedrock-runtime")

model = Bedrock(client=client, model_id="anthropic.claude-instant-v1")

print(model("who are you?"))
```

Output:

```text
I'm Claude, an AI assistant created by Anthropic.
```

### Creating a chain with Bedrock

Now that the `model` is instantiated, we may use it with the Langchain Expression Language (LCEL) to create a chain.

```python
from langchain.llms import Bedrock
from langchain.schema.output_parser import StrOutputParser
from langchain.prompts import ChatPromptTemplate

import boto3

client = boto3.client("bedrock-runtime")
model = Bedrock(client=client, model_id="anthropic.claude-instant-v1")
prompt = ChatPromptTemplate.from_template("write me a haiku about {topic}")

chain = prompt | model | StrOutputParser()
print(chain.invoke({"topic": "money"}))
```

Output:

```text
Here is a haiku about money:

Green paper bills flow
Endless pursuit of riches
Money rules all things
```

## Conclusion

Integrating Langchain with Amazon Bedrock unlocks many capabilities for utilizing large language models in diverse applications. This guide has demonstrated the ease of setting up this integration, enabling you to enhance your projects with AI. As Amazon Bedrock expands its model support, the potential applications and efficiencies you can achieve will only grow.
