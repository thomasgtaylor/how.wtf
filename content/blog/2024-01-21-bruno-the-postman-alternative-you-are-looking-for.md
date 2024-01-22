---
author: Thomas Taylor
categories:
- os
date: '2024-01-21T22:50:00-05:00'
description: Bruno is the perfect Postman replacement – and it's free & open-source.
tags:
- api
title: 'Bruno: The Postman alternative you are looking for'
---

Postman used to be my favorite API testing tool, but the company's decision to phase out the final local collection storage feature, Scratchpad, in favor of mandatory cloud services, has changed that.

## What is the best Postman alternative?

Finding an alternative means it must satisfy the following requirements:

1. Local collection storage
2. Git-friendly collection definitions for my team members
3. CLI that can invoke collections
4. Beautiful desktop GUI
5. **No forced account login**

with a nice-to-have being open-source.

With that in mind, I came across a service that fulfills all the requirements: [bruno][1].

## What is Bruno

Bruno is an open-source Postman alternative that aims to provide a seamless offline experience for testing APIs.

It also plays nicely with Git by using a [markdown language, Bru][2], for defining collections.

## Installing Bruno

For MacOS users, installing `bruno` is easy with `brew`:

```shell
brew install bruno
```

It's also supported in many other popular package managers:

```shell

# On Windows via Chocolatey
choco install bruno

# On Windows via Scoop
scoop bucket add extras
scoop install bruno

# On Linux via Snap
snap install bruno
```

## Migrating from Postman

If you're planning to migrate from Postman to Bruno, there are import options for collections and environments. For me, it was as simple as exporting the collections/environments in JSON format and importing them.

## Scripting in Bruno

Like Postman, Bruno offers scripting capabilities for automating your workflow. I do not use this feature in either solution, but there is [more information about it in the Bruno documentation][3].

## Using Bruno CLI

In this section, I will use [the Cat Fact API][4] as an example collection.

### Installing Bruno CLI

Firstly, let's install the Bruno CLI using `npm`:

```shell
npm install -g @usebruno/cli
```

### Define a collection for catfacts

I opened Bruno and created a new collection named `Cat Facts API` with a single `GET` request named `Get Random Fact`.

![The cat facts api collection shown in the Bruno desktop application](images/AAlbBK.webp)

When creating my collection, Bruno prompted me to select a folder to store my collection in.

That folder had this structure:

```text
catfacts
├── Get Random Fact.bru
├── bruno.json
└── environments
    └── production.bru
```

`Get Random Fact.bru` had file contents like this:

```text
meta {
  name: Get Random Fact
  type: http
  seq: 1
}

get {
  url: {{baseUrl}}/fact
  body: none
  auth: none
}
```

`bruno.json` had file contents like this:

```text
{
  "version": "1",
  "name": "Cat Facts API",
  "type": "collection"
}
```

and the `production.bru` file looked like this:

```text
vars {
  baseUrl: https://catfact.ninja
}
```

### Invoke a collection from the Bruno CLI

I navigated to the collection folder and ran the following command:

```shell
bru run --env production
```

Output:

```text
Running Folder Recursively 

Get Random Fact (200 OK) - 177 ms

Requests:    1 passed, 1 total
Tests:       0 passed, 0 total
Assertions:  0 passed, 0 total
Ran all requests - 177 ms
```

This executes every `.bru` file in the folder.

Bruno additionally gives the ability to run single requests:

```shell
bru run Get\ Random\ Fact.bru --env production
```

Output:

```text
Running Request 

Get Random Fact (200 OK) - 175 ms

Requests:    1 passed, 1 total
Tests:       0 passed, 0 total
Assertions:  0 passed, 0 total
Ran all requests - 175 ms
```

[1]: https://www.usebruno.com/
[2]: https://www.usebruno.com/bru
[3]: https://docs.usebruno.com/scripting/introduction.html
[4]: https://catfact.ninja/
