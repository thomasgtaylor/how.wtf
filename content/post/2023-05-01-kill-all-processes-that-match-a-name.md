---
title: Kill all processes that match a name
date: 2023-05-30T23:40:00-04:00
author: Thomas Taylor
description: How to kill all processes that match a name
categories:
- OS
tags:
- Linux
---

Killing all processes that match a certain substring or name is easy using `pkill`.

## Killing all processes using `pkill`

`pkill` is a native Linux tool that provides command line access for killing or reloading processes. 

To kill all processes that match a pattern:

```shell
pkill -f firefox
```

If `pkill` is not successful, trying adding the `-9` flag.

```shell
pkill -9 -f firefox
```
