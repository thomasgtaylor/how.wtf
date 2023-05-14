---
title: How to make a PATCH request using curl
date: 2023-05-13T10:25:00-04:00
author: Thomas Taylor
description: How to make a PATCH request using curl
categories:
- OS
tags:
- Linux
---

For more information about `curl`, checkout the ["What is curl"](https://how.wtf/what-is-curl.html) article. This article will discuss how to interact with an API using `PATCH` requests through curl.

## Make a simple `PATCH` request

The basic syntax for sending a `PATCH` request using curl is:

```shell
curl -X PATCH https://example.com
```

The `-X` argument accepts an HTTP method for interacting with the server. For HTTP, valid values include: `GET` (default), `POST`, `PUT`, `DELETE`, etc. 

**NOTE**: The `-X` flag is a shorthand for `--request`. Either can be used. 

## Make a `PATCH` request with data

Users can send data along with a `PATCH` request.

```shell
curl -X PATCH -d "title=bar&body=foo" \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `PATCH` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to update an existing post (`1`) with a `title` of `bar` and a body of `foo`.

The default `Content-Type` is `application/x-www-form-urlencoded`. 

**NOTE**: The `-d` flag is a shorthand for `--data`. Either can be used.

## Make a `PATCH` request with JSON body

Users may optionally send `JSON` data in their request payloads.

### Making a `PATCH` request with JSON

```shell
curl -X PATCH \
	-H 'Content-Type: application/json' \
	-d '{"title":"bar","body":"foo"}' \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `PATCH` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to update an existing post (`1`) with a `title` of `bar` and a body of `foo`.

The `-H` flag accepts a `Key: value` string that represents a header. In the above case, it sets the content type: `Content-Type: application/json`. 

**NOTE**: The `-H` flag is a shorthand for `--header`. Either can be used.

### Making a `PATCH` request with a JSON file

In addition to text, the `-d` parameter accepts a file using the syntax `@filename`. 

If a file is named `post.json`

```json
{ 
	"title": "bar",
	"body": "foo"
}
```

then curl can pass on its contents:

```shell
curl -X PATCH \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts/1
```
