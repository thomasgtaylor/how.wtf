---
author: Thomas Taylor
categories:
- programming
date: '2024-01-26T03:40:00-05:00'
description: How to add typing for kwargs in Python using the typing library 
tags:
- python
title: 'Using type annotations with kwargs in Python'
---

Historically in Python, adding explicit typing for `kwargs` was not directly supported; however, Python 3.12 added that ability.

In this post, we'll go over methods for adding types to the `kwargs` argument.

## Adding type annotations to kwargs

Python 3.12 [released a new method][2] for explicitly typing `kwargs`: using a `TypedDict` + `Unpack`.

```python
from typing import NotRequired, TypedDict, Unpack


class Parameters(TypedDict):
    foo: int
    bar: str
    baz: NotRequired[str]


def some_function(**kwargs: Unpack[Parameters]) -> None:
    ...


some_function(foo=1, bar="qux")
```

Here's what happened:
- `Parameters` inherits from `TypedDict`
- `NotRequired` represents an optional argument
- `kwargs` is typed using the `Unpack[Parameters]` type

`mypy` respects the typing.

## Adding type annotations before Python 3.12

Before Python 3.12, there was not a clear way to explicitly declare typing for `kwargs`. The closest solutions are covered below.

### Using TypedDict

Instead of using `kwargs`, ditch it for a [TypedDict][1]. For example:

```python
from typing import TypedDict


class Parameters(TypedDict):
    foo: int
    bar: str
    baz: str | None


def some_function(params: Parameters) -> None:
    ...


some_function(Parameters(foo=1, bar="test", baz=None))
```

It's not great, but it provides structured typing and feedback using `mypy`.

### Using Any

Simply using `Any` will suffice with `mypy` as well:

```python
from typing import Any


def some_function(**kwargs: Any) -> None:
    ...


some_function(foo="bar")
```

But this is obviously not type safe since it disables type checking.

### Using a single type

If your use-case allows it, you may define one type for the entire `kwargs` argument:

```python
def some_function(**kwargs: str) -> None:
    ...


some_function(foo="bar", bar="qux")
```

Unfortunately, this locks you into having the same type supplied per each argument.

[1]: https://peps.python.org/pep-0589/
[2]: https://peps.python.org/pep-0692/
