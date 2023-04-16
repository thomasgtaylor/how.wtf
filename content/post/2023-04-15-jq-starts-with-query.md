---
title: jq starts with query
date: 2023-04-15T23:58:00-04:00
author: Thomas Taylor
description: How use a starts with query in jq
categories:
- OS
tags:
- Linux
---

If a user wants to search a `json` payload using a `starts_with` or “begins with” or “has prefix” query, `jq` natively supports it.

## How to query using  `startswith`

Given a `json` array, searching for a specific string that `startswith` a prefix is easy.

```json
{
  "people": [
    {
      "firstName": "thomas",
      "age": 25
    },
    {
      "firstName": "sally",
      "age": 28
    }
  ]
}
```

Find each person if their name begins with `sal`. 

```shell
jq -r '.people[]|select(.firstName | startswith("sal"))' people.json
```

Output

```json
{
  "firstName": "sally",
  "age": 28
}
```
