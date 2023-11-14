---
author: Thomas Taylor
categories:
- programming
date: 2023-04-29 23:55:00-04:00
description: How to create dictionaries or maps in Bash
tags:
- bash
title: Create dictionaries or maps in Bash
---

`bash` 4.0 natively supports creating hash tables / maps / dictionaries.

## Using maps in Bash

Variables in `bash` are loosely typed; however, declaring provides a type-like behavior. One of the supported types in `bash` is an associative array (`-A`).

To declare an associative array:

```bash
declare -A scores
```

To declare and instantiate in a single line:

```bash
declare -A scores=( ["peter"]=95 ["sally"]=98 )
```

### Add key/value pairs

Adding key/value pairs to an existing associate array:

```bash
scores["tom"]=85

# using variables
name="brandon"
score=50
scores[$name]=$score
```

### Retrieve key/value pairs

Retrieving key/value pairs from an existing associative array:

```bash
name="peter"
echo ${scores[$name]} # 95
```

### Update an existing key/value pair

Updating an existing key/value pair in an existing associative array:

```bash
name="peter"
scores[$name]=100
echo ${scores[$name]} # 100
```

### Check if a key exists

```bash
name="peter"
if [ -v scores[$name] ]; then
    echo "$name exists in the map"
fi
# Output: peter exists in the map
```

### Remove a key

```bash
name="peter"
unset scores[$name]
```

### Iterate map

```bash
for key in "${!scores[@]}"; do
    echo "$key ${scores[$key]}"
done
```

Output:

```text
tom 85
brandon 50
sally 98
peter 100
```