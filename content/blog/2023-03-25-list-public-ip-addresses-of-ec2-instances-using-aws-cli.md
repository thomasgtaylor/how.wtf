---
author: Thomas Taylor
categories:
- cloud
date: 2023-03-25 00:45:00-04:00
description: How to use list public IP addresses of EC2 instances using the AWS CLI
tags:
- aws
- aws-cli
title: List public IP addresses of EC2 instances using AWS CLI
---

Listing all public IP addresses of EC2 instances can be completed using the `--query` argument.

```shell
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output text
```