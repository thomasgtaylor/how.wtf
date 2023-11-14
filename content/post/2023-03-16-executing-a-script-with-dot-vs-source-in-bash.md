---
author: Thomas Taylor
categories:
- programming
date: 2023-03-16 01:25:00-04:00
description: What is the difference between . and source when executing a script inbash?
tags:
- bash
title: Executing a script with dot vs source in Bash
---

What are the differences between `source scriptname.sh`, `. scriptname.sh` and `./scriptname.sh` when executing scripts?

## Running a program in Bash

Executing a script is simple in Bash _and_ many other shells.

```shell
scriptname.sh
```

OR

```shell
./scriptname.sh
```

The shell commands above will execute the `scriptname.sh` script as a separate program from the command line. It may be any type of script.

## Sourcing a script in Bash

When a file is sourced, it runs in the current user's shell as if the commands were typed out. 

```shell
. scriptname.sh
```

OR

```shell
source scriptname.sh
```

The most common use case is when scripts export environment variables.

```bash
export ENV_VAR=test
```

```shell
source test.sh
echo $ENV_VAR
```

Output:

```shell
test
```