---
title: Count number of files in Linux
date: 2023-05-18T22:20:00-04:00
author: Thomas Taylor
description: How to count the number of files in Linux
categories:
- OS
tags:
- Linux
---

Counting the number of files in Linux is made possible using the `wc` command!

## Count number of files and directories in current directory

Using `wc` in combination with `ls`, the number of files and directories in the **current** directory can be displayed:

```shell
ls | wc -l
```

Output:

```shell
~/how.wtf/content/post$ ls | wc -l
120
```

To include hidden files and directories, use the `-A` `ls` option.

```shell
ls -A | wc -l
```

## Count number of files in current directory

Using `find` and `wc`, the number of files in the current directory can be displayed:

```shell
find . -maxdepth 1 -type f | wc -l
```

`-maxdepth` ensures that subdirectories are not counted.

## Count number of files in current directory and subdirectories

Using `find` and `wc`, the number of files __excluding__ directories can be displayed:

```shell
find . -type f | wc -l
```
