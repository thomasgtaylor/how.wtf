---
author: Thomas Taylor
categories:
- programming
date: 2023-04-27 22:10:00-04:00
description: How to catch and handle errors in Bash
tags:
- bash
title: Catch and handle errors in Bash
---

Bash does not natively support a try/catch syntax for errors; however, there are options for handling errors within a script.

## Try and Catch errors in Bash

For the first technique, simply detect if there's a non-zero status by using the following syntax:

```bash
if ! command_call; then
    echo "command_call did not complete successfully"
fi
```

In addition, an `||` (or) expression may be used instead:

```bash
command_call || echo "command_call did not complete successfully"
```

For explicitness, the full syntax for a `try/catch` in Bash is:

```bash
if command_call ; then # try
    echo "tried and was successful"
else # catch
    echo "command_call did not complete successfully"
fi
```

If `command_call` is not successful, the echo statement will be invoked in all scenarios.

## Error handling in Bash

For the second technique, `bash` provides a native variable for reporting exit codes: `$?`. Some users may want to catch and handle _specific_ exit codes.

```bash
command_call

status=$?
if [ $status -eq 1 ]; then
    echo "General exception"
elif [ $status -eq 127 ]; then
    echo "The command could not be found!"
fi
```