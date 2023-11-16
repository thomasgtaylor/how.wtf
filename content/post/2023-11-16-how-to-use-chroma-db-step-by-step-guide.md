---
author: Thomas Taylor
categories:
- ai
- database
date: 2023-11-16T00:45:00-05:00
description: How to use Chroma DB step-by-step Python guide
tags:
- generative-ai
- python
title: How to use Chroma DB step-by-step guide
---

Vector databases have seen an increase in popularity due to the rise of Generative AI and Large Language Models (LLMs). Vector databases can be used in tandem with LLMs for Retrieval-augmented generation (RAG) - i.e. a framework for improving the quality of LLM responses by grounding prompts with context from external systems.

## What is Chroma DB?

![Chroma DB embedding process](images/L9tqZZ.png)

Chroma is an open-source embedding database that enables retrieving relevant information for LLM prompting. It emphasizes developer productivity, speed, and ease-of-use.

Chroma provides several great features:

- Use in-memory mode for quick POC and querying.
- Reuse collections between runs with persistent memory options.
- Add and delete documents after collection creation.
- Query based on document metadata & page content.

## Installing Chroma DB

To install Chroma DB for Python, simply run the following `pip` command:

```shell
pip install chromadb
```

## Creating a vector database using Chroma DB

Chroma organizes data using a `collection` primitive type to manage collections of embeddings.

### Create a collection using default embedding function

```python
import chromadb

client = chromadb.Client()
client.create_collection(name="collection_name")
```

### Create a collection using specific embedding function

Chroma uses the `all-MiniLM-L6-v2` model for creating embeddings. When instantiating a collection, we can provide the embedding function. Here, we'll use the default function for simplicity.

```python
import chromadb
from chromadb.utils import embedding_functions

ef = embedding_functions.DefaultEmbeddingFunction()
client = chromadb.Client()
client.create_collection(name="collection_name", embedding_function=ef)
```

Chroma offers integrations with vendors such as [OpenAI][1], [Hugging Face][2], [Cohere][3] and more.

Writing a custom embed function is also supported:

```python
from chromadb import Documents, EmbeddingFunction, Embeddings

class MyEmbeddingFunction(EmbeddingFunction):
    def __call__(self, texts: Documents) -> Embeddings:
        # embed the documents somehow
        return embeddings
```

## Using collections in Chroma DB

In this section, we explore useful techniques for managing and using collections in Chroma DB.

### Delete collections

```python
import chromadb

client = chromadb.Client()
client.create_collection(name="collection_name")
client.delete_collection(name="collection_name")
```

### Get existing collection

```python
import chromadb

client = chromadb.Client()
client.create_collection(name="collection_name")
collection = client.get_collection(name="collection_name")
```

### Get or create collection

Chroma provides a convenient method for either getting an existing collection or creating a new one:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
```

### Adding data to collections

Adding data to a collection is straightforward with Chroma's API. When you pass a list of documents to Chroma, it automatically tokenizes, embeds, and stores them.

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)
```

1. The `documents` field provides the raw text for automatic conversion using the embedding function
2. `metadatas` is an optional field corresponding to the uploaded documents. It's optional but recommended for later querying.
3. `ids` is a required field for the documents. The order is important as it matches the document sequence.

### Querying data in a collection

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

results = collection.query(
    query_texts=["document"],
    n_results=2,
    where={"type": "article"}
)

print(results)
```

Output:

```text
{
    'ids': [['2', '3']],
    'distances': [
        [0.5050200819969177, 0.5763288140296936]
    ],
    'metadatas': [
        [{'type': 'article'}, {'type': 'article'}]
    ],
    'embeddings': None,
    'documents': [
        ['document2', 'document3']
    ],
    'uris': None,
    'data': None
}
```

1. The `query_texts` field provides the raw query string, which is automatically processed using the embedding function.
2. `n_results` specifies the number of results to retrieve.
3. The `where` clause enables metadata-based filtering.

In addition, the `where` field supports various operators:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

results = collection.query(
    query_texts=["document"],
    n_results=2,
    where={
        "type": {
            "$eq": "article"
        }
    }
)
```

For the list of supported operators, refer to the documentation [here](https://docs.trychroma.com/usage-guide#using-where-filters).

Filtering based on document content is also possible:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

results = collection.query(
    query_texts=["document"],
    n_results=2,
    where={"type": "article"},
    where_document={"$contains": "2"}
)

print(results)
```

Output:

```text
{
    'ids': [['2']],
    'distances': [[0.5050200819969177]],
    'metadatas': [[{'type': 'article'}]],
    'embeddings': None,
    'documents': [['document2']],
    'uris': None,
    'data': None
}
```

### Getting documents based on id in the collection

Retrieve specific documents by their IDs using the `collection.get` method:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

results = collection.get(
    ids=["1"]
)

print(results)
```

Output:

```text
{
    'ids': ['1'],
    'embeddings': None,
    'metadatas': [{'type': 'recipe'}],
    'documents': ['document1'],
    'uris': None,
    'data': None
}
```

`where` and `where_document` filters may also be used. If `ids` are not provided, all items matching the `where` and `where_document` conditions will be returned.

### Getting all documents in the collection

Retrieve all documents in a collection:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

results = collection.get()
print(results)
```

Output:

```text
{
    'ids': ['1', '2', '3'],
    'embeddings': None,
    'metadatas': [
        {'type': 'recipe'},
        {'type': 'article'},
        {'type': 'article'}
    ],
    'documents': ['document1', 'document2', 'document3'],
    'uris': None,
    'data': None
}
```

### Updating documents in a collection

Update existing documents in a collection with new embeddings or data using the `collection.update` method.

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.add(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)
collection.update(
    documents=["document10"],
    metadatas=[{"type": "article"}],
    ids=["1"]
)

results = collection.get(
    ids=["1"]
)
print(results)
```

Output:

```text
{
    'ids': ['1'],
    'embeddings': None,
    'metadatas': [{'type': 'article'}],
    'documents': ['document10'],
    'uris': None,
    'data': None
}
```

if a provided `id` is not found, an error is logged and the update is ignored.

Chroma also supports the `collection.upsert` operation as well:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.upsert(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)
```

### Deleting documents in a collection

Documents can be deleted from a collection using the `collection.delete` method:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.upsert(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

collection.delete(ids=["1"])
print(collection.count())
```

Output:

```text
2
```

Similarly to the `collection.get`, an optional `where` filter may be supplied. If no ids are supplied, it deletes all the documents that match the `where` conditions.

### Counting the number of documents in a collection

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.upsert(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)

print(collection.count())
```

Output:

```text
3
```

### Modifying an existing collection

Collection names may be modified after creation:

```python
import chromadb

client = chromadb.Client()
collection = client.get_or_create_collection(name="collection_name")
collection.modify(name="new_collection_name")
```

### Listing all collections in a client

```python
import chromadb

client = chromadb.Client()
client.get_or_create_collection(name="collection_one")
client.get_or_create_collection(name="collection_two")
print(client.list_collections())
```

Output:

```text
[Collection(name=collection_two), Collection(name=collection_one)]
```

## Persisting vector databases using Chroma DB

The in-memory Chroma client provides saving and loading to disk functionality with the `PersistentClient`.

### Saving to disk

```python
import chromadb

client = chromadb.PersistentClient(path="document_store")
collection = client.get_or_create_collection(name="collection_name")
collection.upsert(
    documents=["document1", "document2", "document3"],
    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
    ids=["1", "2", "3"]
)
```

### Loading an existing from disk

```python
import chromadb

client = chromadb.PersistentClient(path="document_store")
collection = client.get_or_create_collection(name="collection_name")
#collection.upsert(
#    documents=["document1", "document2", "document3"],
#    metadatas=[{"type": "recipe"}, {"type": "article"}, {"type": "article"}],
#    ids=["1", "2", "3"]
#)
print(collection.get())
```

Output:

```
{
    'ids': ['1', '2', '3'],
    'embeddings': None,
    'metadatas': [
        {'type': 'recipe'},
        {'type': 'article'},
        {'type': 'article'}
    ],
    'documents': ['document1', 'document2', 'document3'],
    'uris': None,
    'data': None
}
```

## Running Chroma DB as a server

Chroma may be used as a standalone server. Simply run the following command:

```shell
chroma run --path /document_store
```

Output:

```text


                (((((((((    (((((####
             ((((((((((((((((((((((#########
           ((((((((((((((((((((((((###########
         ((((((((((((((((((((((((((############
        (((((((((((((((((((((((((((#############
        (((((((((((((((((((((((((((#############
         (((((((((((((((((((((((((##############
         ((((((((((((((((((((((((##############
           (((((((((((((((((((((#############
             ((((((((((((((((##############
                (((((((((    #########



Running Chroma

Saving data to: document_store
Connect to chroma at: http://localhost:8000
Getting started guide: https://docs.trychroma.com/getting-started
```

Then connect to the local host using the `HttpClient`:

```python
import chromadb

client = chromadb.HttpClient(host="localhost", port=8000)
print(client.list_collections())
```

Output:

```text
[Collection(name=collection_name)]
```

[1]: https://docs.trychroma.com/embeddings/openai 
[2]: https://docs.trychroma.com/embeddings/hugging-face
[3]: https://docs.trychroma.com/embeddings/cohere
