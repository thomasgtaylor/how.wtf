---
title: Static methods in Python
date: 2023-02-21T00:40:00-04:00
author: Thomas Taylor
description: What is a static method in Python, and how do I create them?
categories:
- Programming
tags:
- Python
---

Static methods are similar to instance methods (class-level methods), except static methods behave like regular functions bound to a class namespace. Unlike instance methods, static methods do not have access to `cls` or `self`.

## Creating static methods

A class named `StringUtil` contains a `is_empty` method for determining if a string is empty.

```python3
class StringUtil:
    @staticmethod
    def is_empty(s):
        return not s.strip()

print(StringUtil.is_empty("test")) # False
print(StringUtil.is_empty(" ")) # True
```

## When to use static methods

Static methods are advantageous for:

- Singletons
- Utility classes with similar grouped methods
- Methods that belong in a class namespace, but do not require instance variables (`self`)
