---
author: Thomas Taylor
categories:
- cloud
date: 2023-03-20 01:20:00-04:00
description: How to debug the "Invalid base64" error when invoking lambda functionsfrom the AWS CLI
tags:
- aws
- aws-cli
title: Invalid base64 error Lambda AWS CLI
---

The **Invalid base64** error occurs when invoking a lambda from the AWS CLI because the default `--payload` parameter expects `base64` encoding.

```shell
aws lambda invoke --function-name test --payload '{"movie": "John Wick"}' response.json
```

Error output:

```shell
Invalid base64: "{"movie": "John Wick"}"
```

## Solve `Invalid base64` lambda invoke error

To solve the **Invalid base64** error, supply the `--cli-binary-format` parameter with the value `raw-in-base64-out`:

```shell
aws lambda invoke --function-name test --cli-binary-format raw-in-base64-out --payload '{"movie": "John Wick"}' response.json
```

Output:

```json
{
	"StatusCode": 200,
	"ExecutedVersion": "$LATEST"
}
```

## Invoke a lambda using a file

A user may opt to supply a `.json` file:

```json
{
	"movie": "John Wick"
}
```

```shell
aws lambda invoke --function-name test --cli-binary-format raw-in-base64-out --payload file://request.json response.json
```