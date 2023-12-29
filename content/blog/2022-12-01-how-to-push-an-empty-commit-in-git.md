---
author: Thomas Taylor
categories:
- programming
date: 2022-12-01 23:05:00-04:00
description: How to push without making changes in git.
tags:
- git
title: How to push an empty commit in Git
---

Pushing an empty commit using Git is straightforward. Git provides an optional flag on the `git commit` command: `--allow-empty`.

## Pushing without making changes

```text
git commit --allow-empty -m "empty commit"
```

```text
git push
```

The commit will be pushed without requiring changes.

## Why is this useful?

This is useful for retrying a CI pipeline when an issue occurs with a GitHub webhook _or_ CI service.