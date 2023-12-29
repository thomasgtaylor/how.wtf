---
author: Thomas Taylor
categories:
- programming
date: 2023-02-25 02:15:00-04:00
description: How to read environment variables from env files in Python.
tags:
- python
title: Read environment variables from file in Python
---

A `.env` file is a text file containing key value pairs of environment variables. This file is normally included with a project, but not committed to source.

## How to read `.env` files using Python

Firstly, install the `dotenv` package.

```shell
pip install python-dotenv
```

Include the folllowing lines:

```python3
from dotenv import load_dotenv

load_dotenv()
```

Using `load_dotenv()`, the application will load the `.env` file _and_ host environment variables. If this is the `.env` file for the application:

```text
VARIABLE1=test
```

Then the output will be `test` for the following snippet:
```python3
from dotenv import load_dotenv
import os

load_dotenv()

print(os.environ.get("VARIABLE1")) # outputs test
```

However, if the host environment has a `VARIABLE1` defined:

```shell
export VARIABLE1=test2
```

The output will change to `test2`.

If this is not desired behavior, the author may opt to use `dotenv_values` which returns a `dict` of values strictly parsed from the `.env` file:

```python3
from dotenv import dotenv_values

config = dotenv_values()
print(config) # outputs OrderedDict([('VARIABLE1', 'test')])
```

If the `.env` file resides on a different path than the default root directy of the project, use the `dotenv_path` option:

```python3
from dotenv import load_dotenv
from pathlib import Path

load_dotenv(dotenv_path=Path("path/to/file"))
```