---
author: Thomas Taylor
categories:
- os
date: 2023-03-18 01:40:00-04:00
description: How to pass a shell variable to jq filters
tags:
- linux
title: Passing variables to jq
---

Passing a shell / bash variable / environment variable to `jq` is simple using the native functionality of:

`--arg name value` _or_ `--argjson name value`.

## How to pass variable to `jq` filters

This is a generic `projects.json` file:

```json
{
	"projects": [
		{
			"name": "project 1",
			"owner": "owner 1",
			"id": 1,
			"version": "2.3.0"
		},
		{
			"name": "project 2",
			"owner": "owner 1",
			"id": 2,
			"version": "1.54.0"
		},
		{
			"name": "project 3",
			"owner": "owner 2",
			"id": 3,
			"version": "4.9.2"
		}
	]
}
```

### String variables

Retrieve project information via a name supplied by a user.

```bash
echo "Enter name: "
read name

cat projects.json | 
	jq -r --arg n "$name" '.projects[]|select(.name == $n)'
```

Output:

```shell
Enter name: 
project 1
{
  "name": "project 1",
  "owner": "owner 1",
  "id": 1,
  "version": "2.3.0"
}
```

`--arg name value`: `value` is automatically interpreted as a string.

### Number variables

Retrieve project information via an id supplied by a user.

```bash
echo "Enter id: "
read id

cat projects.json | 
    jq -r --arg id "$id" '.projects[]|select(.id == ($id|tonumber))'
```

Output:

```shell
Enter id: 
2
{
  "name": "project 2",
  "owner": "owner 1",
  "id": 2,
  "version": "1.54.0"
}
```

`--arg name value`: `value` must be explicitly converted to a number using the native `tonumber` function.

Optionally, `--argjson name value` may be used in `jq` versions 1.5 or higher. `--argjson` respects the value _type_. Following the same example as before,

```bash
echo "Enter id: "
read id

cat projects.json | 
    jq -r --argjson id "$id" '.projects[]|select(.id == $id)'
```

Output:

```shell
Enter id: 
2
{
  "name": "project 2",
  "owner": "owner 1",
  "id": 2,
  "version": "1.54.0"
}
```