---
author: Thomas Taylor
categories:
- ai
- database
- programming
date: '2024-03-03T11:50:00-05:00'
description: 
tags:
- chroma-db
- generative-ai
- python
title: 'How to use Embedchain with AWS Bedrock'
---

[LangChain is a framework][1] that streamlines developing LLM applications. In a nutshell, it provides abstractions that help build out common steps and flows for working with LLMs.

In this post, we'll go over how to integrate [Embedchain, an open source RAG framework][2], with AWS Bedrock!

## What is Embedchain

Embedchain is an open source RAG framework aimed at allowing developers to quickly gather necessary knowledge for LLM context when answering user prompts.

In particular, it shines with its easy-to-use API for adding unstructured data into manageable and optimized chunks for retrieval. In addition, it has synchronization options to ensure data sources are frequently updated.

## Getting started with Embedchain

To showcase the power of Embedchain, let's spin up a quick demo about Ada Lovelace - "The world's first programmer".

To begin, install the necessary dependencies:

```shell
pip install embedchain
```

For the sake of this example, I'm using OpenAI's API. Embedchain [supports many other models][3] as well.

```shell
export OPENAI_API_KEY="..."
```

## Embedchain example RAG

The following code is a basic example of RAG using Embedchain.

```python
from embedchain import App

bot = App()

bot.add("https://en.wikipedia.org/wiki/Ada_Lovelace")

print(bot.query("Who is Ada Lovelace?"))
```

Output:

```text
Inserting batches in chromadb: 100% 1/1 [00:00<00:00,  1.26it/s]
Successfully saved https://en.wikipedia.org/wiki/Ada_Lovelace (DataType.WEB_PAGE). New chunks count: 33
Ada Lovelace was an English mathematician and writer known for her work on Charles Babbage's proposed mechanical general-purpose computer, the Analytical Engine. She was the first to recognize that the machine had applications beyond pure calculation. Ada Lovelace was the only legitimate child of poet Lord Byron and reformer Lady Byron. She made significant contributions to the field of mathematics and is considered to be the world's first computer programmer.
```

Steps:
1. Instantiate a `Pipeline` from `embedchain`
2. Insert new documents into the pipeline
3. Automatically chunk and batch the documents into `chromadb`
4. Query the `chromadb` store for relevant documents and answer the question using OpenAI's API

For more information on [ChromaDB as a vector store, checkout my guide][6].

## Using Embedchain with AWS Bedrock and Claude

Fortunately, Embedchain directly supports AWS Bedrock as an LLM. 

### Install the dependencies

```shell
pip install embedchain[aws-bedrock]
```

We must install the `aws-bedrock` extension for `embedchain`.

### Create a config.yaml file

Add the following `config.yaml` file:

```yaml
llm:
  provider: aws_bedrock
  config:
    model: anthropic.claude-v2
    model_kwargs:
      temperature: 0.5
      top_p: 1
      top_k: 250
      max_tokens_to_sample: 200
```

The `model_kwargs` in this configuration are the defaults from the [model's arguments specified in the AWS documentation][4].

### Create main.py file

Before running the code, ensure you have AWS access. In my case, I'm using an AWS profile, but you can use any of the [supported boto3 authentication methods][5].

```python
from embedchain import App

bot = App.from_config(config_path="config.yaml")

bot.add("https://en.wikipedia.org/wiki/Ada_Lovelace")

print(bot.query("Who is Ada Lovelace?"))
```

Output:

```text
Ada Lovelace was an English mathematician and writer. Some key facts about her:

- She was the only legitimate child of poet Lord Byron and his wife Lady Byron.

- She is chiefly known for her work on Charles Babbage's proposed mechanical general-purpose computer, the Analytical Engine. She recognized the machine had applications beyond pure calculation and published the first algorithm intended to be carried out by such a machine.

- She was the first to recognize the full potential of a "computing machine" and of "programming". For this reason she is often considered the first computer programmer.

- She was interested in mathematics and logic from an early age, and pursued studies assiduously despite often being ill in her childhood.

- She married William King in 1835. He was made Earl of Lovelace in 1838, making her Countess of Lovelace.

- She died of uterine cancer in 1852 at age
```

[1]: https://www.langchain.com/
[2]: https://docs.embedchain.ai/get-started/quickstart:wqa
[3]: https://docs.embedchain.ai/components/llms
[4]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html
[5]: https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html#configuring-credentials
[6]: https://how.wtf/how-to-use-chroma-db-step-by-step-guide.html
