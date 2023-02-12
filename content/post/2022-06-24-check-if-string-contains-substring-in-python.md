---
title: Check if a String Contains a Substring in Python
date: 2022-06-24T01:30:00-04:00
author: Thomas Taylor
description: Easily check if a string contains a substring or multiple substrings in Python.
categories:
- Programming
tags:
- Python
---

Checking if a string contains a substring is trivial in Python!

## The `in` Operator

The `in` operator is the most straightforward and pythonic method.

Checking if a string has a substring:

```python3
string = "howwtf"
substring = "wtf"

if substring in string:
    print("exists")
```

```text
exists
```

Checking if a string has any substrings:

```python3
string = "howwtf"
substrings = ["how", "apple"]
if any(x in string for x in substrings):
    print("exists")
```

```text
exists
```

Checking if a string has all substrings:

```python3
string = "howwtf"
substrings = ["how", "wtf"]
if all(x in string for x in substrings):
    print("all exist")
```

```text
all exist
```
