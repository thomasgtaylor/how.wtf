---
title: Test AWS credentials using AWS CLI
date: 2023-05-05T23:55:00-04:00
author: Thomas Taylor
description: How to test AWS credentials using the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

Testing for AWS credentials is a straightforward operation.

## Using `get-caller-identity`

There is a single API call that will always work regardless of permissions: [GetCallerIdentity](https://docs.aws.amazon.com/STS/latest/APIReference/API_GetCallerIdentity.html)

```shell
aws sts get-caller-identity
```

Output:

```text
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/thomas"
}
```

The `Arn` value depends on the type of credentials, but mostly includes the human-friendly name.

In addition, checking the status is reliable: `0` for success, `255` for failure.
