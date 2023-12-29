---
author: Thomas Taylor
categories:
- os
date: 2023-11-13 00:10:00-05:00
description: How to revert changes to a Git submodule
tags:
- git
title: Reverting changes to Git submodules
---

Reverting a submodule in Git is simple.

## How to revert changes to a Git submodule

The cleanest / easiest method of reverting changes to one or many `git` submodules is by using the following two commands:

```shell
git submodule deinit -f .
git submodule update --init
```

The `git submodule deinit -f .` command "deinitializes" all submodules in the repository.

The `git submodule update --init` command does a new checkout of them.