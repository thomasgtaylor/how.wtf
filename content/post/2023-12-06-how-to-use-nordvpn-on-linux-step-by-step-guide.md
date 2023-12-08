---
author: Thomas Taylor
categories:
- os
date: 2023-12-06T02:20:00-05:00
description: A step-by-step guide for using the NordVPN CLI client on Linux
images:
- images/G6rw3h.png
tags:
- linux
title: How to use NordVPN on Linux step-by-step guide
---

![how to use NordVPN on linux step-by-step](images/G6rw3h.png)

In this article, we'll discuss how to use NordVPN on Linux. This includes installation, authentication, and general usage of the CLI in Linux.

Please note, the links provided for NordVPN are affiliate links. This means if you click on them and make a purchase, I may receive a commission at no extra cost to you. This helps support the blog and allows me to continue creating content like this.

## What is NordVPN?

[NordVPN][1] is a robust virtual private network (VPN) service that ensures secure and anonymized internet access. It's easy to use, fast, and provides _many_ servers to connect from. Truth be told, it has been my go-to VPN solution for years.

## Why use NordVPN?

- 14 million users
- 5,400+ servers in 59 countries
- Split tunneling support
- 24/7 customer support

## Installing NordVPN on Linux

Sign up for [NordVPN][1] then run the installer for Linux using the following command:

```shell
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
```

If `curl` is not available on your system, `wget` is an option:

```shell
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
```

If you receive the following error:

```text
Whoops! Permission denied accessing /run/nordvpn/nordvpnd.sock
```

then modify your current user's permissions by running the following command:

```shell
sudo usermod -aG nordvpn $USER
```

For permission refresh, either reboot your machine using 

```shell
sudo reboot now
```

or re-login using your current user:

```shell
su - $USER
```

You're all set!

## Login with NordVPN CLI

To begin, you must login to your NordVPN account using the following command:

```shell
nordvpn login
```

This outputs a login url. *COPY* the url and paste it into a browser of your choosing.

After a successful attempt, the `Continue` button should authenticate your terminal session.

To verify, run the following command:

```shell
nordvpn account
```

If you receive the "You are not logged in" message, then you may optionally provide the `callback` URI to the CLI.

To do this, issue the `nordvpn login` command again. Before clicking the `Continue` button this time, right click it and copy the link.

Paste the uri in quotes as the value for the `--callback` argument:

```shell
nordvpn login --callback "nordvpn://login?action=login?exchange_token=<tokenhere>&status=done"
```

## Connect with NordVPN

Like I mentioned earlier, this is my preferred VPN because of its ease-of-use. To connect, simply run the following command:

```shell
nordvpn connect
```

Output:

```text
Connecting to the United States #10028 (us10028.nordvpn.com)
You are connected to United States #10028 (us10028.nordvpn.com)
```

You will automatically be connected to the nearest location.

### Connect with specific country using NordVPN

The NordVPN client allows connections to other locations seamlessly. To begin, run the following command to discover the countries available:

```shell
nordvpn countries
```

Connect to the country:

```shell
nordvpn connect COUNTRY
```

### Connect with specific city using NordVPN

Similary, discover the cities available by country using the following command:

```shell
nordvpn cities COUNTRY
```

For example,

```shell
nordvpn cities United_States
```

Connect to a city:

```shell
nordvpn connect COUNTRY CITY
```

For example,

```shell
nordvpn connect United_States New_York
```

## Automatically start NordVPN connection on Linux boot

To automatically connect NordVPN on boot, simply run the following command:

```shell
nordvpn set autoconnect enabled
```

## Set up NordVPN Kill Switch on Linux

If NordVPN connection is lost, you may optionally enable the killswitch to ensure all internet traffic stops:

```shell
nordvpn set killswitch enabled
```

## View NordVPN settings

If you want to view all the settings that can be toggled simply run:

```shell
nordvpn settings
```

## Conclusion

This article provides a step-by-step guide on installing and using NordVPN on Linux. It covers installation, logging in, connecting to different servers, and setting up features like auto-connect and killswitch. I hope you enjoyed the content!

[![get the nord vpn deal now](images/M5CQOY.png)](https://go.nordvpn.net/aff_c?offer_id=15&aff_id=97262&source=how-to-use-nordvpn-on-ubuntu-step-by-step-guide)

[1]: https://go.nordvpn.net/aff_c?offer_id=15&aff_id=97262&source=how-to-use-nordvpn-on-ubuntu-step-by-step-guide 
