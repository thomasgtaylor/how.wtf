---
author: Thomas Taylor
categories:
- os
date: 2023-03-14 01:00:00-04:00
description: How to print everything following a grep pattern match
tags:
- linux
title: Grep for contents after pattern match
---

There may be a need to grep for a specific pattern but only capture / echo the contents _after_ the match. 

`grep` will match on any pattern you supply; however, what if a user wants to capture the status of a particular host in the following file?

```text
hostname1: bad
hostname2: good
hostname3: good
hostname4: bad
```

## Get contents after `grep` match using `sed`

Using a combination of `grep` and `sed`, this can be accomplished:

```shell
grep 'hostname1' file.txt | sed 's/^.*: //'
```

Evaluation:

1. `grep` matches _any_ line that contains `hostname2`
2. `sed` replaces (`s///` substitute) any character (`.*`) from the beginning of the line (`^`) until the last occurrence of the sequence `:` with the empty string of ` `.

Output:

```text
bad
```

## Get contents after `grep` match using `awk`

If the delimiter is known ahead of time, `awk` is a simpler approach.

```shell
grep 'hostname2' file.txt | awk '{print $2}'
```

Evaluation:

1. `grep` matches _any_ line that contains `hostname2`
2. `awk` prints the second field after the delimiter (which is space by default)
	1. use the `-F` option to switch delimiters: ex. `awk -F ","` for commas
	
Output:

```text
good
```	

## Get contents using `awk` only

`awk` may optionally be used by itself to extract the value.

```shell
awk '/hostname4:/ {print $2}' file.txt
```

Output:

```text
bad
```