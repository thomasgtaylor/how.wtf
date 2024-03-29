---
author: Thomas Taylor
categories:
- programming
date: 2023-04-11 23:45:00-04:00
description: How to implement enums in Python
tags:
- python
title: Enums in Python
---

In Python 3.4, `Enum` support was added.

## How to implement an `Enum`

Implementing an `Enum` in Python is trivial.

```python
from enum import Enum


class PizzaSize(Enum):
    SMALL = 0
    MEDIUM = 1
    LARGE = 2


print(PizzaSize.SMALL) # PizzaSize.SMALL
print(PizzaSize.SMALL.value) # 0
print(PizzaSize.SMALL.name) # SMALL
```

As a shortcut, a `range` value may be applied:

```python
from enum import Enum


class PizzaSize(Enum):
    SMALL, MEDIUM, LARGE = range(3)


print(PizzaSize.SMALL)  # PizzaSize.SMALL
print(PizzaSize.SMALL.value)  # 0
print(PizzaSize.SMALL.name)  # SMALL
```