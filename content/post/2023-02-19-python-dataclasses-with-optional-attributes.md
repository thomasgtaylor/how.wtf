---
title: Python dataclasses with optional fields
date: 2023-02-19T01:20:00-04:00
author: Thomas Taylor
description: How to create dataclasses with optional fields in Python.
categories:
- Programming
tags:
- Python
---

How do I create dataclasses in Python with optional fields? 

## How does a dataclass work?

Dataclasses generate dunder methods on the user's behalf. Instead of defining `__init__`, `__eq__`, etc. manually, these methods are provided out of the box simply be defining fields and their respestive types.

```python3
from dataclasses import dataclass

@dataclass
class Person
    name: str
    age: int
```

Because the methods and constructor are generated, the attributes are checked and hardcoded. 

## Optional fields in dataclasses

There are options for making an argument optional with dataclasses.

### Using `Optional[str]` and a default value

It is possible to make an optional argument by using a default value for the attribute.

```python3
from dataclasses import dataclass
from typing import Optional

@dataclass
class Person
    name: str
    age: int
    email: Optional[str] = None

print(Person(name="john", age=35)) # Person(name='john', age=35, email=None)
```

### Using `InitVar`

`InitVar` is passed to the `__init__` and `__post_init__` methods, but is not stored as a class attribute. This can be valuable for some use-cases.

If a movie is not published, mark it as hidden.

```python3
from dataclasses import dataclass, field, InitVar
from typing import Optional

@dataclass
class Movie:
    title: str
    hidden: bool = field(init=False)
    is_published: InitVar[Optional[bool]] = True

    def __post_init__(self, is_published):
        self.hidden = not(is_published)

print(Movie(title="title", is_published=False)) # Movie(title='title', hidden=True)
print(Movie(title="title", is_published=True)) # Movie(title='title', hidden=False)
print(Movie(title="title")) # Movie(title='title', hidden=False)
```
