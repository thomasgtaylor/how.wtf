---
author: Thomas Taylor
categories:
- os
date: 2023-03-19 01:15:00-04:00
description: How to add a new element to a JSON array using jq
tags:
- linux
title: Add new element to JSON array with jq
---

Adding a new element to an existing JSON array can be completed using `jq`.

## Add element to existing array of objects using `jq`

This is a generic `projects.json` file:

```json
{
	"projects": [
		{
			"id": 1,
			"version": "2.3.0"
		},
		{
			"id": 2,
			"version": "1.54.0"
		}
	]
}
```

Appending a new element to the array can be completed in two ways:

**1. `+= []`**

```shell
cat projects.json | jq '.projects += [{
	"id": 3,
	"version": "5.4.1"
}]'
```

**2. `|=`**

```shell
jq '.projects[.projects | length] = {
	"id": 3,
	"version": "5.4.1"
}'
```

Output:

```json
{
	"projects": [
		{
			"id": 1,
			"version": "2.3.0"
		},
		{
			"id": 2,
			"version": "1.54.0"
		},
		{
			"id": 3,
			"version": "5.4.1"
		}
	]
}
```

## Add element to existing array of strings using `jq`

Similarly with strings:

```shell
echo '["id1"]' | jq '. += ["id2"]'
```

_or_

```shell
echo '["id1"]' | jq '.[. | length] = "id2"'
```

Output:

```json
[
	"id1",
	"id2"
]
```