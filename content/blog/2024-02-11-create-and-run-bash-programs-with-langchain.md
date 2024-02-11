---
author: Thomas Taylor
categories:
- ai
date: '2024-02-11T11:45:00-05:00'
description: A guide for creating and running Bash programs using LangChain and OpenAI
tags:
- generative-ai
- python
title: 'Create and run Bash programs with LangChain'
---

Using LangChain, we can create a prompt to output a `bash`, which is then executed via the `BashProcess` tool.

All of this is as easy as a few lines of Python code!

## How to generate bash scripts using LangChain

First, let's install the necessary dependencies:

```shell
pip install langchain-core langchain-experimental langchain-openai
```

Now, let's write a simplistic prompt to get OpenAI to output bash code. 

For this example, we'll target a script that outputs:

```text
Hello world!
```

Script:

```python
from langchain_core.output_parsers import StrOutputParser
from langchain_experimental.llm_bash.bash import BashProcess
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate


def sanitize_output(text: str):
    _, after = text.split("```bash")
    return after.split("```")[0]


template = """Write some bash code to solve the user's problem. 

Return only bash code in Markdown format, e.g.:

```bash
....
```"""
prompt = ChatPromptTemplate.from_messages([("system", template), ("human", "{input}")])

model = ChatOpenAI()

chain = prompt | model | StrOutputParser() | sanitize_output | BashProcess().run

print(chain.invoke({"input": "Print 'Hello world!' to the console"}))
```

Output:

```text
Hello world!

```

Using LangChain Expression Language (LCEL), we constructed a `chain` by using the pipe operator to combine:

1. prompt
2. model
3. StrOutputParser
4. sanitize_output
5. BashProcess().run

This example was adapted from the ["Code Writing" cookbook][1] provided in the Langchain documentation.

The `sanitize_output` function extracts the `bash` code from the markdown output and pipes it to the `BashProcess` tool. To learn more about the [bash process tool, visit the documentation][2].

[1]: https://python.langchain.com/docs/expression_language/cookbook/code_writing
[2]: https://api.python.langchain.com/en/stable/llm_bash/langchain_experimental.llm_bash.bash.BashProcess.html#langchain_experimental.llm_bash.bash.BashProcess
