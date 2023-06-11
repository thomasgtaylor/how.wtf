---
title: DynamoDB auto incrementing UUIDs Why UUIDs are the recommended choice
date: 2023-06-11T11:05:00-04:00
author: Thomas Taylor
description: Why auto incrementing is bad and a better alternative is UUIDs.
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

When working with Amazon DynamoDB, the design of the primary key plays a crucial role. Unlike traditional relational databases, DynamoDB does not natively support auto-incrementing primary keys. However, there are alternative approaches that provide greater flexibility and scalability.

In this article, we will explore the drawbacks of auto-incrementing primary keys in DynamoDB and present UUIDs as a recommended alternative.

## The Problem with Auto-Incrementing Keys

Auto-incrementing keys can result in hotspots and performance bottlenecks in DynamoDB. This occurs because new records are appended to the end of the table or partition, leading to an uneven distribution of data.

Furthermore, this uneven distribution can cause certain partitions to be overloaded while others remain underutilized, adversely impacting the scalability and performance of the system.

## Alternatives to Auto-Incrementing

As a viable alternative, UUIDs (Universally Unique IDs) offer a solution.

UUIDs ensure a low probability of collisions, even when generated across distributed systems. This makes them highly suitable for maintaining uniqueness in DynamoDB primary keys.

```python3
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('users')
table.put_item(Item={
    'user_id': str(uuid.uuid4()),
    'name': 'Foo bar',
    'email': 'foobar@example.com',
    'age': 55 
})
```

In the code snippet above, a user named Foo bar is inserted into a DynamoDB table using a generated UUID as the primary key.
