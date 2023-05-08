---
title: Use Linux terminal as a calculator
date: 2023-05-08T001:20:00-04:00
author: Thomas Taylor
description: How to use the Linux terminal as a calculator
categories:
- OS
tags:
- Linux
---

Linux provides several methods for calculating expressions using the command line.

## Using `bc`  — basic calculator for command line

`bc` is a native Linux tool (originated on Unix systems in 1975) that stands for "basic calculator". To use it, simply type `bc` followed by an expression. To quit, type `quit`.

```shell
> bc
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006, 2008, 2012-2017 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
5 + 5
10
25 * 4
100
100 / 2 * 35
1750
2 * (2 * 5) + 15
35
quit
```

Additionally, variables, arrays, algebraic expressions, etc. can be used. Refer to the [`bc` manual](https://www.gnu.org/software/bc/manual/html_mono/bc.html) for more information.

## Using `expr` 

The `expr` command evaluates basic expressions.

```shell
> expr 5 + 5
10
> expr 25 \* 4
100
> expr 100 / 2 \* 35
1750
```

Keep in mind, it should be used for basic calculations. If something more advanced is required (like parenthesis), `bc` or arithmetic expansion may be more suitable. 

## Using arithmetic expansion

Arithmetic expansion evaluates an expression and substitutes the result. In combination with `echo`, it can be used as a calculator. 

```shell
> echo "$((5 + 5))"
10
> echo "$((25 * 4))"
100
> echo "$((100 / 2 * 35))"
1750
> echo "$((2 * (2 * 5) + 15))"
35
```

## Using `qalc`

Qalc is a multi-purpose cross-platform desktop calculator. It provides versatility and supports many everyday needs: currency conversion, percent calculation, etc. 

Install it on Ubuntu via `apt`:

```shell
sudo apt install qalc
```

Example usage:

```shell
> sqrt(72)

  sqrt(72) = 6 × √(2) ≈ 8.485281374

> fibonacci(133) to hex

  fibonacci(133) ≈ 0x90540BE2616C26F81F876B9

> 5/3 + 3/7

  (5 / 3) + (3 / 7) = 44/21 = 2 + 2/21 ≈ 2.095238095

> 5 + 5

  5 + 5 = 10

> exit
```
