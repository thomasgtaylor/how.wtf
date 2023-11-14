---
author: Thomas Taylor
categories:
- os
date: 2023-05-06 21:25:00-04:00
description: How to install Docker on Ubuntu-based Linux distributions
tags:
- linux
title: Installing Docker on Ubuntu
---

Installing Docker on Ubuntu-based Linux distributions: Linux Mint, Zorin, Pop OS, etc. is simple!

## Installing Docker from CLI

Docker is available in the default repositories of `apt`. Install via:

```shell
sudo apt install docker.io
```

Add permissions to the `docker` group by adding the current user:

```shell
sudo usermod -a -G docker $(whoami)
```

Verify that everything worked:

```shell
docker ps
```

Output:

```text
CONTAINER ID        IMAGE               COMMAND             CREATED
```

## Troubleshooting

If the following error occurs after `docker ps`:

```shell
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json: dial unix /var/run/docker.sock: connect: permission denied
```

**1. Check if Docker is running:**

```shell
sudo systemctl status docker
```

the status should show `active (running)`. 

If not, restart the docker service with the following command:

```shell
sudo systemctl restart docker
```

**2. Verify that the current user is apart of the `docker` group**

```shell
grep docker /etc/group
```

the output should show `docker:x:135:USER` with `USER` as the current user given from `$(whoami)`. If not, add the current user to the `docker` group using the instructions above.

**3. Verify that the tty session shows correct group membership**

```shell
id -nG
```

the output should contain `docker` in the list. If not, reboot.

**4. Reboot**

If all the prior steps were successful, simply reboot.

```shell
sudo reboot
```