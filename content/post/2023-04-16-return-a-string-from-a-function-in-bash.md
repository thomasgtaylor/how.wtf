---
title: Return a string from a function in Bash
date: 2023-04-16T23:40:00-04:00
author: Thomas Taylor
description: How to return a string from a function using Bash
categories:
- Programming
tags:
- Bash
---

Bash allows returning status codes (integers) from functions; however, how can a string be returned?

## Returning a string from a function

In Bash, command substitution can be used to capture the stdout of a function.

```bash
f(){
  local var="test"
  echo $var
}

result=$(f)
echo "f returned $result"
```

Output

```text
f returned test
```

## Returning a string and status from a function

If the standard output and status code need capturing, the example above can be modified to include a return status.

```bash
f(){
  local var="test"
  echo $var
  return 10
}

result=$(f)
status=$?
echo "f returned $result with status code $status"
```

Output

```text
f returned test with status code 10
```
