---
title: Iterate through two lists in parallel in Python
date: 2023-05-29T21:30:00-04:00
author: Thomas Taylor
description: How to iterate through two lists in parallel in Python
categories:
- Programming
tags:
- Python
---

Iterating through a two lists in parallel is natively handled in Python using the `zip` function.

## Iterate through two lists using `zip`

Python's `zip` function will aggregate elements from two or more iterables.

```python
foo = ["x", "y", "z"]
bar = [1, 2, 3]

for f, b in zip(foo, bar):
  print(f, b)
```

Output:

```text
x 1
y 2
z 3
```

This works with any number of iterables:

```python
foo = ["x", "y", "z"]
bar = [1, 2, 3]
baz = ["!", "@", "#"]

for f, b, z in zip(foo, bar, baz):
  print(f, b, z)
```

Output:

```text
x 1 !
y 2 @
z 3 #
```

If the index is necessary, use `enumerate`:

```python
foo = ["x", "y", "z"]
bar = [1, 2, 3]

for i, (f, b) in enumerate(zip(foo, bar)):
  print(i, f, b)
```

Output:

```text
0 x 1
1 y 2
2 z 3
```
