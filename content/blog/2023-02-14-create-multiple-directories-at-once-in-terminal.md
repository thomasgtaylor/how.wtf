---
author: Thomas Taylor
categories:
- os
date: 2023-02-14 00:00:00-04:00
description: How to create multiple directories or subdirectories at once in terminal
tags:
- linux
title: Create multiple directories at once in terminal
---

Here are different strategies for creating multiple directories/folders or subdirectories at once in a linux terminal.

## Using `mkdir` positional arguments

`mkdir` can be supplied multiple positional arguments.

```shell
mkdir dir1 dir2
```

## Using `bash` brace expansion + `mkdir`

`mkdir` can be supplied multiple positional arguments using `bash`'s brace expansion.

### Creating directories

```shell
mkdir {dir1,dir2}
```

### Creating subdirectories

`-p` flag is used to create the parent directory if it does not already exist.

```shell
mkdir -p dir/{dir1,dir2}
```

### Creating directories with `bash` sequences

```shell
mkdir dir{1..5}
```