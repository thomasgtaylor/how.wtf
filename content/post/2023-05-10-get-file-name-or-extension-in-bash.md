---
author: Thomas Taylor
categories:
- programming
date: 2023-05-10 00:20:00-04:00
description: How to get the file name or extension in Bash
tags:
- bash
title: Get file name or extension in Bash
---

Retrieving the file name and extension in Bash can be completed using `basename` and [shell parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html). 

## Get the file name

Using the native unix `basename` command, the file name can be extracted from the path.

```bash
file_path="/path/to/package.tar.gz"
file_name=$(basename "$file_path")
echo "$file_name"
```

Output:

```text
package.tar.gz
```

## Get the file extension

Using shell parameter expansion, the prior example can include capturing the file extension:

```bash
file_path="/path/to/package.tar.gz"
file_name=$(basename "$file_path")
file_ext="${file_name#*.}"
echo "$file_ext"
```

Output:

```text
tar.gz
```

## Match on file extension using a `case` statement

If there is conditional logic required for specific file extensions, a `case` statement may be used. In addition, this is standard `sh` (not exclusive to `bash`)

```bash
file_path="/path/to/package.tar.gz"
file_name=$(basename "$file_path")

case "$file_name" in
    *.tar.gz) echo "matched tar.gz!" ;;
esac
```

Output:

```text
matched tar.gz!
```