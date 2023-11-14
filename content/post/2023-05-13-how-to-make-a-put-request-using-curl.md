---
author: Thomas Taylor
categories:
- os
date: 2023-05-13 16:10:00-04:00
description: How to make a PUT request using curl
tags:
- linux
title: How to make a PUT request using curl
---

For more information about `curl`, checkout the ["What is curl"](https://how.wtf/what-is-curl.html) article. This article will discuss how to interact with an API using `PUT` requests through curl.

## Make a simple `PUT` request

The basic syntax for sending a `PUT` request using curl is:

```shell
curl -X PUT https://example.com
```

The `-X` argument accepts an HTTP method for interacting with the server. For HTTP, valid values include: `GET` (default), `POST`, `PUT`, `DELETE`, etc. 

**NOTE**: The `-X` flag is a shorthand for `--request`. Either can be used. 

## Make a `PUT` request with data

Users can send data along with a `PUT` request.

```shell
curl -X PUT -d "title=newtitle&body=newbody" \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `PUT` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to update an existing post (`1`) with a `title` of `newtitle` and a body of `newbody`.

The default `Content-Type` is `application/x-www-form-urlencoded`. 

**NOTE**: The `-d` flag is a shorthand for `--data`. Either can be used.

## Make a `PUT` request with JSON body

Users may optionally send `JSON` data in their request payloads.

### Making a `PUT` request with JSON

```shell
curl -X PUT \
	-H 'Content-Type: application/json' \
	-d '{"title":"newtitle","body":"newbar"}' \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, a `PUT` request is sent to the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) to update an existing post (`1`) with a `title` of `newtitle` and a body of `newbody`.

The `-H` flag accepts a `Key: value` string that represents a header. In the above case, it sets the content type: `Content-Type: application/json`. 

**NOTE**: The `-H` flag is a shorthand for `--header`. Either can be used.

### Making a `PUT` request with a JSON file

In addition to text, the `-d` parameter accepts a file using the syntax `@filename`. 

If a file is named `post.json`

```json
{ 
	"title": "newtitle",
	"body": "newbody"
}
```

then curl can pass on its contents:

```shell
curl -X PUT \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts/1
```