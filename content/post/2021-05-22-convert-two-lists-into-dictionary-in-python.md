---
title: Convert two lists into a dictionary in Python
date: 2021-05-22T13:35:00-04:00
author: Thomas Taylor
description: How do I convert two lists into a dictionary?
categories:
- Programming
tags:
- Python
---

Converting two lists into a dictionary is a breeze in Python when using the `dict` and `zip` methods! Additionally, there are alternatives.

## Using Zip & Dict

```python
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> dict(zip(students, grades))
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```

## Dictionary Comprehension

```python
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> {s: g for s, g in zip(students, grades)}
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```

## Python <= 2.6

```python
>>> from itertools import izip
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> dict(izip(keys, values))
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```
