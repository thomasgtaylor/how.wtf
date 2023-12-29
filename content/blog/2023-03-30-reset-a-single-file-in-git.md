---
author: Thomas Taylor
categories:
- os
date: 2023-03-30 20:45:00-04:00
description: How to reset a single file using Git
tags:
- git
title: Reset a single file in Git
---

Resetting a single file is possible using Git.

## How to restore a single file

In Git versions 2.23 and higher, `git restore` natively supports resetting a single file. 

```shell
git restore path/to/file.txt
```

The above restores `path/to/file.txt` to the prior commit.

In addition, restoring from _another_ branch is possible:

```shell
git restore -s my-feature-branch pathTo/MyFile
```

The `-s` option specifies a source (`my-feature-branch` in this case).

## How to reset a single file

In Git versions that predate 2.23, the following command will reset a single file:

```shell
git checkout HEAD -- path/to/file.txt
```

Anything after the `--` is treated as a filename in unix.