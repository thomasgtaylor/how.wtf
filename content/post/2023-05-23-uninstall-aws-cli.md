---
title: Uninstall AWS CLI
date: 2023-05-23T23:55:00-04:00
author: Thomas Taylor
description: How to uninstall the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

The AWS CLI can be installed using several methods: this article attempts to address uninstalling through many of them.

## Uninstall AWS CLI using Pip

```shell
pip3 uninstall awscli -y
# OR
pip uninstall awscli -y
```

## Uninstall AWS CLI on Ubuntu

```shell
sudo apt-get remove --auto-remove awscli
```

## Uninstall AWS CLI using Brew on MacOS

```shell
brew uninstall awscli
```

## Uninstall AWS CLI using Snap

```shell
sudo snap rm -r aws-cli
```

## Uninstall AWS CLI with Yum

```shell
sudo yum erase awscli
```

## Uninstall AWS CLI manually

If all else fails, uninstalling manually is a remaining option. Determine the executing path for the AWS CLI:

```shell
which aws
```

Then remove:

```shell
sudo rm -rf "path from previous command"
```
