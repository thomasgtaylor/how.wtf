---
title: gyp no xcode or clt version detected
date: 2023-04-07T22:25:00-04:00
author: Thomas Taylor
description: How to fix the "gyp no xcode or clt version detected" error for MacOS
categories:
- OS
tags:
- Mac
---

On a fresh update of MacOS, an error may occur:

```text
gyp: No Xcode or CLT version detected!  
gyp ERR! configure error
```

## Solution 1: Reset xcode


Try simply running the following command:

```shell
sudo xcode-select --reset
```

## Solution 2: Reinstall xcode

If the prior solution does not work, a complete reinstall of xcode may be necessary.

1. Find the xcode path:

```shell
xcode-select --print-path
```

2. Delete the xcode directory

```shell
sudo rm -rf <result from last command>
```

3. Install xcode

```shell
xcode-select --install
```
