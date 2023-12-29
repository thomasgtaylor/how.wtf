---
author: Thomas Taylor
categories:
- programming
date: 2023-03-13 01:30:00-04:00
description: How to pass variables from command line using Make
tags:
- makefile
title: How to pass variables to Makefiles
---

Passing variables, exported variables, or `.env` (dot env) file variables from outside of a Makefile can be completed in a few ways.

## Pass variables to Makefile using environment variables

Exported environment variables are referenced by name in the Makefile:

```makefile
test:
	@echo $(TEST)
```

```shell
export TEST=value
make test
```

Output:

```text
value
```

## Pass variables to Makefile using command line

Similarly, variables may be explicitly passed to `make` prior to command executions.

```makefile
test:
	@echo $(TEST)
```

```shell
TEST=value make test
```

Output:

```text
value
```

## Pass variables using `.env` (dot env) files

Makefiles can contain an `include` [directive](https://www.gnu.org/software/make/manual/html_node/Include.html) which reads one or more files before executing.

```makefile
ifneq (,$(wildcard ./.env))
	include .env
	export
endif

test:
	@echo $(TEST)
```

`.env` file:

```text
TEST=dotenv
```

Output:

```text
dotenv
```