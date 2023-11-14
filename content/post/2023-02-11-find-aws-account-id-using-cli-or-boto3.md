---
author: Thomas Taylor
categories:
- cloud
- programming
date: 2023-02-11 01:15:00-04:00
description: How to find AWS Account ID using the AWS CLI or Boto3 in Python
tags:
- aws
- aws-cli
- python
title: Find AWS Account Id using CLI or Boto3
---

How to find the AWS Account ID using the AWS CLI or Boto3?

## AWS CLI

Retrieve your full identity

```shell
aws sts get-caller-identity
```

```json
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/user"
}
```

Use native AWS CLI `--query` option for querying the output.

```shell
aws sts get-caller-identity --query "Account" --output text
```

```shell
123456789012
```

## Python Boto3

```python3
import boto3

sts = boto3.client("sts")
account_id = sts.get_caller_identity()["Account"]
print(account_id) # 0123456789012
```