---
author: Thomas Taylor
categories:
- ai
- database
date: '2024-01-28T05:35:00-05:00'
description: A guide for using JSON files in vector stores with langchain
images:
- images/6YHOAH.webp
tags:
- chroma-db
- generative-ai
- python
title: How to use JSON files in vector stores with Langchain
---

![How to use JSON files in vector stores with langchain step by step](images/6YHOAH.webp)

Retrieval-Augmented Generation (RAG) is a technique for including contextual information from external sources in a large language model's (LLM) prompt. In other terms, RAG is used to supplement an LLM's answer by providing more information in the prompt; thus, removing the need to retrain or fine-tune a model.

For the purposes of this post, we will implement RAG by using Chroma DB as a vector store with the [Nobel Prize data set][1].

## Langchain with JSON data in a vector store

Chroma DB will be the vector storage system for this post. It's easy to use, open-source, and provides additional filtering options for associated metadata.

### Getting started

To begin, install `langchain`, `langchain-community`, `chromadb` and `jq`.

```shell
pip install langchain langchain-community chromadb jq
```

`jq` is required for the `JSONLoader` class. Its purpose is to parse the JSON file and its contents.

### Fetching relevant documents using document loaders

For reference, the `prize.json` file has the following schema:

```json
{
    "prizes": [
        {
            "year": "string",
            "category": "string",
            "laureates": [
                {
                    "id": "string",
                    "firstname": "string",
                    "surname": "string",
                    "motivation": "string",
                    "share": "string"
                }
            ]
        }
    ]
}
```

with the `laureates` being optional since some years do not have any winners.

The following code is used to simply fetch relevant documents from Chroma.

```python
from langchain_community.document_loaders import JSONLoader
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain_community.vectorstores import Chroma

embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

loader = JSONLoader(file_path="./prize.json", jq_schema=".prizes[]", text_content=False)
documents = loader.load()

db = Chroma.from_documents(documents, embedding_function)
query = "What year did albert einstein win the nobel prize?"
docs = db.similarity_search(query)
print(docs[0].page_content)
```

**Steps**:
1. Use the `SentenceTransformerEmbeddings` to create an embedding function using the open source model of `all-MiniLM-L6-v2` from huggingface.
2. Instantiate the loader for the JSON file using the `./prize.json` path.
3. Load the files
4. Instantiate a Chroma DB instance from the documents & the embedding model
5. Perform a cosine similarity search
6. Print out the contents of the first retrieved document

Output:

```json
{"year": "1921", "category": "physics", "laureates": [{"id": "26", "firstname": "Albert", "surname": "Einstein", "motivation": "\"for his services to Theoretical Physics, and especially for his discovery of the law of the photoelectric effect\"", "share": "1"}]}
```

The `text_content=False` flag allows each array JSON document entry to be vectorized. This works for this use case, but you may want something different.

For example, let's vectorize the contents of the `motivation` text attribute and add metadata about each motivation:

```python
from langchain_community.document_loaders import JSONLoader
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain_community.vectorstores import Chroma


def metadata_func(record: dict, metadata: dict) -> dict:
    metadata["id"] = record.get("id")
    metadata["firstname"] = record.get("firstname")
    metadata["surname"] = record.get("surname")
    metadata["share"] = record.get("share")
    return metadata


embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

loader = JSONLoader(
    file_path="./prize.json",
    jq_schema=".prizes[].laureates[]?",
    content_key="motivation",
    metadata_func=metadata_func,
)
documents = loader.load()
print(documents)
```

**Steps**:
1. Use the `SentenceTransformerEmbeddings` to create an embedding function using the open source model of `all-MiniLM-L6-v2` from huggingface.
2. Instantiate the loader for the JSON file using the `./prize.json` path.
  1. Use the `?` jq syntax to ignore nullables if `laureates` does not exist on the entry 
  2. Use a `metadata_func` to grab the fields of the JSON to put in the document's metadata
  3. Use the `content_key` to specify which field is used for the vector text
3. Load the files
4. Instantiate a Chroma DB instance from the documents & the embedding model
6. Print out the loaded documents

Output:

```text
[
    Document(
        page_content='"for the discovery and synthesis of quantum dots"',
        metadata={
            'source': 'path/to/prize.json',
            'seq_num': 1,
            'id': '1029',
            'firstname': 'Moungi',
            'surname': 'Bawendi',
            'share': '3'
        }
    ),
    ...
]
```

**Note**: The `metadata_func` is only required if you want to add your own arbitrary metadata. If that's not a concern, you can omit it and use the `jq_schema`.

```python
from langchain_community.document_loaders import JSONLoader
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain_community.vectorstores import Chroma

embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

loader = JSONLoader(
    file_path="./prize.json",
    jq_schema=".prizes[].laureates[]?.motivation",
)
documents = loader.load()
```

## Langchain Expression with Chroma DB JSON (RAG)

After exploring how to use JSON files in a vector store, let's integrate Chroma DB using JSON data in a chain.

For the purposes of this code, I used OpenAI model and embeddings.

Install the following dependencies:

```shell
pip install langchain langchain-community langchain-openai chromadb jq
```

Then run the following code:

```python
from langchain.prompts import ChatPromptTemplate

from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders import JSONLoader
from langchain_community.embeddings import OpenAIEmbeddings

from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

from langchain_openai import ChatOpenAI, OpenAIEmbeddings

embedding_function = OpenAIEmbeddings()

loader = JSONLoader(file_path="./prize.json", jq_schema=".prizes[]", text_content=False)
documents = loader.load()

db = Chroma.from_documents(documents, embedding_function)
retriever = db.as_retriever()

template = """Answer the question based only on the following context:
{context}

Question: {question}
"""
prompt = ChatPromptTemplate.from_template(template)

model = ChatOpenAI()

chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | model
    | StrOutputParser()
)

query = "What year did albert einstein win the nobel prize?"
print(chain.invoke(query))
```

**Steps**:
1. Use the `OpenAIEmbeddings` to create an embedding function
2. Load the JSON file
3. Instantiate the Chroma DB instance from the documents & embedding model
4. Create a prompt template with `context` and `question` variables
5. Create a chain using the `ChatOpenAI` model with a retriever
6. Invoke the chain with the question `What year did albert einstein win the nobel prize?`

Output:

```text
Albert Einstein won the Nobel Prize in the year 1921.
```

This tutorial only includes the basic functionality for Chroma DB. Please visit my [Chroma DB guide][2] where I walk step-by-step on how to use it for a more in-depth tutorial.

[1]: https://api.nobelprize.org/v1/prize.json
[2]: https://how.wtf/how-to-use-chroma-db-step-by-step-guide.html
