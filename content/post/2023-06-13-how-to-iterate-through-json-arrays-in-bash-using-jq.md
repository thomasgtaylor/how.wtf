---
title: How to iterate through JSON arrays in Bash using jq
date: 2023-06-13T22:45:00-04:00
author: Thomas Taylor
description: Learn how to easily iterate through a JSON array using jq in a Bash script
categories:
- OS
tags:
- Linux
---

Learn the simple process of iterating through a JSON array in bash with the help of `jq`.

## Iterate through a JSON array using `jq`

**Scenario**: You have a file named `projects.json` contains an array named "projects" that you want to iterate through.

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

To achieve this, you can use the bash snippet below:

```bash
jq -c '.projects[]' projects.json | while read i; do
    echo "$i"
done
```

The command uses jq to extract each object in the "projects" array and then uses a while loop to iterate through the extracted objects. The echo statement prints each object.

The output will be:

```text
{"name":"project 1","owner":"owner 1","id":1,"version":"2.3.0"}
{"name":"project 2","owner":"owner 1","id":2,"version":"1.54.0"}
{"name":"project 3","owner":"owner 2","id":3,"version":"4.9.2"}
```

## Iterate through a JSON array using `jq` and associative arrays in Bash

If your version of bash supports associative arrays, you can use an alternative approach: 

```bash
readarray -t projects < <(jq -c '.projects[]' projects.json)
for i in "${projects[@]}"; do
    echo "$i"
done
```

This command stores each object from the "projects" array in an associative array called projects. Then, it uses a for loop to iterate through the objects and echo to print each object.

The output will be the same as before:

```text
{"name":"project 1","owner":"owner 1","id":1,"version":"2.3.0"}
{"name":"project 2","owner":"owner 1","id":2,"version":"1.54.0"}
{"name":"project 3","owner":"owner 2","id":3,"version":"4.9.2"}
```
