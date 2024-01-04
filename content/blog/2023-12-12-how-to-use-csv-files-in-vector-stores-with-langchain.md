---
author: Thomas Taylor
categories:
- ai
- database
date: 2023-12-12T01:55:00-05:00
description: A guide for using CSV files in vector stores with langchain
images:
- images/yjbsz4.webp
tags:
- generative-ai
- python
title: How to use CSV files in vector stores with Langchain
---

![how to use csv files in vector stores with langchain step by step](images/yjbsz4.webp)

Retrieval-Augmented Generation (RAG) is a technique for improving an LLM's response by including contextual information from external sources. In other terms, it helps a large language model answer a question by providing facts and information for the prompt.

For the purposes of this tutorial, we will implement RAG by leveraging a Chroma DB as a vector store with the [FDIC Failed Bank List dataset][1].

## Langchain with CSV data in a vector store

A vector store leverages a vector database, like Chroma DB, to fetch relevant documents using cosine similarity searches.

Install the dependencies:

```shell
pip install langchain chromadb sentence-transformers
```

Use the following code:

```python
from langchain.document_loaders import CSVLoader
from langchain.embeddings.sentence_transformer import SentenceTransformerEmbeddings
from langchain.vectorstores import Chroma

embedding_function = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")

loader = CSVLoader("./banklist.csv", encoding="windows-1252")
documents = loader.load()

db = Chroma.from_documents(documents, embedding_function)
query = "Did a bank fail in North Carolina?"
docs = db.similarity_search(query)
print(docs[0].page_content)
```

**Steps**:
1. Use the `SentenceTransformerEmbeddings` to create an embedding function using the open source model of `all-MiniLM-L6-v2` from huggingface.
2. Instantiate the loader for the csv files from the `banklist.csv` file. I had to use `windows-1252` for the encoding of `banklist.csv`.
3. Load the files
4. Instantiate a Chroma DB instance from the documents & the embedding model
5. Perform a cosine similarity search
6. Print out the contents of the first retrieved document

## Langchain Expression with Chroma DB CSV (RAG)

After exploring how to use CSV files in a vector store, let's now explore a more advanced application: integrating Chroma DB using CSV data in a chain.

This section will demonstrate how to enhance the capabilities of our language model by incorporating RAG.

For the purposes of the following code, I opted for the OpenAI model and embeddings.

Install the dependencies:

```shell
pip install langchain chromadb openai tiktoken
```

Use the following code:

```python
from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import CSVLoader
from langchain.embeddings import OpenAIEmbeddings
from langchain.prompts import ChatPromptTemplate
from langchain.vectorstores import Chroma
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

embedding_function = OpenAIEmbeddings()

loader = CSVLoader("./banklist.csv", encoding="windows-1252")
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

print(chain.invoke("What bank failed in North Carolina?"))
```

**Borrowing from the prior example, we:**
1. Created a prompt template with `context` and `question` variables
2. Created a chain using the `ChatOpenAI` model with a retriever
3. Invoked the chain with the question `What bank failed in North Carolina?`

Output:

```text
The bank that failed in North Carolina is Blue Ridge Savings Bank, Inc.
```

[1]: https://catalog.data.gov/dataset/fdic-failed-bank-list/resource/a8cfc40d-bf6d-4716-bba6-04fdbdf5f9c1
