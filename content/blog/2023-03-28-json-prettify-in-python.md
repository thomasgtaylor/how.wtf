---
author: Thomas Taylor
categories:
- programming
date: 2023-03-28 00:20:00-04:00
description: How to JSON pretty print using Python
tags:
- python
title: JSON prettify in Python
---

Using the native `json` Python module, JSON data can be pretty-printed.

## Pretty print JSON string in Python

```python
import json
data = '{"users": [{"id":1,"name":"Thomas"},{"id":2,"name":"Sally"}]}'
obj = json.loads(data)
print(json.dumps(obj, indent=2))
```

**Output**:

```json
{
  "users": [
    {
      "id": 1,
      "name": "Thomas"
    },
    {
      "id": 2,
      "name": "Sally"
    }
  ]
}
```

1. The `json.loads()` method creates a Python dictionary from a given `json` string.
2. The `json.dumps()` method outputs a `json` string from a given Python dictionary. In addition, the `indent` parameter defines the level of the indent in the resulting string.

## Pretty print JSON file data in Python

```python
import json

with open("users.json", "r") as json_file:
    obj = json.load(json_file)

print(json.dumps(obj, indent=2))
```

**Output**:

```json
{
  "users": [
    {
      "id": 1,
      "name": "Thomas"
    },
    {
      "id": 2,
      "name": "Sally"
    }
  ]
}
```

1. The `json.load()` method creates a Python dictionary from a given file.
2. The `json.dumps()` method outputs a `json` string from a given Python dictionary. In addition, the `indent` parameter defines the level of the indent in the resulting string.