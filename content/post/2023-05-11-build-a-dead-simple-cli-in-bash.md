---
title: Build a dead simple CLI in Bash
date: 2023-05-11T01:45:00-04:00
author: Thomas Taylor
description: How to build a simple CLI in Bash using getopts
categories:
- OS
tags:
- Linux
---

Building a simple CLI in Bash may seem like a herculean task; however, `getopts` provides an easy-to-use interface out of the box! For this tutorial, we'll be using the https://pokeapi.co/ to build a simple CLI for fetching resources from the Pokemon world.

## What is `getopts`?

Given from the [documentation](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/getopts.html),

> The _getopts_ utility shall retrieve options and option-arguments from a list of parameters. It shall support the Utility Syntax Guidelines 3 to 10, inclusive, described in XBD [_Utility Syntax Guidelines_](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html#tag_12_02).

`getopts` is a command that makes defining options and option-arguments seamless using a list of parameters. 

## Use `getopts` to get `pokemon`

Let's start by making the boilerplate:

```bash
#!/bin/bash

usage() { 
  echo "Usage: $0 -p <pokemon>" 1>&2
  exit
}

while getopts "hp:" o; do
  case "${o}" in
    p) pokemon_name="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    h) usage ;;
  esac
done

[[ -z "$pokemon_name" ]] && usage
```

As seen above, `getopts` accepts a parameter list – ie. `hn:`. Colons (`:`) are used to denote that an argument requires a value.  In this case, `h` is as an option (`-h`) while `n` is  as an option-argument (`-n <name>`). If `$name` is not provided, then the `usage` function is called.

Within the `case` statement, `$OPTARG` contains the option-argument value that is passed from the user. For good measure, it is piped through `tr` to lowercase it (click [here](https://how.wtf/convert-a-string-to-lowercase-in-bash.html) for more information about casing strings in Bash).

Now, let's add a simple curl command that calls the `/pokemon` api given the name:

```bash
#!/bin/bash

usage() { 
  echo "Usage: $0 -p <pokemon>" 1>&2
  exit
}

pokemon() {
  local name="$1"
  curl -o "$name.json" https://pokeapi.co/api/v2/pokemon/$name \
    -H "Accept: application/json"
  exit
}

while getopts "hp:" o; do
  case "${o}" in
    p) pokemon_name="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    h) usage ;;
  esac
done

[[ -z "$pokemon_name" ]] && usage
[[ "$pokemon_name" ]] && pokemon "$pokemon_name"

```

The `pokemon` function is called with the `$pokemon_name` that was passed in. 

```shell
./poke.sh -p pikachu
```

The output is a `json` file that contains pikachu's information.

## Use `getopts` to get `items`

Building upon the last example, we can easily capture `items`:

```bash
#!/bin/bash

usage() { 
  echo "Usage: $0 [-p <pokemon>] [-i <item>]" 1>&2
  exit
}

request() {
  local path="$1"
  local file_name=$(echo $path | sed 's|.*/||')
  curl -o "$file_name.json" https://pokeapi.co/api/v2/$path \
    -H "Accept: application/json"
}

pokemon() {
  request "pokemon/$1"
  exit
}

item() {
  request "item/$1"
  exit
}

while getopts "hp:i:" o; do
  case "${o}" in
    p) pokemon_name="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    i) item_name="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    h) usage ;;
  esac
done

[[ -z "$pokemon_name" && -z "$item_name" ]] && usage
[[ "$pokemon_name" ]] && pokemon "$pokemon_name"
[[ "$item_name" ]] && item "$item_name"
```

A few things happened:

1. I abstracted the `curl` to its own function named `request`
    1. The `file_name` is parsed from the path. Ie. `/items/master-ball` -> `master-ball.json`
2. `pokemon` and `item` both call `request`
3. `i:` was added to the `getopts` string to allow the`-i <item>` option-argument.

## What's next?

`getopts` is useful for building plain / simple CLIs. If something more advanced is necessary, `bash` is not the best language for the task. 
