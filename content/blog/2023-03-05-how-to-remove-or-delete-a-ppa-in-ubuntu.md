---
author: Thomas Taylor
categories:
- os
date: 2023-03-05 01:15:00-04:00
description: How to remove or delete a PPA (Personal Package Archive) in Debian-based distributions.
tags:
- linux
title: How to remove or delete a PPA in Ubuntu
---

PPAs (Personal Package Archive) are third-party collections of packages built and maintained by users.

## How to list PPAs installed on the system

```shell
ls /etc/apt/sources.list.d/
neovim-ppa-unstable-jammy.list
```

## How to remove a PPA using terminal

The recommended way to remove a PPA is to use the `apt-add-repository` command with the `--remove` (or `-r`) option.

```shell
sudo apt-add-repository --remove ppa:PPA_REPOSITORY/PPA
```

Example:

```shell
sudo apt-add-repository -r ppa:neovim-ppa/unstable
```
