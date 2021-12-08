Title: Convert Two Lists into a Dictionary in Python
Date: 2021-05-22 1:35
Category: Programming
Tags: Python
Authors: Thomas Taylor
Description: How do I convert two lists into a dictionary?

Converting two lists into a dictionary is a breeze in Python when using the `dict` and `zip` methods! Additionally, there are alternatives.

# Using Zip & Dict

```python
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> dict(zip(students, grades))
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```

# Dictionary Comprehension

```python
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> {s: g for s, g in zip(students, grades)}
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```

# Python <= 2.6

```python
>>> from itertools import izip
>>> students = ["Cody", "Ashley", "Kerry"]
>>> grades = [93.5, 95.4, 82.8]
>>> dict(izip(keys, values))
{'Cody': 93.5, 'Ashley': 95.4, 'Kerry': 82.8}
```