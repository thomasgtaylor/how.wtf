---
author: Thomas Taylor
categories:
- programming
date: 2023-02-20 00:40:00-04:00
description: How to delete or remove files and directories in Python.
tags:
- python
title: How to delete files and directories in Python
---

How to delete a file or folder using Python?

## Removing files

### Remove a file with `os.remove()`

```python3
import os

os.remove("path/to/file")
```

### Remove a file with `pathlib.Path.unlink()`

```python3
from pathlib import Path

p = Path("path/to/file")
p.unlink()
```

## Removing directories

### Remove an empty directory with `os.rmdir()`

```python3
import os

os.rmdir("path/to/folder")
```

### Remove an empty directory with `pathlib.Path.rmdir()`

```python3
from pathlib import Path

p = Path("path/to/folder")
p.rmdir()
```

### Remove an empty directory and its contents with `shutil.rmtree()`

```python3
import shutil

shutil.rmtree("path/to/folder")
```