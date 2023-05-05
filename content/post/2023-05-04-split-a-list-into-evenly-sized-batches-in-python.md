---
title: Split a list into evenly sized batches in Python
date: 2023-05-04T21:30:00-04:00
author: Thomas Taylor
description: How to split a list into evenly sized batches or chunks in Python
categories:
- Programming
tags:
- Python
---

Splitting a list into evenly sized chunks or batches can be accomplished using Python.

## Using `itertools.batched`

In Python 3.12, `itertools.batched` is available for [consumption](https://docs.python.org/3.12/library/itertools.html?highlight=batched#itertools.batched). 

```python
import itertools

lst = ['mary', 'sam', 'joseph']
print(list(itertools.batched(lst, 2))) # [('mary', 'sam'), ('joseph')]
```

## Using `yield`

If the version of Python is lower than 3.12, the `yield` keyword may be used.

```python
def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

lst = ['mary', 'sam', 'joseph']
print(list(chunks(lst, 2))) # [['mary', 'sam'], ['joseph']]
```

## Using `itertools.islice`

The `itertools.islice` function can additionally be used.

```python
from itertools import islice

def chunks(lst, n):
    it = iter(lst)
    return iter(lambda: tuple(islice(it, n)), ())

lst = ['mary', 'sam', 'joseph']
print(list(chunks(lst, 2))) # [('mary', 'sam'), ('joseph',)]
```
