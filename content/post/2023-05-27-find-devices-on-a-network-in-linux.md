---
title: Find devices on a network in Linux
date: 2023-05-27T22:55:00-04:00
author: Thomas Taylor
description: How to find devices on a network in Linux
categories:
- OS
tags:
- Linux
---

Finding a device that's connected to a network on Linux is easy with an open source tool named `nmap`.

## What is `nmap`?

`nmap` is a utility for network discovery and security auditing. It's designed to rapidly scan large networks.

### Install `nmap`

`nmap` is available through most popular package managers.

For Debian-based distributions:

```shell
sudo apt install nmap
```

For MacOS:

```shell
brew install nmap
```

## Using `nmap`

Firstly, grab your IP address using `ifconfig`

```shell
ifconfig
```

the output will contain an IP.

```shell
inet 192.168.1.91 netmask 0xffffff00 broadcast 192.168.1.255
```

`nmap` is simple to use - simply run the command like the example below:

```shell
sudo nmap -sn 192.168.1.0/24
```

The `/24` is CIDR notation. It's instructing `nmap` to scan all ip addresses between 192.168.1.0 and 192.168.1.255.

The `-sn` option is a portless scan of the IP address range.

Output:

```text
Nmap scan report for 192.168.1.20
Host is up (0.012s latency).
MAC Address: 00:11:32:C2:7B:96 (Synology Incorporated)
```

In my case, I was looking for the IP address of my Synology NAS.
