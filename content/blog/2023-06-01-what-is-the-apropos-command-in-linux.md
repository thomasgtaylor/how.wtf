---
author: Thomas Taylor
categories:
- os
date: 2023-06-01 23:40:00-04:00
description: What is the apropos command in Linux?
tags:
- linux
title: What is the apropos command in Linux
---

Recently, I was made aware of the `apropos` command in Linux. What is it? What is it used for?

## What is the `apropos` command?

`apropos` enables users to search terminal commands based on a keywords or descriptions. 

This is an incredibly useful tool because it quickly identifies commands based on man pages.

Scenario: I forgot the command name for the qalculate CLI I installed.

```shell
% apropos calculator
qalc(1)                  - Powerful and easy to use command line calculator
transicc(1)              - little cms ColorSpace conversion calculator
bc(1)                    - arbitrary-precision decimal arithmetic language and calculator
dc(1)                    - arbitrary-precision decimal reverse-Polish notation calculator
bc(1)                    - arbitrary-precision decimal arithmetic language and calculator
dc(1)                    - arbitrary-precision decimal reverse-Polish notation calculator
```

`qalc` was the first result.

## Nothing appropriate error

If the man database is not updated, `apropos` may report an error when looking up commands:

```shell
% apropos calculator
calculator: nothing appropriate.
```

To fix it, update the man pages:

```shell
mandb
```