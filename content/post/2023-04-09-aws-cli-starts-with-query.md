---
title: AWS CLI starts with query
date: 2023-04-09T19:30:00-04:00
author: Thomas Taylor
description: How to use a starts with query using the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

If a user wants to search AWS resources using a `starts_with` or "begins with" or "has prefix" query, the AWS CLI natively supports it.

## How to query using `starts_with`

Using AWS CloudFormation as an example, the AWS CLI allows for the following query syntax:

```shell
export prefix="<prefix>"
aws cloudformation describe-stacks \
	--query "Stacks[?starts_with(StackName, `$prefix`) == `true`].StackName"
```

This outputs all of the CloudFormation stack names that start with a particular prefix.

### `starts_with`

The `starts_with` syntax is included in the JMESPath [specification](https://jmespath.org/specification.html#starts-with). 

```text
boolean starts_with(string $subject, string $prefix)
```

> Returns  `true`  if the  `$subject`  starts with the  `$prefix`, otherwise this function returns  `false`.
