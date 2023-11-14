---
author: Thomas Taylor
categories:
- programming
date: 2023-04-18 23:50:00-04:00
description: How to create a dynamic variable name in Bash
tags:
- bash
title: Dynamic variable names in Bash
---

In Bash, dynamic variables can be created using indirect [expansion](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion).

## How to create a dynamic variable name

In a CI container, there may be a need to delineate between different environment variable values using a prefix for a variable name.

```bash
#!/bin/sh
# In the container at runtime:
# export PROD_TOKEN="123"
env="PROD"
secret="${env}_TOKEN"
echo ${!secret}
```

Output:

```text
123
```

In the example above, the `secret` value is `PROD_TOKEN` after expansion. Using indirect expansion, `${!secret}` references `123`.