---
title: How to source shell scripts in Fish
date: 2023-03-17T01:30:00-04:00
author: Thomas Taylor
description: How to source general shell (sh or bash) scripts in fish
categories:
- OS
tags:
- Linux
---

There may be a use case to `source` a general `sh` or `bash` script in `fish`. For example, if a function is present in a script file that needs to be sourced, `fish` cannot execute the script because `sh` functions are not _natively_ supported.

## How to source general scripts in `fish`

Sourcing general scripts in `fish` is trivial with a plugin named `bass`. Using a preferred package manager, `bass` can be [installed](https://github.com/edc/bass#installation) and used to source scripts.

```bash
# variables.sh

example(){
  export VAR_NAME=test	
}
example
```

```shell
source ./variables.sh
```

Output:

```text
from sourcing file ./variables.sh
source: Error while reading file “./variables.sh”
```

Using `bass`:

```shell
bass source ./variables.sh
echo $VAR_NAME
```

Output:

```text
test
```
