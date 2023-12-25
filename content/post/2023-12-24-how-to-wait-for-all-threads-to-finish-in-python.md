---
author: Thomas Taylor
categories:
- programming
date: 2023-12-24T23:00:00-05:00
description: This article showcases how to wait for multiple threads to complete in Python
images:
- images/X9qZVG.png
tags:
- python
title: How to wait for all threads to finish in Python
---

![waiting for threads to finish using concurrent futures in Python](images/X9qZVG.png)

For a side project, I needed to wait for multiple threads to complete before proceeding with the next step. In other words, I needed threads to behave like the `Promise.all()` functionality of JavaScript.

## Wait for threads in Python

In the sections below, we'll discuss different methods for waitin on threads to complete in Python.

### Wait for all threads to complete using start / join

In simple terms, we can create the threads, append them to a list, then `start` and `join` them.

For example:

```python
import time
from threading import Thread


def work(interval_seconds):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")


threads = [
    Thread(target=work, args=(1,)),
    Thread(target=work, args=(2,)),
    Thread(target=work, args=(1,)),
]

for t in threads:
    t.start()

for t in threads:
    t.join()
```

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
sleeping for 1 seconds
slept for 1 seconds
slept for 1 seconds
slept for 2 seconds
```

This works well and may be all you need; however, there are alternatives.

### Wait for all threads to complete using a ThreadPoolExecutor

In Python 3.2, concurrent.futures [was released][1]. The purpose was to provide a simple high-level API for asynchronously executing callables.

There were two classes released:

- [`ThreadPoolExecutor`][2] for performing asynchronous executions using threads
- [`ProcessPoolExecutor`][3] for performing asynchronous executions using processes

Both implement the same interface, the `Executor` class, so the examples provided below will work for either. For the purposes of this tutorial, I'll use the `ThreadPoolExecutor`.

Here is the same example from above, but using the `ThreadPoolExecutor`:

```python
import time
from concurrent.futures import ThreadPoolExecutor


def work(interval_seconds):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")


with ThreadPoolExecutor(max_workers=2) as e:
    e.submit(work, 1)
    e.submit(work, 2)
    e.submit(work, 1)
```

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
slept for 1 seconds
sleeping for 1 seconds
slept for 1 seconds
slept for 2 seconds
```

The `executor` provides a `.map` function for convenience as well:

```python
import time
from concurrent.futures import ThreadPoolExecutor


def work(interval_seconds):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")


with ThreadPoolExecutor(max_workers=2) as e:
    e.map(work, [1, 2, 3])
```

### Wait for all threads to complete and return their results

Firing an forgetting is useful, but returning results was my use-case. Using `ThreadPoolExecutor` or `ProcessPoolExecutor` makes this _real_ easy.

```python
import time
from concurrent.futures import ThreadPoolExecutor, as_completed


def work(interval_seconds, order):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")
    return f"task {order}"


with ThreadPoolExecutor(max_workers=2) as e:
    futures = []
    for x in [(1, 1), (2, 2), (1, 3)]:
        futures.append(e.submit(work, x[0], x[1]))

for future in as_completed(futures):
    print(future.result())
```

In the example, I added a new parameter named `order` that represents when the item was queued.

- The first job takes 1 second and returns 1
- The second job takes 2 seconds and returns 2
- The third job takes 1 seconds and returns 3

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
slept for 1 seconds
sleeping for 1 seconds
slept for 2 seconds
slept for 1 seconds
task 2
task 1
task 3
```

### Wait for all threads to complete and return their results in order

In the last example, the results where returned out of order. Just a small tweak enables the futures to be in order:

```python
import time
from concurrent.futures import ThreadPoolExecutor, as_completed


def work(interval_seconds, order):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")
    return f"task {order}"


with ThreadPoolExecutor(max_workers=2) as e:
    futures = []
    for x in [(1, 1), (2, 2), (1, 3)]:
        futures.append(e.submit(work, x[0], x[1]))

for future in futures:
    print(future.result())
```

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
slept for 1 seconds
sleeping for 1 seconds
slept for 2 seconds
slept for 1 seconds
task 1
task 2
task 3
```

### Promise.all and Promise.allSettled using threads

For the last topic, I want to replicate the interface that NodeJS provides: `Promise.all()` and `Promise.allSettled()`.

If you're unfamiliar, `await Promise.all()` waits for all the fulfilled promises to complete. If a rejection occurs, it throws an exception. `Promise.allSettled()` waits for all promises to be rejected or fulfilled without throwing an exception.

To replicate the functionality using `concurrent.futures`, I created a `Job` `dataclass` that has three properties:

1. The `Callable` (ie. function) that will be called for the job
2. The `Tuple` of positional arguments that will be passed to the job
3. The `dict[str, Any]` of keyword arguments that will be passed to the job

```python
import concurrent.futures
import time

from dataclasses import dataclass
from typing import Callable, Any, Tuple, Optional


def work(interval_seconds, order):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")
    return f"task {order}"


@dataclass
class Job:
    func: Callable[..., Any]
    args: Tuple[Any, ...] = ()
    kwargs: dict[str, Any] = None

    def execute(self):
        return self.func(*self.args, **(self.kwargs or {}))


def all(jobs):
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(job.execute) for job in jobs]
        return [f.result() for f in futures]


jobs = [
    Job(func=work, args=(1, 1)),
    Job(func=work, args=(2, 2)),
    Job(func=work, args=(1, 3)),
]

results = all(jobs)
print(results)
```

The `all(jobs)` function accepts a list of jobs to complete.

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
sleeping for 1 seconds
slept for 1 seconds
slept for 1 seconds
slept for 2 seconds
['task 1', 'task 2', 'task 3']
```

We can extend the prior example by adding a `all_settled` function and a `JobResult` `dataclass`:

```python
import concurrent.futures
import time

from dataclasses import dataclass
from typing import Callable, Any, Tuple, Optional


def work(interval_seconds, order):
    print(f"sleeping for {interval_seconds} seconds")
    time.sleep(interval_seconds)
    print(f"slept for {interval_seconds} seconds")
    return f"task {order}"


@dataclass
class JobResult:
    status: str
    value: Optional[Any] = None
    reason: Optional[Exception] = None


@dataclass
class Job:
    func: Callable[..., Any]
    args: Tuple[Any, ...] = ()
    kwargs: dict[str, Any] = None

    def execute(self):
        return self.func(*self.args, **(self.kwargs or {}))


def all(jobs):
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(job.execute) for job in jobs]
        return [f.result() for f in futures]


def all_settled(jobs):
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(job.execute) for job in jobs]
        concurrent.futures.wait(futures)

        results = []
        for future in futures:
            if future.exception():
                results.append(JobResult(status="rejected", reason=future.exception()))
            else:
                results.append(JobResult(status="fulfilled", value=future.result()))
        return results


jobs = [
    Job(func=work, args=(1, 1)),
    Job(func=work, args=(2, 2)),
    Job(func=work, args=(1, 3)),
]

results = all_settled(jobs)
for r in results:
    print(r)
```

Output:

```text
sleeping for 1 seconds
sleeping for 2 seconds
sleeping for 1 seconds
slept for 1 seconds
slept for 1 seconds
slept for 2 seconds
JobResult(status='fulfilled', value='task 1', reason=None)
JobResult(status='fulfilled', value='task 2', reason=None)
JobResult(status='fulfilled', value='task 3', reason=None)
```

[1]: https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.Executor
[2]: https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ThreadPoolExecutor
[3]: https://docs.python.org/3/library/concurrent.futures.html#concurrent.futures.ProcessPoolExecutor
