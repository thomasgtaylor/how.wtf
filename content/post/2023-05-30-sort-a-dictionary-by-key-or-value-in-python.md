---
title: Sort a dictionary by key or value in Python
date: 2023-05-30T23:35:00-04:00
author: Thomas Taylor
description: How to sort a dictionary by key or value in Python
categories:
- Programming
tags:
- Python
---

Sorting based on a dictionary value or key is _easy_ using Python.

## Sort by value in a dictionary

In Python 3.7 and above, a combination of dictionary comprehension and `sorted` can be used:

```python
foo = {"first": 1, "third": 3, "second": 2, "zeroth": 0}
print({k: v for k, v in sorted(foo.items(), key=lambda i: i[1])})
```

In addition,

```python
foo = {"first": 1, "third": 3, "second": 2, "zeroth": 0}
print(dict(sorted(foo.items(), key=lambda i: i[1])))
```

Output:

```text
{'zeroth': 0, 'first': 1, 'second': 2, 'third': 3}
```

`sorted` allows a optional keyword argument of `key`: a function to execute for ordering.

## Sort by key in a dictionary

Similar to the technique before, the `lambda` argument can reference the 0th index to sort by the dictionary keys.

```python
foo = {"first": 1, "third": 3, "second": 2, "zeroth": 0}
print({k: v for k, v in sorted(foo.items(), key=lambda i: i[0])})
```

Output:

```text
{'first': 1, 'second': 2, 'third': 3, 'zeroth': 0}
```
