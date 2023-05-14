---
title: What is curl
date: 2023-05-12T00:55:00-04:00
lastmod: 2023-05-14T18:30:00-04:00
author: Thomas Taylor
description: What is curl in Linux?
categories:
- OS
tags:
- Linux
---

Curl is a command line utility that was created in 1998 for transferring data using URLs. Fundamentally, `curl` allows users to create network requests to a server by specifying a location in the form of a URL and adding optional data.

`curl` (short for "Client URL") is powered by libcurl – a portable client-side URL transfer library written in C. 

## Why use curl?

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

### Perform a `GET` request

The simplest usage is a default `GET` request for a website or API:

```shell
curl https://pokeapi.co/api/v2/machine/1
```

Output:

```json
{"id":1,"item":{"name":"tm00","url":"https://pokeapi.co/api/v2/item/1288/"},"move":{"name":"mega-punch","url":"https://pokeapi.co/api/v2/move/5/"},"version_group":{"name":"sword-shield","url":"https://pokeapi.co/api/v2/version-group/20/"}}
```

### Download a file

Downloading a file using the same name as the remote server:

```shell
curl -O https://github.com/curl/curl/releases/download/curl-8_0_1/curl-8.0.1.tar.gz
```

Downloading a file and specifying a new name:

```shell
curl -o curl.tar.gz https://github.com/curl/curl/releases/download/curl-8_0_1/curl-8.0.1.tar.gz
```

## Conclusion

`curl` is a powerful and versatile command line utility that offers a wide range of supporting features: multiple protocols, multiple options, data types, etc.
