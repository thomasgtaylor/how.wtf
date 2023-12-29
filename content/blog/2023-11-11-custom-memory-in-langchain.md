---
author: Thomas Taylor
categories:
- programming
- ai
date: 2023-11-11 22:10:00-05:00
description: How to implement custom memory in langchain
tags:
- python
- generative-ai
title: Custom memory in Langchain
---

Implementing custom memory in Langchain is dead simple using the `ChatMessageHistory` class.

## How to implement custom memory in Langchain (including LCEL)

One of the easiest methods for storing and retrieving messages with Langchain is using the `ChatMessageHistory` [class](https://python.langchain.com/docs/modules/memory/chat_messages/) that is provided from the `langchain.memory` module.

It's simple to get started with:

```python
from langchain.memory import ChatMessageHistory

history = ChatMessageHistory()

history.add_user_message("Hello!")

history.add_ai_message("Yo!")

print(history.messages)

# [HumanMessage(content='Hello!'), AIMessage(content='Yo!')]
```

The interface for `ChatMessageHistory` is: `add_user_message` and `add_ai_message`.

For the sake of this example, I'm using a `.json` file with preloaded messages. A database, file, etc. may be used instead.

```json
{
    "messages": [
        {
            "sender": "human",
            "body": "Hello!"
        },
        {
            "sender": "ai",
            "body": "Yo!"
        }
    ]
}
```

```python
import json

from langchain.memory import ChatMessageHistory

with open("messages.json") as json_file:
    content = json.load(json_file)

messages = content["messages"]

chat_history = ChatMessageHistory()
for m in messages:
    if m["sender"] == "human":
        chat_history.add_user_message(m["body"])
    elif m["sender"] == "ai":
        chat_history.add_ai_message(m["body"])

print(chat_history.messages)
# [HumanMessage(content='Hello!'), AIMessage(content='Yo!')]
```

The `chat_history` may be used for instantiating other types of memory!

Here is an example from the langchain [documentation](https://python.langchain.com/docs/expression_language/cookbook/memory) using the `ChatMessageHistory` with Langchain Expression Language (LCEL):

```python
import json

from operator import itemgetter

from langchain.chat_models import ChatOpenAI
from langchain.memory import ConversationBufferMemory
from langchain.schema.runnable import RunnablePassthrough, RunnableLambda
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder

with open("messages.json") as json_file:
    content = json.load(json_file)

messages = content["messages"]

chat_history = ChatMessageHistory()
for m in messages:
    if m["sender"] == "human":
        chat_history.add_user_message(m["body"])
    elif m["sender"] == "ai":
        chat_history.add_ai_message(m["body"])

model = ChatOpenAI()
prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "You are a helpful chatbot"),
        MessagesPlaceholder(variable_name="history"),
        ("human", "{input}"),
    ]
)

memory = ConversationBufferMemory(return_messages=True, chat_memory=chat_history)

chain = (
    RunnablePassthrough.assign(
        history=RunnableLambda(memory.load_memory_variables) | itemgetter("history")
    )
    | prompt
    | model
)

inputs = {"input": "hi im bob"}
response = chain.invoke(inputs)
```