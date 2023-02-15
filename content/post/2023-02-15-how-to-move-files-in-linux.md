---
title: How to move files in Linux
date: 2023-02-15T00:25:00-04:00
author: Thomas Taylor
description: How to move a file or multiple files in Linux / terminal.
categories:
- OS
tags:
- Linux
---

Moving files is an essential task individuals often need to perform.

## The `mv` command and its usage

The `mv` command is used to rename or move files and directories from one location to another.

Basic syntax:

```shell
> mv --help
Usage: mv [OPTION]... [-T] SOURCE DEST
  or:  mv [OPTION]... SOURCE... DIRECTORY
  or:  mv [OPTION]... -t DIRECTORY SOURCE...`
```

The `SOURCE` can be one or many files / directories, and the `DEST` can be a single file or directory.

## Moving multiple files to a directory

```shell
mv file1 file2 dir1
```

## Moving matching files to a directory

```shell
mv *.md dir1
```

## Moving a directory to another directory

```shell
mv dir1 ~/Documents
```

## Moving files without clobbering

Using the `-i` or `--interactive` option, `mv` will iteratively request user input for files with naming conflicts.

```shell
> mv -i file1 ~/Documents
mv: overwrite '~/Documents/file1'?
```

## Renaming files

Rename `file1` to `file2`:

```shell
mv file1 file2
```
