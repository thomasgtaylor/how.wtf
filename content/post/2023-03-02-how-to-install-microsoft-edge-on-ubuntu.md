---
author: Thomas Taylor
categories:
- os
date: 2023-03-02 01:35:00-04:00
description: How to install Microsoft Edge on Ubuntu or Linux Mint or other Debian-based
  distributions.
tags:
- linux
title: How to install Microsoft Edge on Ubuntu
---

Installing Microsoft Edge is simple through the terminal on any Debian-based distribution.

## Install Microsoft Edge using Terminal / CLI

Download the Microsoft repository GPG key.

```shell
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
```

Add the GPG key to the trusted keys.

```shell
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
```

Add the edge repository.

```shell
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'
```

Remove the downloaded GPG key since it was added to the system.

```shell
sudo rm microsoft.gpg
```

Install Microsoft Edge.

```shell
sudo apt update && sudo apt install microsoft-edge-stable
```