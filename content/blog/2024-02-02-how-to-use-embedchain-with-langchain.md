---
author: Thomas Taylor
categories:
- ai
- database
date: '2024-02-02T00:10:19-05:00'
description: 
images:
- 
tags:
- chroma-db
- generative-ai
- python
title: 'How to use Embedchain with LangChain'
---

![put image alt here](images/replace.webp)

[LangChain is a framework][1] that streamlines developing LLM applications. In a nutshell, it provides abstractions that help build out common steps and flows for working with LLMs.

In this post, we'll go over how to integrate [Embedchain, an open source RAG framework][2], with LangChain to build a chatbot with a knowledge base!

## What is Embedchain

Embedchain is an open source RAG framework aimed at allowing developers to quickly gather necessary knowledge for LLM context when answering user prompts.

In particular, it shines with its easy-to-use API for adding unstructured data into manageable and optimized chunks for retrieval. In addition, it has synchronization options to ensure data sources are frequently updated.

## Getting started with Embedchain

To showcase the power of Embedchain, let's spin up a quick demo about Ada Lovelace - "The world's first programmer".

To begin, let's install the necessary dependencies:

```shell
pip install embedchain
```

then export our `OPENAI_API_KEY`

```shell
export OPENAI_API_KEY="..."
```

## Embedchain example RAG

The following code is a basic example of RAG using Embedchain.

```python
from embedchain import Pipeline

bot = Pipeline()

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
4. Query the `chromadb` store for relevant documents and answer the question using OPEN A

## Using Embedchain with Langchain chatbot



[1]: https://www.langchain.com/
[2]: https://docs.embedchain.ai/get-started/quickstart:wqa

