---
title: How to install Neovim on Ubuntu
date: 2023-05-28T23:45:00-04:00
author: Thomas Taylor
description: How to install Neovim on Debian-based distributions.
categories:
- OS
tags:
- Linux
---

Installing Neovim on Debian-based distributions: Ubuntu, Mint, etc. is easy!

## Install Neovim on Ubuntu

Neovim is available through the Debian package manager. Simply execute the following command:

```shell
sudo apt install neovim
```

## Install Neovim using PPA

The default Neovim version bundled with `apt` is normally outdated. To install a newer version, a PPA (Personal Package Archive) must be used.

**NOTE**: The Neovim PPAs are _not_ maintained by the Neovim team

### Neovim stable PPA

To install the latest stable Neovim version using `apt`, add the following PPA:

```shell
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

### Neovim unstable PPA

To install the latest unstable Neovim verson using `apt`, add the following PPA:

```shell
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```
