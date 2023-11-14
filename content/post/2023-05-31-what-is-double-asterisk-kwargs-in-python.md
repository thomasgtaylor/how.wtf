---
author: Thomas Taylor
categories:
- programming
date: 2023-05-31 23:35:00-04:00
description: What does the double asterisk (**) kwargs mean in Python
tags:
- python
title: What is double asterisk kwargs in Python
---

When developing in Python, it's common to come across `**kwargs`.

## What is the double asterisk (**) in Python?

If a function parameter explictly denotes the double asterisk:

```python
def foo(**kwargs):
    print(kwargs)

foo(bar="test", baz=5)
```

`kwargs` will represent a dictionary of the key word arguments given to the function.

**NOTE**: `kwargs` is a standard name that refers to "key word arguments"; however, any name may be used.

Output:

```text
{'bar': 'test', 'baz': 5}
```