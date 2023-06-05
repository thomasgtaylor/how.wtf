---
title: rev command in Linux and how to reverse strings
date: 2023-06-04T23:00:00-04:00
author: Thomas Taylor
description: What is the rev command in Linux?
categories:
- OS
tags:
- Linux
---

What is the `rev` command in Linux?

## What is the `rev` command?

As the name implies, the `rev` command (short for reverse) allows users to reverse a line of characters _or_ a file.

## How is the `rev` command used?

The `rev` command is typically supplied a string of characters _or_ a file input.

### `rev` with a file

If a file named `example.txt` contains:

```text
This is a line of text
txet fo enil a si siht
another one
```

and `rev` is supplied `example.txt`, then the output will showcase the reversed result.

```shell
% rev example.txt
txet fo enil a si sihT
this is a line of text
eno rehtona
```

### `rev` with standard input

`rev` accepts standard input by default.

```shell
% rev
this is a line
enil a si siht
```

__OR__

```shell
% echo this is a line | rev
enil a si siht
```

This is useful for scripting capabilities:

```bash
foo="I want this text reversed"
bar=$(echo $foo | rev)
echo $bar
```
