---
author: Thomas Taylor
categories:
- os
date: 2023-12-01T01:25:00-05:00
description: This article describes how to install and use Docker without Docker Desktop for MacOS 
images:
- images/lLFsL5.png
tags:
- mac
title: How to use Docker without Docker Desktop on MacOS
---

![How to use Docker without Docker Desktop on MacOS](images/lLFsL5.png)

Docker Desktop was my de facto choice on MacOS due to its ease of installation and container management. This changed after Docker updated their [subscription service agreement][1].

## Step-by-step guide to installing Docker without Docker Desktop

The following tutorial assumes that you use `brew` as your package manager.

### Install docker

Firstly, install `docker` and `docker-credential-helper`.

```shell
brew install docker-credential-helper docker
```

`docker-credential-helper` provides a way for Docker to use the MacOS Keychain as a credential store.

### Install colima

The true power comes from [colima][2]: a container runtime for MacOS and Linux.

Install it using `brew`: 

```shell
brew install colima
```

### Start colima

Colima boasts its CLI ease of use! To get started, simply start the service:

```shell
colima start
```

### Using colima

After `colima` is installed, `docker` should hopefully work out-of-the-box:

```shell
docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Some applications do not respect `docker` contexts and will yield the following error:

```text
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

To remediate the issue, set the `DOCKER_HOST` variable.

```shell
export DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock
```

[1]: https://www.docker.com/blog/updating-product-subscriptions/
[2]: https://github.com/abiosoft/colima
