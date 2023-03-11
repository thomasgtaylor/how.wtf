---
title: Check if a program exists from a Makefile
date: 2023-03-11T00:50:00-04:00
author: Thomas Taylor
description: How to check if a shell program or executable exists from a Makefile
categories:
- Programming
tags:
- Makefile
---

A Makefile can check if a shell program or executable exists before running recipes.

## Check if all programs exist

```makefile
REQUIRED_BINS := hugo terraform aws exiftool jpegoptim optipng mogrify
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),,$(error Please install `$(bin)`)))
```

This method will run before _any_ `make <command>` is completed. It ensures that each program listed in `REQUIRED_BINS` is executable. If not, it will output an error quickly.

## Check if a specific program exists

If it's preferred to check a shell program before running a specific command, the syntax below will enable for that use-case:

```makefile
tools := hugo terraform aws exiftool jpegoptim optipng mogrify
$(tools):
	@which $@ > /dev/null
	
.PHONY: serve
serve: hugo
	$(HUGO) server -D

.PHONY: validate
validate: terraform
	$(TERRAFORM) validate
```

This works by using [automatic variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html) with [static patterns](https://www.gnu.org/savannah-checkouts/gnu/make/manual/html_node/Static-Usage.html). All items in `tools` will become targets. The `$@` in the recipe will be be substituted with the target's name.

In the example above, `make serve` will first check if the `hugo` target is completed. That target runs `@which hugo > /dev/null`.
