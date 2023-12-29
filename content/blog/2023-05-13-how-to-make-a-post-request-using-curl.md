---
author: Thomas Taylor
categories:
- os
date: 2023-05-13 10:25:00-04:00
description: How to make a POST request using curl
tags:
- linux
title: How to make a POST request using curl
---

For more information about `curl`, checkout the ["What is curl"](https://how.wtf/what-is-curl.html) article. This article will discuss how to interact with an API using `POST` requests through curl.

## Make a simple `POST` request

The basic syntax for sending a `POST` request using curl is:

```shell
curl -X POST https://example.com
```

The `-X` argument accepts an HTTP method for interacting with the server. For HTTP, valid values include: `GET` (default), `POST`, `PUT`, `DELETE`, etc. 

**NOTE**: The `-X` flag is a shorthand for `--request`. Either can be used. 

## Make a `POST` request with data

Users can send data along with a `POST` request.

```shell
curl -X POST -d "title=foo&body=test" \
	https://jsonplaceholder.typicode.com/posts
```

In the example above, a `POST` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to create a new post with a `title` of `foo` and a body of `test`. 

The default `Content-Type` is `application/x-www-form-urlencoded`. 

**NOTE**: The `-d` flag is a shorthand for `--data`. Either can be used.

## Make a `POST` request with JSON body

Users may optionally send `JSON` data in their request payloads.

### Making a `POST` request with JSON

```shell
curl -X POST \
	-H 'Content-Type: application/json' \
	-d '{"title":"foo","body":"bar"}' \
	https://jsonplaceholder.typicode.com/posts
```

In the example above, a `POST` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to create a new post with a `title` of `foo` and a body of `bar`.

The `-H` flag accepts a `Key: value` string that represents a header. In the above case, it sets the content type: `Content-Type: application/json`. 

**NOTE**: The `-H` flag is a shorthand for `--header`. Either can be used.

### Making a `POST` request with a JSON file

In addition to text, the `-d` parameter accepts a file using the syntax `@filename`. 

If a file is named `post.json`

```json
{ 
	"title": "foo",
	"body": "test"
}
```

then curl can pass on its contents:

```shell
curl -X POST \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts
```