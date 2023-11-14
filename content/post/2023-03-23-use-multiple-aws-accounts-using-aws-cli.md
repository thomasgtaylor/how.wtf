---
author: Thomas Taylor
categories:
- cloud
date: 2023-03-23 00:30:00-04:00
description: How to use multiple AWS accounts using the AWS CLI
tags:
- aws
- aws-cli
title: Use multiple AWS accounts using AWS CLI
---

Using multiple AWS accounts from the command line is natively handled with profiles in the AWS CLI.

## Using `aws configure`

Using the `aws configure` command, multiple profiles can be configured.

```shell
aws configure --profile account1
AWS Access Key ID [None]: ...
AWS Secret Access Key [None]: ...
Default region name [None]: ...
Default output format [None]: ...
```

Then, the `--profile account1` option may be used with future commands.

```shell
aws s3 ls --profile account1
```

Or an environment variable may be set.

```shell
export AWS_PROFILE=account1
aws s3 ls # uses account1 credentials
```

Note: If the profile is named `--profile default`, it will represent the default profile when no `--profile` argument is provided.

## Manually setting credentials

The `~/.aws/credentials` and `~/.aws/config` files can be modified directly.

1. Add the credentials to the `~/.aws/credentials` file

```text
[default]
aws_access_key_id=accesskey
aws_secret_access_key=secretaccesskey

[account1]
aws_access_key_id=accesskey
aws_secret_access_key=secretaccesskey
```

2. Add the profile to the `~/.aws/config` file

```text
[default]
region=us-east-1
output=json

[profile account1]
region=us-east-1
output=json
```

3. Use the `--profile` argument _or_ set the `AWS_PROFILE` environment variable.

```shell
aws s3 ls --profile account1
```

OR

```shell
export AWS_PROFILE=account1
aws s3 ls # uses account1 credentials
```