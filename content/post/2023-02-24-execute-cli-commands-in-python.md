---
author: Thomas Taylor
categories:
- programming
date: 2023-02-24 23:45:00-04:00
description: How to execute CLI commands or shell scripts using Python.
tags:
- python
title: Execute CLI commands in Python
---

Executing CLI commands / shell scripts / external programs in Python is easy.

## Use `subprocess.run`

Since Python 3.5 (`subprocess.call` for earlier versions), `subprocess.run` is the recommended way to execute external shell scripts.

```python3
import subprocess

output = subprocess.run(["echo", "hello", "world"], capture_output=True)
print(output.returncode) # outputs 0
print(output.stdout.decode("utf-8")) # outputs hello world
```