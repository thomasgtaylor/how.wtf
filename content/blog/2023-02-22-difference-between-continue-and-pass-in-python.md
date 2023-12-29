---
author: Thomas Taylor
categories:
- programming
date: 2023-02-22 00:10:00-04:00
description: When to use continue vs. pass in Python.
tags:
- python
title: Difference between continue and pass in Python
---

## Using the `continue` statement

A `continue` statement is used within a for loop to skip the remainder of the current iteration. Essentially, the `continue` statement will simply skip to the next iteration.

A normal `for` loop that prints the current index `i`:

```python3
for i in range(3):
    print(i)
```

```text
0
1
2
```

The same for loop, with a conditional and a `continue`:

```python3
for i in range(3):
    if i == 1:
        continue
    print(i)
```

```text
0
2
```

On the second iteration of the for loop (when `i = 1`), the `continue` statement stopped the current iteration and "continued" to the next.

## Using the `pass` statement

As implied by the name, the `pass` state does nothing.

```python3
for i in range(3):
    if i == 1:
        pass
    print(i)
```

```text
0
1
2
```

This is most useful when defining placeholders for future code to satisfy the interpreter.

```python3
def func():
    pass
```