---
title: Reverting changes to Git submodules
date: 2023-11-13T00:10:00-05:00
author: Thomas Taylor
description: How to revert changes to a Git submodule
categories:
- OS
tags:
- Git
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
