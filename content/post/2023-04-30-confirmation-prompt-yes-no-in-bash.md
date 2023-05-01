---
title: Confirmation prompt yes/no in Bash
date: 2023-04-30T23:55:00-04:00
author: Thomas Taylor
description: How to ask for confirmation in a bash script
categories:
- Programming
tags:
- Bash
---

Asking for user confirmation in a `bash` script is easy! 

## Yes/No prompt with default no

If the default is `No` for an invalid character _or_ space, simply check if the prompt answer is `y`.  Using `read`, user input can be limited to a single character using the `-n 1` parameter. 

```bash
read -r -p "Are you sure? [y/N]" -n 1
echo # (optional) move to a new line
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Operation continues"
fi
```

Similarly, a case statement may be used:

```bash
read -r -p "Are you sure? [y/N]" -n 1
echo # (optional) move to a new line
case "$REPLY" in 
  y|Y ) echo "Operation continues";;
  * ) echo "Operation is cancelled";;
esac
```
