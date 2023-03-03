---
title: How to install Microsoft fonts on Ubuntu
date: 2023-03-03T00:00:00-04:00
author: Thomas Taylor
description: How to install Microsoft fonts on Ubuntu or other Debian-based distributions.
categories:
- OS
tags:
- Linux
---

Installing Microsoft fonts is simple through the terminal on Debian-based distributions.

## Why are Microsoft fonts _not_ installed?

Microsoft fonts like Times New Roman, Arial, etc. are not open source. Because of licensing issues, most linux distributions opt to exclude proprietary software.

## Install Microsoft fonts using Terminal / CLI

Add the `multiverse` repository.

```shell
sudo add-apt-repository multiverse
```

Install `ttf-mscorefonts-installer`.

```shell
sudo apt update && sudo apt install ttf-mscorefonts-installer
```

When the EULA agreement appears, press tab and enter on `<OK>` then `<Yes>` on the "Do you accept the EULA license terms?" screen.

Refresh the font cache.

```shell
sudo fc-cache -f -v
```

If the EULA is mistakenly rejected, reinstall.

```shell
sudo apt install -reinstall ttf-mscorefonts-installer
```
