---
author: Thomas Taylor
categories:
- programming
date: 2023-03-10 00:45:00-04:00
description: How to convert an OrderedDict or a nested OrderedDict to a dictionaryin Python
tags:
- python
title: Convert OrderedDict to dict in Python
---

Upon first glance, converting an `OrderedDict` seems intuitive.

## Convert `OrderedDict` to `dict`

```python3
from collections import OrderedDict

od1 = OrderedDict([("key1", "value1"), ("key2", "value2")])

d1 = dict(od1)
print(d1)
```

Output:

```text
{'key1': 'value1', 'key2': 'value2'}
```

## Convert nested `OrderedDict`s to `dict`

However, if an `OrderedDict` has nested types of `OrderedDict`s, this method will not convert the nested `OrderedDict` types to dictionaries:

```python3
from collections import OrderedDict

od1 = OrderedDict(
    [
        ("key1", "value1"),
        ("key2", "value2"),
        ("key3", OrderedDict([("key3", "value3")])),
    ]
)

d1 = dict(od1)
print(d1)
```

Output:

```text
{'key1': 'value1', 'key2': 'value2', 'key3': OrderedDict([('key3', 'value3')])}
```

Instead, a combination of `json.loads()` and `json.dumps()` can be used.

```python3
from collections import OrderedDict
import json

od1 = OrderedDict(
    [
        ("key1", "value1"),
        ("key2", "value2"),
        ("key3", OrderedDict([("key3", "value3")])),
    ]
)

d1 = json.loads(json.dumps(od1))
print(d1)
```

Output:

```text
{'key1': 'value1', 'key2': 'value2', 'key3': {'key3': 'value3'}}
```