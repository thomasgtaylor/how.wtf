---
title: Command line recycle bin for Linux
date: 2023-05-20T21:50:00-04:00
author: Thomas Taylor
description: How to use a command line recycle bin for Linux systems
categories:
- OS
tags:
- Linux
- Mac
---

`rm` is a great tool that gives users enough power to inadvertently erase data. While the data may be recoverable, there is a tool that gives users recycle bin behavior.

## What is `trash-cli`

`trash-cli` is a Python tool the implements the freedesktop.org trash specification. In contrast to `rm`, users can recover deleted files easily.

## Installing `trash-cli`

The recommended way to install `trash-cli` is through `pip` (the Python package manager):

```shell
pip3 install trash-cli
```

Alternatively, `trash-cli` is available on some package managers:

Debian/Ubuntu:

```shell
sudo apt install trash-cli
```

Arch:

```shell
pacman -S trash-cli
```

Fedora:

```shell
dnf install trash-cli
```

## `trash-cli` simple usage

Using `trash-cli` is straightforward.

Trash a file:

```shell
trash path/to/file
```

Trash many files:

```shell
trash path/to/file1 path/to/file2
```

List trashed files:

```shell
$ trash-list
2023-05-20 21:43:02 /Users/thomas/example2.txt
2023-05-20 21:43:02 /Users/thomas/example1.txt
```

Remove specific trashed files:

```shell
$ trash-rm example2.txt
$ trash-list
2023-05-20 21:43:02 /Users/thomas/example1.txt
```

Restore trash:

```shell
$ trash-restore
   0 2023-05-20 21:43:02 /Users/thomas/example1.txt
What file to restore [0..0]: 0
```

Lastly, emptying trash:

```shell
$ trash-empty
Would empty the following trash directories:
    - /Users/thomas/.local/share/Trash
Proceed? (y/n) y
```
