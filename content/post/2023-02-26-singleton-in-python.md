---
author: Thomas Taylor
categories:
- programming
date: 2023-02-26 00:00:00-04:00
description: How to implement the singleton design pattern in Python.
tags:
- python
title: Singleton in Python
---

The Singleton pattern enforces having one instance of a class. This tutorial will showcase how to implement the singleton pattern in Python.

## Implementing the Singleton pattern

Using the `__new__` dunder method, the creation of the object can be controlled since `__new__` is called before the `__init__` method.

```python3
class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Singleton, cls).__new__(cls)
        return cls._instance

s1 = Singleton()
s2 = Singleton()
print(s1 == s2) # outputs True
```

`s1` and `s2` are the same object in memory.

## Why is this beneficial?

The singleton pattern is useful for certain cases:

1. Logger
2. Thread Pooling
3. Caching
4. Configuration