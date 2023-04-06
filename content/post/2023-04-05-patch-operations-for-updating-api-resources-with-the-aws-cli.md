---
title: Patch operations for updating api resources with the AWS CLI
date: 2023-04-05T23:45:00-04:00
author: Thomas Taylor
description: How to use the patch operations argument when updating API resources with the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

When updating API Gateway resources using the AWS CLI, some commands include a `--patch-operations` argument.

For example, the [`update-base-path-mapping`](https://docs.aws.amazon.com/cli/latest/reference/apigateway/update-base-path-mapping.html) allows an optional `--patch-operations`. For more information about which resources are supported via patch operations, the AWS documentation is [here](https://docs.aws.amazon.com/apigateway/latest/api/patch-operations.html).

## How to use the `--patch-operations` argument

In the case for updating a base path mapping, a user may need to supply a `restapiId` and `stage` value.

The JSON array:

```json
[
  {
    "op": "replace",
    "path": "/restapiId",
    "value": "id"
  },
  {
    "op": "replace",
    "path": "/stage",
    "value": "prod"
  }
]
```

The `aws apigateway update-base-path-mapping` allows for a stringified `json` array value for the `--patch-operations` argument:

```shell
domain_name="example.com"
base_path="some-path"
api_id="id"
stage="prod"
aws apigateway update-base-path-mapping \
	--domain-name $domain_name \
	--base-path $base_path \
	--patch-operations "[{\"op\":\"replace\",\"path\":\"/restapiId\",\"value\":\"$api_id\"},{\"op\":\"replace\",\"path\":\"/stage\",\"value\":\"$stage\"}]"
```

The same `--patch-operations` argument format applies to the other API Gateway commands as well.
