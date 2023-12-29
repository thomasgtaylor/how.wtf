---
author: Thomas Taylor
categories:
- os
date: 2023-05-13 11:50:00-04:00
description: How to make a GET request using curl
tags:
- linux
title: How to make a GET request using curl
---

For more information about `curl`, checkout the ["What is curl"](https://how.wtf/what-is-curl.html) article. This article will discuss how to interact with an API using `GET` requests through curl.

## Make a simple `GET` request

The basic syntax for sending a `GET` request using curl is:

```shell
curl https://example.com
```

OR

```shell
curl -X GET https://example.com
```

**NOTE**: The `-X` flag is a shorthand for `--request`. It's not required because the default value is `GET`.

## Make a `GET` request for JSON data

If the server responds differently per the [`Accept` header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept), users can specify for it to accept JSON data.

```shell
curl \
	-H "Accept: application/json" \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `GET` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to fetch a post with an id of `1` with an `Accept` header of `application/json`.

The  `-H`  flag accepts a  `Key: value`  string that represents a header.

**NOTE**: The  `-H`  flag is a shorthand for  `--header`. Either can be used.

This same technique may be used for other [mime types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types):

- `application/xml`
- `text/html`
- `img/png`
- etc.