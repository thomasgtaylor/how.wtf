---
title: Promise all in Python
date: 2023-04-12T23:55:00-04:00
author: Thomas Taylor
description: How to implement the promise all method from JavaScript in Python
categories:
- Programming
tags:
- Python
---

In JavaScript, `promise.all()` returns a single promise given an iterable of promises. The returned promise is fulfilled when all the iterable promises are fulfilled. If one promise is rejected, the resulting promise is also rejected.

```javascript
try {
  const values = await Promise.all([promise1, promise2]);
  console.log(values); // [resolvedValue1, resolvedValue2]
} catch (err) {
  console.log(error); // rejectReason of any first rejected promise
}
```

## How to use `promise.all()` in Python

Python natively supports similar functionality to `promise.all()`. The method is named `asyncio.gather()`. 

```python
import asyncio

async def some_function():
	await asyncio.sleep(1)
	return 1

async def main():
    values = await asyncio.gather(
        some_function(),
        some_function()
    )
    print(values) # [1, 1]

asyncio.run(main())
```
