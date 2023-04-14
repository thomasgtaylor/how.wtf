---
title: Difference between is and equal in Python
date: 2023-04-13T23:30:00-04:00
author: Thomas Taylor
description: What is the difference between is and = in Python?
categories:
- Programming
tags:
- Python
---

In Python, there are two operators for determining equality: `is` and `==`; however, what are the differences between them and when should one be used over the other?

## What is the difference between the `is` and `==`

1. The `is` operator checks for **object identity**
2. The `==` operator checks for **equality**

Here is an example demonstrating the differences:

```python
foo = [1, 2, 3]
bar = foo
print(foo is bar) # True
print(foo == bar) # True
```

In the example above, `bar` points to the same object reference as `foo`. Because `foo` and `bar` point to the same object, `is` reports true.

If a _copy_ of `foo`'s list is assigned to `bar`,

```python
bar = foo[:]
print(foo is bar) # False
print(foo == bar) # True
```

`is` reports `False` since the two variables do _not_ point to the same object.

## When to use which?

As a general rule of thumb, use the `is` operator for the following use-cases:

1. Verify if two objects are the same object (not just the value)
2. Comparison against constants: `None`.

As stated in the [PEP 8 style guide](https://peps.python.org/pep-0008/#programming-recommendations),

> Comparisons to singletons like None should always be done with `is` or `is  not`, never the equality operators.

Outside of those two use cases, **default to using the `==` or `!=` operators**.
