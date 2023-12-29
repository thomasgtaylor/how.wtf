---
author: Thomas Taylor
categories:
- os
date: 2023-04-06 21:30:00-04:00
description: How to validate if a string or file is valid json with jq
tags:
- linux
title: Check for valid json string or file with jq
---

Verifying if a string or file is valid json is easy with `jq`.

## Check if a string is valid `json`

Using the `-e` argument, `jq` will return a 0 if the last output was neither `false` nor `null`. 

```bash
if jq -e . >/dev/null 2>&1 <<<'{"test": "value"}'; then
    echo "parsed successfully"
else
    echo "could not parse json string"
fi
```

In addition, negating the above condition may increase readability:

```bash
if ! jq -e . >/dev/null 2>&1 <<<'{"test": "value"}'; then
    echo "could not parse json string"
    exit 1
fi
```

Using a variable:

```bash
if ! jq -e . >/dev/null 2>&1 <<<"$json"; then
    echo "could not parse json string"
    exit 1
fi
```

## Check if a file is valid `json`

Using the same technique from above:

```bash
if ! jq -e . >/dev/null 2>&1 <<<$(cat invalid.json); then
    echo "could not parse json file"
    exit 1
fi
```

the `invalid.json` file:

```json
{ "invalid"
```

will output:

```text
could not parse json file
```