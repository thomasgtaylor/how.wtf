---
title: How to unadd or uncommit files in Git
date: 2023-03-06T00:55:00-04:00
author: Thomas Taylor
description: How to unadd or uncommit files using Git in terminal
categories:
- OS
tags:
- Git
---

Occasionally, developers will mistakenly `git add` or `git commit` files before pushing to remote. Luckily, there are commands that remediate the situation.

## How to unadd a file

Unadding a specific file before a commit:

```shell
git reset <file>
```

## How to unadd all files

Unadding all files before a commit:

```shell
git reset
```

## How to uncommit the last commit

If the last commit needs to be uncommitted:

```shell
git reset --soft HEAD~1
```

The command reads as "undo the last committed changes and preserve the files". If the files do not need to be preserved, `--hard` may be used.

At this point, the files may be [unadded if desired](how-to-unadd-files).

## Aliasing

Aliases allow for ease-of-use in daily workflows:

```shell
git config --global alias.unadd 'reset HEAD --'
git config --global alias.uncommit 'reset --soft HEAD~1'
```

Usage:

```shell
> git add example.txt
> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   example.txt

> git unadd
Unstaged changes after reset:
M	example.txt
> git add example.txt
> git commit -m "add example.txt"
[main 1eb1b2f] add example.txt
 1 file changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 example.txt
> git uncommit
> git unadd
Unstaged changes after reset:
M	example.txt
```
