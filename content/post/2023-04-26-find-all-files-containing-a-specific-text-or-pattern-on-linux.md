---
title: Find all files containing a specific text or pattern on Linux
date: 2023-04-26T00:40:00-04:00
author: Thomas Taylor
description: How to find all files containing a specific text or pattern on Linux
categories:
- OS
tags:
- Linux
---

Searching for a specific text or pattern across multiple files can be completed using `grep`.

## Using `grep` to search file contents

`grep` provides searching functionality out-of-the-box:

```shell
grep -rnw '/path/to/directory' -e 'pattern'
```

Here are a breakdown of the `grep` options:

- `-r` for recursiveness
- `-n` for line number
- `-w` for matching the whole word
- `-e` is the pattern used for searching

The command will output the file names and text containing the pattern. If the goal is simply to display the filenames themselves, add the `-l` flag.:

```shell
grep -rlnw '/path/to/directory' -e 'pattern'
```

If binary files need to be omitted, add the `-I` flag.

```shell
grep -rlnwI '/path/to/directory' -e 'pattern'
```

In addition, the `--exclude`, `--include`, and `--exclude-dir` may be used in combination.

**Example:** Excluding `dir1` and `dir2`, find all `html` or `javascript` files with the filter of `p` in them.

```shell
grep \
  --include=\*.{html,js} \
  --exclude-dir={dir1,dir2} \
  -rlnwI '/path/to/directory' \
  -e "p"
```
