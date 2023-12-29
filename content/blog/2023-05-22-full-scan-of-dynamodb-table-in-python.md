---
author: Thomas Taylor
categories:
- cloud
- database
- programming
date: 2023-05-22 21:35:00-04:00
description: How to fully scan a DynamoDB table in Python
tags:
- aws
- aws-cli
- python
title: Full scan of DynamoDB table in Python
---

A full scan of DynamoDB in Python is possible by using the `LastEvaluatedKey`.

## Scanning DynamoDB using `LastEvaluatedKey`

According to the `boto3` scan [documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb/client/scan.html),

> If LastEvaluatedKey is present in the response, you need to paginate the result set. For more information, see Paginating the Results in the Amazon DynamoDB Developer Guide.

Simply check for the `LastEvaluatedKey` in the response using `response.get('LastEvaluatedKey')`.

```python
import boto3

dynamodb = boto3.resource(
    'dynamodb',
    aws_session_token=token,
    aws_access_key_id=access_key_id,
    aws_secret_access_key=secret_access_key,
    region_name=region
)

table = dynamodb.Table('table-name')

response = table.scan()
data = response['Items']
while response.get('LastEvaluatedKey') in response:
    response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
    data.extend(response['Items'])
```

In the example above, the list of items (`data`) is extended with each page of items.
