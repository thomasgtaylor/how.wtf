---
author: Thomas Taylor
categories:
- os
date: 2023-06-05 23:55:00-04:00
description: What is the shuf command in Linux?
tags:
- linux
title: shuf command in Linux
---

What is the `shuf` command in Linux?

## What is the `shuf` command?

The `shuf` command in Linux is a utility for shuffling lines of input files. It allows users to shuffle contents of a file or produce random output based on supplied arguments.

## How is the `shuf` command used?

Given a file named `quotes.txt` with the following contents:

```text
"The only way to do great work is to love what you do." - Steve Jobs
"In the end, it's not the years in your life that count. It's the life in your years." - Abraham Lincoln
"Success is not final, failure is not fatal: It is the courage to continue that counts." - Winston Churchill
"Believe you can and you're halfway there." - Theodore Roosevelt
"Be yourself; everyone else is already taken." - Oscar Wilde
```

the `shuf` command allows for a random permutation of all the lines.

```shell
% shuf quotes.txt
"Success is not final, failure is not fatal: It is the courage to continue that counts." - Winston Churchill
"In the end, it's not the years in your life that count. It's the life in your years." - Abraham Lincoln
"The only way to do great work is to love what you do." - Steve Jobs
"Believe you can and you're halfway there." - Theodore Roosevelt
"Be yourself; everyone else is already taken." - Oscar Wilde
```

In addition, it can be used in the following scenarios as well:

List 1 random quote:

```shell
% shuf -n 1 quotes.txt
"In the end, it's not the years in your life that count. It's the life in your years." - Abraham Lincoln
```

List random numbers between a range of numbers:

```shell
% shuf -i 0-5
4
1
0
2
3
5
```

Give `shuf` a list of options using `-e` and outputing 1 chosen line using `-n`:

```shell
% shuf -e option1 option2 option3 -n 1
option3
```

Standard input works as well:

```shell
% seq 5 | shuf
5
2
4
1
3
```