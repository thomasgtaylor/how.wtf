---
author: Thomas Taylor
categories:
- os
date: 2023-05-14 10:15:00-04:00
description: How to make a DELETE request using curl
tags:
- linux
title: How to make a DELETE request using curl
---

For more information about `curl`, checkout the ["What is curl"](https://how.wtf/what-is-curl.html) article. This article will discuss how to interact with an API using `DELETE` requests through curl.

## Make a simple `DELETE` request

The basic syntax for sending a `DELETE` request using curl is:

```shell
curl -X DELETE https://example.com
```

**NOTE**: The `-X` flag is a shorthand for `--request`.

## `DELETE` request example

```shell
curl -X DELETE \
    https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `DELETE` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to delete a post with an id of `1`.