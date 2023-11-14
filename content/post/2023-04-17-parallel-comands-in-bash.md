---
author: Thomas Taylor
categories:
- programming
date: 2023-04-17 23:45:00-04:00
description: How to run parallel commands in Bash
tags:
- bash
title: Parallel commands in Bash
---

Bash natively supports a `wait` command. 

## Run parallel processes

### Using default `wait` behavior

By default, `wait` will wait for all child processes to complete before continuing an execution. For most cases, this is sufficient.

```bash
sleep 2 && echo "hi" &
sleep 2 && echo "hi2" &

# Wait for child processes to finish
wait
```

Using the `&` character at the ending of a line sends the process to the background to complete. Without `wait`, the the script would end.

The script will complete in 2 seconds.

Output variation 1:

```text
hi
hi2
```

Output variation 2:

```text
hi2
hi
```

### Using `wait` with process ids

`wait` allows for a process id argument value. This may be useful for establishing chained `wait`s. 

In the example below, the "hi3" task depends on "hi"; however "hi2" may run in parallel with "hi".

```bash
sleep 2 && echo "hi" &
hi_pid=$!

# "hi2" does not require "hi"
sleep 2 && echo "hi2" &

wait $hi_pid

# "hi3" requires "hi"
sleep 2 && echo "hi3" &

wait
```

Output:

```text
hi2
hi
hi3
```

The process id of the last execution is returned using `$!`.