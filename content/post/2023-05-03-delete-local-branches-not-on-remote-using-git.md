---
title: Delete local branches not on remote using Git
date: 2023-05-03T23:55:00-04:00
author: Thomas Taylor
description: How to delete local branches that are not on remote using git.
categories:
- Programming
tags:
- Git
---

After merging changes or working on temporary branches, users may be left with a list of git branches on their local machine. Rather than deleting each branch one-by-one, running a simple script will can clear them out. 

## Delete local branches not found on remote

The one-liner script to delete local branches not found one remote:

```shell
git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
```

This works by detected if a branch is `[gone]` from remote.

