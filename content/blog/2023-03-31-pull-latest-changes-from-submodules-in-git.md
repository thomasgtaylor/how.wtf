---
author: Thomas Taylor
categories:
- os
date: 2023-03-31 21:50:00-04:00
description: How to pull latest changes for submodules in Git
tags:
- git
title: Pull latest changes from submodules in Git
---

Pulling the latest changes for all submodules in a repository is made easy through Git.

## Pull all submodules after checkout

After an initial checkout, the the submodules can be updated using the following command:

```shell
git submodule update --init --recursive
```

## Pull all submodules changes

In Git versions 1.8.2 and higher, a `--remote` option was added to pull the latest changes from remote branches.

```shell
git submodule update --recursive --remote
```

In addition, the following commands will work as well:

```shell
git submodule update --recursive
```

_or_

```shell
git pull --recurse-submodules
```