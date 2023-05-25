---
title: Get key names from JSON using jq
date: 2023-05-24T23:55:00-04:00
author: Thomas Taylor
description: How to get the key names from JSON using jq
categories:
- OS
tags:
- Linux
---

Fetching the key names from a JSON document using `jq` is simple!

## Get key names of JSON using `jq`

Given a file named `example.json`,

```json
{
    "key": "value1",
    "anotherKey": "value2",
    "oneMoreKey": "value3"
}
```

extracting the keys in alphabetical order can be completed using:

```shell
jq 'keys' example.json
```

Output:

```text
[
  "anotherKey",
  "key",
  "oneMoreKey"
]
```

## Get key names of JSON unsorted using `jq`

Taking the previous JSON document `example.json`, the keys may be returned in order as they appear:

```shell
jq 'keys_unsorted' example.json
```

Output:

```text
[
  "key",
  "anotherKey",
  "oneMoreKey"
]
```

## Get key names of JSON in array of objects using `jq`

Given a file named `example.json`,

```json
[
    {
        "key1": "value1"
    },
    {
        "key2": "value2"
    }
]
```

extracting the keys from the nested array of objects can be completed using:

```shell
jq '.[] | keys' example.json
```

Output:

```text
[
  "key1"
]
[
  "key2"
]
```

If the list is required without the brackets:

```shell
jq '.[] | keys[]' example.json
```

Output:

```text
"key1"
"key2"
```

Removing the quotes is also an option:

```shell
jq -r '.[] | keys[]' example.json
```

Output:

```text
key1
key2
```
