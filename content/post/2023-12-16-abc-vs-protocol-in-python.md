---
author: Thomas Taylor
categories:
- programming
date: 2023-12-16T12:00:00-05:00
description: This article describes the differences between ABC and Protocol and when to use them in Python
images:
- images/UlTKgH.png
tags:
- python
title: ABC vs Protocol in Python
---

![differences between ABC and Protocol](images/UlTKgH.png)

Before `typing` was [released][1] for Python, the `ABC` class reigned as champion for describing shape and behaviors of classes. After type annotations, `ABC` and `@abstractmethod` were still used to describe the behaviors: they felt 'interface-like'.

Then, `Protocol` was [released][2] and introduced a new way for declaring class behaviors.

## Should you use ABC or Protocol?

Before describing why or why not you should choose one over the other, let's delve into what each of them are.

### What is ABC or Abstract Base Classes?

[Abstract Base Classes][3], or ABC, is a a module that provides infrastructure to define abstract classes in Python.

As previously stated, they predated type hinting and were the go-to for enforcing class behaviors. Their goal was to provide a standardized means to test if an object adhered to a given specification.

For example,

```python
from abc import ABC, abstractmethod


class Readable(ABC):
    @abstractmethod
    def read(self):
        pass


class Stream(Readable):
    def read(self):
        return "read!"


class FileReader(Readable):
    def read(self):
        return "some lines from a file"

```

ABCs use nominative subtyping by default: ie. you must explicitly inherit from a superclass to be considered a subtype.

Although, they do have a `register` method that enables a structural-like typing:

```python
from abc import ABC, abstractmethod


class Readable(ABC):
    @abstractmethod
    def read(self):
        pass


class Stream:
    def read(self):
        return "read!"


Readable.register(Stream)

```

### What is Protocol

Protocols are intended to make static checking easier - without needing to use an `isinstance` check at runtime.

They are treated as formalized duck typing - ie. the class only has to have the same attributes and methods... NOT be an `instanceof`.

Taking our class from earlier,

```python
from typing import Protocol


class Readable(Protocol):
    def read(self) -> str: ...

```

We can implement the `Protocol` in different ways:

```python
class Stream:
    def read(self) -> str:
        return "read!"

```

OR explicitly

```python
class Stream(Readable):
    def read(self) -> str:
        return "read!"

```

Additionally, we can enforce runtime evaluation using the `runtime_checkable` decorator:

```python
from typing import Protocol, runtime_checkable


@runtime_checkable
class Readable(Protocol):
    def read(self) -> str: ...


class Stream(Readable):
    def read(self) -> str:
        return "read!"

```

### Which is preferred?

From my perspective, `Protocol` wins. Given Python's emphasis on duck typing ("if it walks and quacks like a duck, then it must be a duck"), it makes sense to opt for `Protocol`.

If there is a need to enforce runtime checks, it has that covered with the `@runtime_checkable`.

Protocol Pros:
- Short syntax
- Aligns with the "duck typing" mentality
- Supports implicit or explicit declaration
- Supports runtime enforcement

Protocol Cons:
- Only available in Python 3.8 or above

[1]: https://docs.python.org/3/library/typing.html
[2]: https://peps.python.org/pep-0544/
[3]: https://docs.python.org/3/library/abc.html
