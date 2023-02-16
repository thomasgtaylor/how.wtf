---
title: How to copy files in Linux
date: 2023-02-15T00:40:00-04:00
author: Thomas Taylor
description: How to copy a file or multiple files in Linux / terminal.
categories:
- OS
tags:
- Linux
---

Copying files and directories is an essential task in Linux.

## The `cp` command

The `cp` command is used to copy files and directories from one location to another.

Basic syntax:

```shell
Usage: cp [OPTION]... [-T] SOURCE DEST
  or:  cp [OPTION]... SOURCE... DIRECTORY
  or:  cp [OPTION]... -t DIRECTORY SOURCE...
Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.
```

The `SOURCE` can be one or many files / directories, and the `DEST` can be a single file or directory.

## Copying multiple files to a directory

```shell
cp file1 file2 file3 dir1
```

## Copying matching files to a directory

```shell
cp *.txt dir1
```

## Copying a directory to another directory

Using the `-r` or `-R` or `--recursive` option, `cp` will recursively copy a directory - including its files and subdirectories.

```shell
cp -r dir1 ~/Documents
```

## Copying files without clobbering

Using the `-i` or `--interactive` option, `cp` will iteratively request user input for files with naming conflicts.

```shell
> cp -i file1 dir1
cp: overwrite 'dir1/file1'?
```

## Include verbosity when copying files

```shell
> cp -v file1 dir1
'file1' -> 'dir1/file1'
```
