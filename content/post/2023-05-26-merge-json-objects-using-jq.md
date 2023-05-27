---
title: Merge JSON objects using jq
date: 2023-05-26T23:40:00-04:00
author: Thomas Taylor
description: How to merge JSON objects using jq
categories:
- OS
tags:
- Linux
---

Merging objects in `jq` is handled natively since 1.14.

## Merge objects using `jq`

Given a file named `example.json`

```json
{
    "key": "value1",
    "anotherKey": "value2",
    "oneMoreKey": "value3"
}
```

and another file named `example2.json`,

```json
{
  "key1": "value2",
  "key2": "value3",
  "key4": "value4"
}
```

merging the two objects can be completed using:

```shell
jq -s '.[0] * .[1]' example.json example2.json 
```

Output:

```json
{
  "key1": "value2",
  "key2": "value3",
  "key4": "value4",
  "key": "value1",
  "anotherKey": "value2",
  "oneMoreKey": "value3"
}
```
