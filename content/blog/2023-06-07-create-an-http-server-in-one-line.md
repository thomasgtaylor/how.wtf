---
author: Thomas Taylor
categories:
- os
date: 2023-06-07 20:40:00-04:00
description: How to create an HTTP server in one line
tags:
- linux
title: Create an HTTP server in one line
---

If you need a quick one-liner HTTP server from the command line, Python comes in handy.

## How to create an HTTP server in one line

Python enables users to run a simple command to spin up an HTTP server:

```shell
python -m http.server <PORT>
```

Example:

```shell
python -m http.server 4000
```

By default, this command will serve the files in the current directory using a single-threaded HTTP server bound to localhost.

In addition, users may specify a different directory:

```shell
python -m http.server <PORT> --directory <FILE PATH>
```