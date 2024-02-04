---
author: Thomas Taylor
categories:
- programming
date: '2024-02-03T22:45:00-05:00'
description: This article explains the proper way to test for status codes / exit statues using Bash.
tags:
- bash
title: 'The right way to test exit codes in Bash'
---

In this article, we'll go over how to properly test exit codes in Bash scripts.

## Testing exit codes with $?

When I first started writing Bash, I often wrote the following code to test whether a program's execution was successful:

```bash
some_command
if [ "$?" -eq 0 ]; then
    echo "It worked!"
fi
```

However, this introduces complexity in the flow of the script. For example, one minor mistake like adding en echo statement:

```bash
some_command
echo "some_command"
if [ "$?" -eq 0 ]; then
    echo "It worked!"
fi
```

can introduce unintended side effects that are not immediately clear. In this case, the `echo` statement's exit status is `0` and skips the `if` conditional.

Therefore, **if status codes are used as true/false indictators, do not use this method**

## Testing for successful exit codes

For the majority of my use cases, I need to evaluate whether a program's execution is or is not successful.

Using the following syntax clearly informs readers what is happening:

```bash
if some_command; then
    echo "It worked!"
fi
```

If `some_command` executes correctly, `echo "It worked!"`.

## Testing for failed exit codes

Similarly, we can test for failed exit codes by negating the `if` statement:

```bash
if ! some_command; then
    echo "It did not work!"
fi
```

If `some_command` executes incorrectly, `echo "It did not work!"`

## Testing for specific exit codes

If your use case requires testing for specific exit codes, then I recommend collecting the exit status on the same line and using a `case` statement.

For example:

```bash
some_command; some_command_exit_code=$?
case $some_command_exit_code in
    0) echo "It worked!" ;;
    *) echo "It did not work!" ;;
esac
```

Using a `case` statement allows us to control the flow in an easy-to-digest manner.

After all, code maintainability should be prioritized.
