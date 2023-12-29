---
author: Thomas Taylor
categories:
- programming
date: 2023-05-19 22:45:00-04:00
description: How to check if a variable is set in Bash
tags:
- bash
title: Check if a variable is set in Bash
---

Checking if a variable is set is easy in Bash; however, there are two common scenarios:

1. Checking if a variable is empty or unset
2. Checking if a variable is unset

## Checking if a variable is empty or unset

Firstly, a simple test may be used to determine if a variable's value is empty _or_ if it's unset.

```bash
if [[ -z "$var" ]]; then
    echo "it's empty or unset"
fi
```

__OR__

```bash
var=""
if [[ -z "$var" ]]; then
    echo "it's empty or unset"
fi
```

Output:

```text
it's empty or unset
```

The `-z` tests if the string length is zero.

## Checking if a variable is unset

Checking if a variable is unset requires a different implementation.

```bash
if [[ -z "${var+set}" ]]; then
    echo "it's unset"
fi
```

Output:

```text
it's unset
```

However, if the `var` value is set to an __empty__ value:

```bash
var=
if [[ -z "${var+set}" ]]; then
    echo "it's unset"
fi
```

__OR__

```bash
var=""
if [[ -z "${var+set}" ]]; then
    echo "it's unset"
fi
```

the output will not print anything.

The `${var+set}` works because of [parameter expansion](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02):

> If parameter is unset or null, null shall be substituted; otherwise, the expansion of word (or an empty string if word is omitted) shall be substituted.