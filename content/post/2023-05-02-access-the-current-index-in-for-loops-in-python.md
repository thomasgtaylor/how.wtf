---
title: Access the current index in for loops in Python
date: 2023-05-02T23:50:00-04:00
author: Thomas Taylor
description: How to access the current index in for loops in Python
categories:
- Programming
tags:
- Python
---

In Python, an iterable may be traversed using a simple for in loop:

```python
names = ["sally", "mary", "billy"]
for n in names:
	print(n)
```

However, what if the current index is desired?

## Access the index in a Python `for` loop

The _recommended_ pythonic solution is to use the built-in `enumerate` function.

```python
names = ["sally", "mary", "billy"]
for i, n in enumerate(names):
	print(i, n)
```

Output:

```text
0 sally
1 mary
2 billy
```

For contrast, the unidiomatic way to access the current index is by using `range`:

```python
names = ["sally", "mary", "billy"]
for i in range(len(names)):
	print(i, names[i])
```

Output:

```text
0 sally
1 mary
2 billy
```
