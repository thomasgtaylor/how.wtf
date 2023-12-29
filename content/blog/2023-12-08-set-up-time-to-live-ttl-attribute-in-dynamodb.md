---
author: Thomas Taylor
categories:
- cloud
- database
- programming
date: 2023-12-08T01:50:00-05:00
description: Learn how to setup time-to-live (TTL) attributes for DynamoDB
images:
- images/c6ETc4.png
tags:
- python
- aws
- dynamodb
- serverless
title: Set up time-to-live (TTL) attribute in DynamoDB
---

![How to set up time-to-live ttl attribute in Dynamodb](images/c6ETc4.png)

Amazon DynamoDB's Time to Live (TTL) feature allows for automatic item deletion after a specified timestamp. It comes at no extra cost and is useful for removing outdated data.

## TTL use-cases

1. Remove stale data and save on DynamoDB memory usage
2. Retain sensitive data only up to contractual or regulatory obligations
3. Trigger processes using DynamoDB Streams based on TTL deletions since the deletion stream is marked as ["system" rather than normal][1]

## How to setup TTL in DynamoDB step-by-step

This tutorial will use Python and the AWS CLI for demonstration purposes. The same logic can be applied to the tooling of your choice.

### Create a DynamoDB table with TTL

To keep things simple, we'll leverage the AWS CLI to quickly create a table.

```shell
aws dynamodb create-table \
    --table-name your-table \
    --attribute-definitions \
        AttributeName=pk,AttributeType=S \
        AttributeName=sk,AttributeType=S \
    --key-schema \
        AttributeName=pk,KeyType=HASH \
        AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5
```

then enable TTL

```shell
aws dynamodb update-time-to-live \
    --table-name your-table \
    --time-to-live-specification \
        AttributeName=expires_at,Enabled=true
```

Output:

```json
{
    "TimeToLiveSpecification": {
        "Enabled": true,
        "AttributeName": "expires_at"
    }
}
```

If you desire to deploy a table via AWS CDK or CloudFormation, they allow you to specify a `TimeToLiveSpecification` upon table creation:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: CloudFormation template for creating a DynamoDB table with TTL.
Resources:
  MyDynamoDBTable:
    Type: 'AWS::DynamoDB::Table'
    Properties:
      TableName: your-table
      AttributeDefinitions:
        - AttributeName: pk
          AttributeType: S
        - AttributeName: sk
          AttributeType: S
      KeySchema:
        - AttributeName: pk
          KeyType: HASH
        - AttributeName: sk
          KeyType: RANGE
      ProvisionedThroughput:
        ReadCapacityUnits: 5
        WriteCapacityUnits: 5
      TimeToLiveSpecification:
        AttributeName: expires_at 
        Enabled: true
```

### Add TTL attribute with proper format to an item

The value for a TTL attribute is required to be in [Unix Epoch time format][2]. Items with a timestamp older than the current time, except those older by 5 years or more, are marked as expired and will be deleted by the [per-partition background scanner][3].

Here is a Python example demonstrating how to insert an item with correctly formatted TTL:

```python
import boto3
import time

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("your-table")
current_time = int(time.time())

# TTL value (e.g., 24 hours from now)
ttl_value = current_time + 24 * 60 * 60  # 24 hours from now in seconds
item = {"pk": "1", "sk": "entity", "expires_at": ttl_value}

response = table.put_item(Item=item)
print(response)
```

Output:

```json
{
  "ResponseMetadata": {
    "RequestId": "...",
    "HTTPStatusCode": 200,
    "HTTPHeaders": {
      "server": "Server",
      "date": "Fri, 08 Dec 2023 06:24:48 GMT",
      "content-type": "application/x-amz-json-1.0",
      "content-length": "2",
      "connection": "keep-alive",
      "x-amzn-requestid": "...",
      "x-amz-crc32": "..."
    },
    "RetryAttempts": 0
  }
}
```

### DynamoDB Query without TTL expired items

Directly from the [AWS documentation][4]:

> TTL typically deletes expired items within a few days. Depending on the size and activity level of a table, the actual delete operation of an expired item can vary. Because TTL is meant to be a background process, the nature of the capacity used to expire and delete items via TTL is variable (but free of charge).

DynamoDB queries and scans will return the items that are supposed to be expired if they have not been removed from the table. To remediate this, use a filter expression:

```python
import boto3
import time

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("your-table")
current_time = int(time.time())
print(current_time)

query_params = {
    "KeyConditionExpression": "pk = :pk",
    "FilterExpression": "attribute_not_exists(#ttl) OR #ttl > :now",
    "ExpressionAttributeValues": {":pk": "1", ":now": current_time},
    "ExpressionAttributeNames": {"#ttl": "expires_at"},
}

response = table.query(**query_params)
print(response)
```

[1]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-before-you-start.html#time-to-live-ttl-before-you-start-notes
[2]: https://en.wikipedia.org/wiki/Unix_time
[3]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/howitworks-ttl.html
[4]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/howitworks-ttl.html
