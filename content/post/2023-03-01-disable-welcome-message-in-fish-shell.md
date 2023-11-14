---
author: Thomas Taylor
categories:
- os
date: 2023-03-01 00:45:00-04:00
description: How to surpress or customize or remove the welcome message in Fish Shell
tags:
- linux
title: Disable welcome message in Fish Shell
---

The default welcome message in Fish can be surpressed or customized.

## Disable welcome message

A frequently asked question is "How do I change the greeting message?". It can be completed by editing the `config.fish` file:

```shell
vim ~/.config/fish/config.fish
```

Using the `g` global flag, the `fish_greeting` variable can be set to empty.

```fish
set -g fish_greeting
```

## Customize welcome message

In addition to disabling, the message can be customized.

```shell
vim ~/.config/fish/functions/fish_greeting.fish
```

```fish
function fish_greeting
    echo "greetings!"
end
```