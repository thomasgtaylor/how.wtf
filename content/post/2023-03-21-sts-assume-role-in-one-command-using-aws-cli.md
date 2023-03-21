---
title: STS assume role in one command using AWS CLI
date: 2023-03-21T00:00:00-04:00
author: Thomas Taylor
description: How STS assume role in one command using the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

In order to assume a role, two actions must normally be completed.

## How to assume role with STS

```shell
aws sts assume-role \
	--role-arn ROLE \
	--role-session-name test
```

Output:

```json
{
	"Credentials": {
		"AccessKeyId": "...",
		"SecretAccessKey": "...",
		"SessionToken": "...",
		"Expiration": "2023-03-21T11:32:58+00:00"
	},
	"AssumedRoleUser": {
		"AssumedRoleId": "...",
		"Arn": "..."
	}
}
```

then, export the credentials in the next step

```shell
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```

## How to assume role in one command

Manually exporting the credentials is a tedious process; however, the command can be simplified to export in _one_ line.

```shell
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
	--role-arn arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME \
	--role-session-name SESSION_NAME \
	--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
	--output text))
```

This solution uses the `printf` built-in.
