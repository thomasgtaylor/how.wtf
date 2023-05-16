---
title: How to use curl for HTTP requests
date: 2023-05-15T23:40:00-04:00
author: Thomas Taylor
description: How to use curl for HTTP requests
categories:
- OS
tags:
- Linux
---

Curl is a command line utility that was created in 1998 for transferring data using URLs. Fundamentally, `curl` allows users to create network requests to a server by specifying a location in the form of a URL and adding optional data.

`curl` (short for "Client URL") is powered by libcurl – a portable client-side URL transfer library written in C.

## Why use the curl command?

Common use cases for `curl` include:

- It can download and upload files
- It has great error logging
- It allows for quick endpoint testing
- It provides granular details which aides debugging
- It is portable and works with most operating systems
- It is an actively managed open-source tool that is battled tested with a large user base

## Base `curl` command usage

The basic syntax for a `curl` command is:

```text
curl [OPTIONS] [URL]
```

## HTTP Requests using `curl`

Curl provides native support for all HTTP requests methods: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, etc.

For all the following examples, the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) will be used.

### Make a `GET` request

```shell
curl https://jsonplaceholder.typicode.com/posts/1
```

OR

```shell
curl -X GET https://jsonplaceholder.typicode.com/posts/1
```

**NOTE**: The `-X` flag is a shorthand for `--request`. It’s not required because the default value is `GET`.

Output:

```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
```

In addition, an optional `Accept` header may be used:

```shell
curl \
	-H "Accept: application/json" \
	https://jsonplaceholder.typicode.com/posts/1
```

### Make a `POST` request

```shell
curl -X POST -d "title=foo&body=test" \
	https://jsonplaceholder.typicode.com/posts
```

In the example above, a new post titled `foo` with a body of `test` is created.

The default `Content-Type` of the request is: `application/x-www-form-urlencoded`

If a `JSON` payload is required, then the `Content-Type` header can be explicitly included:

```shell
curl -X POST \
	-H 'Content-Type: application/json' \
	-d '{"title":"foo","body":"bar"}' \
	https://jsonplaceholder.typicode.com/posts
```

Alternatively, a file may be specified (`post.json`):

```json
{
    "title": "foo",
    "body": "bar"
}
```

```shell
curl -X POST \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts
```

Output:

```json
{
  "title": "foo",
  "body": "bar",
  "id": 101
}
```

### Make a `PUT` request

Similarly to `POST`, a `PUT` can use all the same options:

```shell
curl -X PUT -d "title=foo&body=test" \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, post 1 is re-titled to `foo` and given a new body of `test`.

The default `Content-Type` of the request is: `application/x-www-form-urlencoded`

If a `JSON` payload is required, then the `Content-Type` header can be explicitly included:

```shell
curl -X PUT \
	-H 'Content-Type: application/json' \
	-d '{"title":"foo","body":"bar"}' \
	https://jsonplaceholder.typicode.com/posts/1
```

Alternatively, a file may be specified (`post.json`):

```json
{
    "title": "foo",
    "body": "bar"
}
```

```shell
curl -X PUT \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts/1
```

Output:

```json
{
  "title": "foo",
  "body": "bar",
  "id": 1
}
```

### Make a `PATCH` request

Similarly to `POST` and `PUT`, a `PATCH` can use all the same options:

```shell
curl -X PATCH -d "title=foo2" \
	https://jsonplaceholder.typicode.com/posts/1
```

In the example above, post 1 is re-titled to `foo2`.

The default `Content-Type` of the request is: `application/x-www-form-urlencoded`

If a `JSON` payload is required, then the `Content-Type` header can be explicitly included:

```shell
curl -X PATCH \
	-H 'Content-Type: application/json' \
	-d '{"title":"foo2"}' \
	https://jsonplaceholder.typicode.com/posts/1
```

Alternatively, a file may be specified (`post.json`):

```json
{
    "title": "foo2"
}
```

```shell
curl -X PATCH \
	-H 'Content-Type: application/json' \
	-d @post.json \
	https://jsonplaceholder.typicode.com/posts/1
```

Output:

```json
{
  "userId": 1,
  "id": 1,
  "title": "foo2",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
```

### Make a `DELETE` request

```shell
curl -X DELETE https://jsonplaceholder.typicode.com/posts/1
```

Output:

```json
{}
```

## Conclusion

`curl` is a powerful and versatile command line utility that offers a wide range of supporting features: multiple protocols, multiple options, data types, etc. HTTP requests are simple and reliable.
