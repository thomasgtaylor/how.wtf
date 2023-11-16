---
author: Thomas Taylor
categories:
- cloud
- database
date: 2023-02-08 00:00:00-04:00
description: 'An error occurred (ValidationException) when calling the operation: The provided key element does not match the schema'
tags:
- aws
- dynamodb
title: 'DynamoDB error: key element does not match the schema'
---

**The provided key element does not match the schema** occurs when getting or deleting a record without providing all the proper key elements.

## How to fix the error

If your DynamoDB schema includes a partition/hash key and a range/sort key, you must specify both attributes.

Given the schema:

```json
{
  "pk": "test_pk",
  "sk": "test_sk"
}
```

Python Boto3:

```python3
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("test")
table.get_item(
    Key={
        "pk": "test_pk",
        "sk": "test_sk"
    }
)

table.delete_item(
    Key={
        "pk": "test_pk",
        "sk": "test_sk",
        "other": "test"
    }
)
```
