---
author: Thomas Taylor
categories:
- programming
date: 2023-02-27 00:05:00-04:00
description: __init__ vs. __new__ methods in Python and when to use them
tags:
- python
title: Difference between init and new in Python
---

`__init__` and `__new__` are dunder methods invoked during the creation of an object instance.

## What are the differences?

1. `__new__` is used to control the creation of a new instance
2. `__init__` is used to control the initialization of an instance

|`__new__`                           |`__init__`                                |
|------------------------------------|------------------------------------------|
|Controls the creation of an instance|Controls the initialization of an instance|
|Invoked _first_ before `__init__`   |Invoked _after_ `__new__`                 |
|Returns an instance of the class    |Returns nothing                           |

`__new__` is the first step of an instance creation and is responsible for returning a new instance of the class.

In contrast, the `__init__` function initializes the instance _after_ its creation.

## Code example

In the code snippet below, `__new__` contains the `cls` class argument while `__init__` contains the `self` reference to the instance.

```python3
class Example:
    def __new__(cls, *args, **kwargs):
        print("__new__")
        return super().__new__(cls, *args, **kwargs)

    def __init__(self):
        print("__init__")


e = Example()
```

Output:

```text
__new__
__init__
```

Increment an `invoked_count` variable each time `__new__` is called:

```python3
class Example:
    invoked_count = 0

    def __new__(cls, *args, **kwargs):
        Example.invoked_count += 1
        return super().__new__(cls, *args, **kwargs)

    def __init__(self):
        print(Example.invoked_count)


e1 = Example()
e2 = Example()
```

Output

```text
1
2
```

## Use cases

`__init__` is used as a class constructor for initializing new instances.

A common use case for `__new__` is implementing the [singleton pattern](/singleton-in-python.html).