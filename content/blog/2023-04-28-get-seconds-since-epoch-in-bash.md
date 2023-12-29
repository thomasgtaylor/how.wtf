---
author: Thomas Taylor
categories:
- programming
date: 2023-04-28 23:50:00-04:00
description: How to get the seconds since Epoch using Bash
tags:
- bash
title: Get seconds since Epoch in Bash
---

`bash` 5.0 natively supports retrieving seconds since Epoch using a variable.

## Native `bash` method

```bash
echo $EPOCHSECONDS # 1682740449
```

If seconds are preferred:

```bash
echo $EPOCHREALTIME # 1682740449.252199
```

If milliseconds are preferred:

```bash
echo $(( ${EPOCHREALTIME/./} / 1000 )) # 1682740449252
```

## Using `date`

In addition to using the native `bash` method, `date` may be used.

According to the `date` manual:
> %s seconds since the Epoch (1970-01-01 00:00 UTC)

```bash
echo $(date +%s) # 1682740326
```

If milliseconds seconds are preferred:

```bash
echo $(date +%s%3N) # 1682740449252
```