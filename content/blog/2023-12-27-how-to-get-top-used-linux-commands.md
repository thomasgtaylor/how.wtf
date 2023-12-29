---
author: Thomas Taylor
categories:
- os
date: 2023-12-27T18:30:00-05:00
description: How to get the top 10 used commands in linux using the history command
images:
- images/ZMV2NF.png
tags:
- linux
title: How to get top used Linux commands
---

![how to use the history command to fetch the top used linux commands](images/ZMV2NF.png)

Retrieving the top 10 used commands in Linux is simple using the `history` command.

## What is the history command

The `history` command, as its name implies, is used to view previously executed commands. It's API is minimal and easy to use.

## How to view top used commands in Linux

Using a combination of `history` and `awk`, we can pull the top 10 commands like this:

```shell
history |
    awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" |
    sort -n -r |
    head -n 10
```

Output:

```text
1842 26.4617% git
520 7.47019% export
389 5.58828% cd
262 3.76383% sfdx
257 3.692% npx
254 3.6489% npm
237 3.40468% nvim
234 3.36159% aws
227 3.26103% rm
195 2.80132% poetry
```

The `awk` command is the magic sauce. The `sort` command is used to reverse sort the list then the `head` command prints the last 10 lines.

If you prefer aligned columns with a counter to the left, we can use `nl` and the `column` command:

```shell
history | 
    awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
    grep -v "./" |
    column -c 3 -s " " -t |
    sort -n -r |
    nl |
    head -n 10
```

Output:

```text
    1	1842  26.4351%    git
    2	520   7.46269%    export
    3	389   5.58266%    cd
    4	262   3.76005%    sfdx
    5	257   3.68829%    npx
    6	254   3.64524%    npm
    7	237   3.40126%    nvim
    8	234   3.35821%    aws
    9	227   3.25775%    rm
    10	195   2.79851%    poetry
```

In my case, `git`, `export`, and `cd` are my most used commands from the terminal.