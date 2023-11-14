---
author: Thomas Taylor
categories:
- os
date: 2023-04-25 00:35:00-04:00
description: How to write jq output to a file
tags:
- linux
title: Write jq output to a file
---

If a user wants to write `jq` output to a file, the solution is simple.

## `jq` output to a file

Extract all project ids from the following `json` payload to a text file:

```json
{
  "projects": [
    { 
      "id": 1 
    },
    { 
      "id": 2
    }
  ]
}
```

```shell
echo '{"projects": [{"id": 1}, {"id": 2}]}' | jq '.projects[].id' > ids.txt
```

Output: `ids.txt`:

```text
1
2
```

Using the redirection operator (`>`), the `jq` results are written to a file.