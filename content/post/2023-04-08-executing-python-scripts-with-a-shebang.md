---
author: Thomas Taylor
categories:
- programming
date: 2023-04-08 10:50:00-04:00
description: How to execute Python scripts using a shebang
tags:
- python
title: Executing Python scripts with a shebang
---

The shebang line informs the operating system's shell where to find the interpreter. The program loader will execute the specified interpreter with the same arguments that were initially passed.

## Add a shebang (`#!`) to a Python script

How to add a shebang (`#!`) to a Python 3 file:

```python
#!/usr/bin/env python3

print("hello world")
```

In addition to the normal execution by calling the interpreter directly:

```shell
python3 ./hello.py
```

the file can be called like this:

```shell
./hello.py
```

**Note**: The executable may not have executable permissions by the user. To enable for this, simply run:

```shell
chmod +x ./hello.py
```