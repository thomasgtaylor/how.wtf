---
author: Thomas Taylor
categories:
- cloud
date: 2023-03-24 20:00:00-04:00
description: How to disable the pager for the AWS CLI
lastmod: 2023-03-25 00:45:00-04:00
tags:
- aws
- aws-cli
title: Turn off the pager for AWS CLI
---

Disabling the AWS CLI pager can be completed in three different ways.

## Disable the pager via environment variable

Setting the `AWS_PAGER` environment variable will disable the pager.

```shell
export AWS_PAGER=
aws s3 ls
```

## Disable the pager via configuration

In AWS CLI V2, support for a `cli_pager` profile option was added. In the  `~/.aws/config` file, the `cli_pager` may be used.

```text
[default]
cli_pager=
```
## Disable the pager via CLI argument

A global argument named `--no-cli-pager` exists to disable the AWS CLI pager _per_ command usage.

```shell
aws s3 ls --no-cli-pager
```