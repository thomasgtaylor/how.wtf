---
title: Ternary operator in Python
date: 2023-03-15T01:30:00-04:00
author: Thomas Taylor
description: Ternary operator in Python code
categories:
- Programming
tags:
- Python
---

The ternary operator is an in-line if/else statement that many languages support natively; however, Python does not have a specific operator. Instead, it uses [conditional expression resolution](https://mail.python.org/pipermail/python-dev/2005-September/056846.html) which was added in Python 2.5.

## In-line if/else statement

An in-line if/else statement in Python looks like the following:

```python3
'true' if True else 'false'
```

Output:

```text
'true'
```

Breaking down the syntax,

```python3
true_value if condition else false_value
```

Return the value of the "idle" stage for a blue/green deployment.

```python3
def get_active_stage():
    # logic to get the active stage
    return "blue"

idle_stage = "green" if get_active_stage() == "blue" else "blue"
print(stage)
```

Output:

```text
green
```
