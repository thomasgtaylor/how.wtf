---
title: What does PHONY mean in a Makefile
date: 2023-03-26T01:35:00-04:00
author: Thomas Taylor
description: What is the purpose of the .PHONY in a Makefile?
categories:
- Programming
tags:
- Makefile
---

What does `.PHONY` mean in a Makefile? The `make` [manual](https://www.gnu.org/software/make/manual/make.html#Phony-Targets) describes the `.PHONY` target as, 

> A phony target is one that is not really the name of a file; rather it is just a name for a recipe to be executed when you make an explicit request.

However, what does this mean?

## What is `.PHONY` in a makefile?

By default, targets are "target files". For the following rule,

```makefile
hello.txt: dependency.txt
	echo "hello world" > hello.txt
```

`make` asks: "Is `hello.txt` out of date?" To determine if it is out of date, it follows the logic:

1. If `hello.txt` exists, is `dependency.txt` more recent than `hello.txt`? If so, run the instructions.
2. If `hello.txt` does not exist, run the instructions.

```shell
> touch dependency.txt
> make hello.txt
echo "hello world" > hello.txt
> make hello.txt
make: 'hello.txt' is up to date.
> echo "update" > dependency.txt
> make hello.txt
echo "hello world" > hello.txt
```

However, for targets that do not output files, a `.PHONY` label is used. In the following rule,

```makefile
.PHONY: format
format:
	gofmt -s -w .
```

the `format` target formats `go` code. It does _not_ produce a file.

## Why is `.PHONY` important in a makefile?

For some cases, `.PHONY` is not needed. For example,

```makefile
lint:
	golangci-lint run
```

the `lint` target surfaces various code issues. As long as a file named `lint` does not exist (or will not exist in the future), this command will continue working. From the `make` perspective, `lint` will always be out of date since the file will never exist.

The `.PHONY` is only important if a target's name can collide with a file name.