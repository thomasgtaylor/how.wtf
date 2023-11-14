---
author: Thomas Taylor
categories:
- programming
date: 2023-05-09 00:10:00-04:00
description: How to convert a string to lowercase in Bash
tags:
- bash
title: Convert a string to lowercase in Bash
---

Here are the top 3 ways for converting a string to lowercase in Bash.

## Using `tr`

One of the most popular ways for lowercasing a string is using `tr`. This is a POSIX standard method for accomplishing the task.

```bash
echo "I WANT this LoWeRcAsEd" | tr '[:upper:]' '[:lower:]'
# Outputs: i want this lowercased
```

## Using `awk`

Another POXIS standard is using `awk`'s native `toLower` method.

```bash
echo "I WANT this LoWeRcAsEd" | awk '{print tolower($0)}'
# Outputs: i want this lowercased
```

## Using `Bash` 4.0

`bash` 4.0 natively supports converting strings to lowercase.

```bash
toLower="I WANT this LoWeRcAsEd"
echo "${toLower,,}"
# Outputs: i want this lowercased
```