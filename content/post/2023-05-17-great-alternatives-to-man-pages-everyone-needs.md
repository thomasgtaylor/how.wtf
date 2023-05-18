---
title: Great alternatives to man pages everyone needs
date: 2023-05-17T20:30:00-04:00
author: Thomas Taylor
description: Here are modern alternatives to man pages everyone needs.
categories:
- OS
tags:
- Linux
---

`man` (manual documentation pages) cannot be replaced; however, there are modern CLI tools that provide simplified experiences.

## `tldr` pages

[`tldr`](https://tldr.sh) is a community-curated collection of simplified man pages. As the name (too long; didn't read) implies, the focus is providing straightforward examples that demonstrate tool usage.

### Installing `tldr`

On MacOS,

```shell
brew install tldr
```

Using the NodeJS client,

```shell
npm -g tldr
```

Using the Python client,

```shell
pip3 install tldr
```

### Using `tldr

Using `tldr` is straightforward:

```shell
tldr <some command name>
```

```shell
$ tldr tldr

tldr

Display simple help pages for command-line tools from the tldr-pages project.
More information: <https://tldr.sh>.

- Print the tldr page for a specific command (hint: this is how you got here!):
    tldr command

- Print the tldr page for a specific subcommand:
    tldr command-subcommand

- Print the tldr page for a command for a specific [p]latform:
    tldr -p android|linux|osx|sunos|windows command

- [u]pdate the local cache of tldr pages:
    tldr -u

```

## `cheat`

[`cheat`](https://github.com/cheat/cheat) is a tool used exclusively for supplying command usage. The intention is to provide a "cheatsheet" for *nix system administrators to quickly view command usage _and_ contribute their own.

### Installing `cheat`

On MacOS,

```shell
brew install cheat
```

Using GO,

```shell
go install github.com/cheat/cheat/cmd/cheat@latest
```

To find more installation examples, visit the document [here](https://github.com/cheat/cheat/blob/master/INSTALLING.md).

### Using `cheat`

Using `cheat` is simple:

```shell
cheat <some command name>
```

```shell
$ cheat jq
# To pretty print the json:
jq "." < filename.json

# To access the value at key "foo":
jq '.foo'

# To access first list item:
jq '.[0]'

# to slice and dice:
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'

# to extract all keys from json:
jq keys

# to sort by a key:
jq '.foo | sort_by(.bar)'

# to count elements:
jq '.foo | length'

# print only selected fields:
jq '.foo[] | {field_1,field_2}'

# print selected fields as text instead of json:
jq '.foo[] | {field_1,field_2} | join(" ")'

# only print records where given field matches a value
jq '.foo[] | select(.field_1 == "value_1")'
```
