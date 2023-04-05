---
title: AWS Lambda caching in Python
date: 2023-04-04T23:30:00-04:00
author: Thomas Taylor
description: How to cache in an AWS Lambda function using Python
categories:
- Programming
tags:
- Python
---

Caching between lambda invocations may be useful for certain scenarios:
- Authentication
- Rate limits with external services
- Speed

## How to cache between lambda invocations

In Python, it's as simple as modifying a global variable.

```python
obj = None

def lambda_handler(event):
    global obj
    if not obj:
        obj = YourClass(event)
```

Upon initial run of a lambda function, `obj` will be set to the output of `YourClass(event)`. On subsequent _warm_ starts, the lambda function will reuse the global `obj` from the previous lambda run. More information regarding warm vs cold starts can be found [here](https://aws.amazon.com/blogs/compute/container-reuse-in-lambda/).
