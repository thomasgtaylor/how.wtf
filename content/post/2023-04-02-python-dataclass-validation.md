---
title: Python dataclass validation
date: 2023-04-02T11:45:00-04:00
author: Thomas Taylor
description: How to validate dataclass inputs in Python
categories:
- Programming
tags:
- Python

---

Creating dataclasses in Python is simplistic; however, what if additional validation needs to be completed during initialization?

## Creating a dataclass

The following example has a class named `Person` that models information about an individual:

```python
from dataclasses import dataclass

@dataclass
class Person:
    first_name: str
    last_name: str
    age: int
```

This class can be instantiated in several ways:

```python
john = Person(first_name="john", last_name="doe", age=35)
sally = Person(first_name="sally", last_name="may", age=-20)
zachary = Person(first_name="zachary", last_name="taylor", age=12.5)
print(john) # Person(first_name='john', last_name='doe', age=35)
print(sally) # Person(first_name='sally', last_name='may', age=-20)
print(zachary) # Person(first_name='zachary', last_name='taylor', age=12.5)
```

## How to validate inputs for dataclasses

In the previous example, `sally`'s age was a non-positive integer and zachary's `age` was a float value. To resolve erroneous input, a `__post_init__` method can be used:

```python
from dataclasses import dataclass

@dataclass
class Person:
    first_name: str
    last_name: str
    age: int

    def __post_init__(self):
        if not isinstance(self.age, int):
            raise ValueError("age is not an int")
        if self.age <= 0:
            raise ValueError("age must be a positive integer greater than 0")
```

`sally`'s error:

```text
ValueError: age must be a positive integer greater than 0
```

`zachary`'s error:

```text
ValueError: age is not an int
```

