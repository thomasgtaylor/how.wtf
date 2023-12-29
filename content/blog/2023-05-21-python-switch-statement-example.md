---
author: Thomas Taylor
categories:
- programming
date: 2023-05-21 23:55:00-04:00
description: How to create a switch statement in Python
tags:
- python
title: Python switch statement example
---

Python 3.10 added support for the `switch` keyword.

## Implement switch statements in Python

The basic syntax for a switch statement is:

```python
match term:
    case pattern1:
        some_action
    case pattern2:
        some_other_action
    case _:
        default_action
```

A direct example:

```python
pizza_size = 0
match pizza_size:
    case 0:
        print("small pizza")
    case 1:
        print("medium pizza")
    case 2:
        print("large pizza")
    case _:
        print("pizza size is not valid")
```

Output:

```text
small pizza
```

In Python, `break` statements are not required.