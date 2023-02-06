---
title: Storing large items in DynamoDB
date: 2023-02-06T00:30:00-04:00
author: Thomas Taylor
description: 'How to upload large items to DynamoDB and avoid the "Item size has exceeded the maximum allowed size error"'
categories:
- Programming
- Cloud
tags:
- Python
- AWS
- DynamoDB
- Serverless
---

What is the item size limit in DynamoDB?

Each item in a DynamoDB table has a maximum size limit of 400 KB, including both the attribute names and values. This limit applies to all data types: strings, numbers, and binary data.

1. [Partitioning the data](#partition-the-data)
2. [Compressing the data](#compress-the-data)
3. [Storing data in S3](#store-the-data-in-s3)

# How to handle large data in DynamoDB

## Partition the data

A simple way to get around the item size limit is to split the data into multiple items.

Table Name: **lorem**
|pk   |sk |data                    |
|-----|---|------------------------|
|lorem|p#0|Lorem ipsum dolor sit...|
|lorem|p#1|Euismod nisi porta lo...|
|lorem|p#2|rcu risus quis varius...|
|lorem|p#3|phasellus. Enim praes...|

```python3
import boto3

def partition_data(data, size):
    return [data[i:i+size] for i in range(0, len(data), size)]


# 100 paragraphs of Lorem ipsum
lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna 
aliqua. Sem integer vitae justo eget magna. At tellus at 
urna condimentum mattis pellentesque id. Habitasse...
"""

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("lorem")
partition_key = "lorem"
sort_key_prefix = "p#" # p for partition

# Write chunks to DynamoDB
chunks = partition_data(lorem, 5000)
for i, c in enumerate(chunks):
    table.put_item(
        Item={
            "pk": partition_key,
            "sk": f"{sort_key_prefix}{i}",
            "data": c
        }
    )

# Read chunks from DynamoDB
response = table.query(
    KeyConditionExpression="pk = :pk and begins_with(sk, :sk)",
    ExpressionAttributeValues={
        ":pk": partition_key,
        ":sk": sort_key_prefix
    },
    ScanIndexForward=True
)

# Query for all paginated results if applicable.
items = response["Items"]
while "LastEvaluatedKey" in response:
    response = table.query(ExclusiveStartKey=response["LastEvaluatedKey"])
    items.update(response["Items"])

# Concatenate the data field from all the items
lorem_from_dynamodb = "".join(i["data"] for i in items)

print(lorem == lorem_from_dynamodb) # prints True
```

## Compress the data

Try to reduce the size of your data by compression. Compression algorithms like Gzip can significantly reduce the size of the data.

### Compressing a single item

Table Name: **lorem**
|pk   |data                    |
|-----|------------------------|
|lorem|eJy1Xdly3LquffdX6ANu+...|
|lorem|eJytXFl227gS/c8quALtw...|


```python3
import boto3
import zlib


def compress_data(data):
    return zlib.compress(data.encode())


# 100 paragraphs of Lorem ipsum
lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna 
aliqua. Sem integer vitae justo eget magna. At tellus at 
urna condimentum mattis pellentesque id. Habitasse...
"""

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("lorem")
partition_key = "lorem"
sort_key = "lorem"

table.put_item(Item={"pk": partition_key, "data": compress_data(lorem)})

response = table.get_item(Key={"pk": partition_key})
data = response["Item"]["data"]

lorem_from_dynamodb = zlib.decompress(bytes(data)).decode()
print(lorem_from_dynamodb == lorem)  # prints true

```

### Compressing a partitioned item

**DynamoDB schema:**

Table Name: **lorem**
|pk   |sk |data                    |
|-----|---|------------------------|
|lorem|p#0|eJy1Xdly3LquffdX6ANu+...|
|lorem|p#1|eJytXFl227gS/c8quALtw...|

```python3
import boto3
import zlib


def partition_data(data, size):
    return [data[i : i + size] for i in range(0, len(data), size)]


def compress_data(data):
    return zlib.compress(data.encode())


# 100 paragraphs of Lorem ipsum
lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna 
aliqua. Sem integer vitae justo eget magna. At tellus at 
urna condimentum mattis pellentesque id. Habitasse...
"""

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("lorem")
partition_key = "lorem"
sort_key_prefix = "p#"  # p for partition

# Write chunks to DynamoDB
chunks = partition_data(lorem, 50000)
for i, c in enumerate(chunks):
    table.put_item(
        Item={
            "pk": partition_key,
            "sk": f"{sort_key_prefix}{i}",
            "data": compress_data(c),
        }
    )

# Read chunks from DynamoDB
response = table.query(
    KeyConditionExpression="pk = :pk and begins_with(sk, :sk)",
    ExpressionAttributeValues={":pk": partition_key, ":sk": sort_key_prefix},
    ScanIndexForward=True,
)

# Query for all paginated results if applicable.
items = response["Items"]
while "LastEvaluatedKey" in response:
    response = table.query(ExclusiveStartKey=response["LastEvaluatedKey"])
    items.update(response["Items"])

# Concatenate the data field from all the items
lorem_from_dynamodb = "".join(
    zlib.decompress(bytes(i["data"])).decode() for i in items
)

print(lorem_from_dynamodb == lorem) # prints true
```

## Store the data in S3

Consider storing the data in S3 as opposed to an attribute value in DynamoDB.

Table Name: **lorem**
|pk   |s3_key         |
|-----|---------------|
|lorem|s3://bucket/key|


```python3
import boto3

# 100 paragraphs of Lorem ipsum
lorem = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna 
aliqua. Sem integer vitae justo eget magna. At tellus at 
urna condimentum mattis pellentesque id. Habitasse...
"""

bucket_name = "bucket_name"
object_key = "object_key"
partition_key = "lorem"
s3_key = f"s3://{bucket_name}/{object_key}"

# Store data in S3 object
s3 = boto3.client("s3")
s3.put_object(Bucket=bucket_name, Key=object_key, Body=lorem.encode())

# Store reference to S3 object in DynamoDB
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("lorem")
table.put_item(Item={"pk": partition_key, "s3_key": s3_key})

# Get reference to S3 object in DynamoDB
response = table.get_item(Key={"pk": partition_key})
s3_key = response["Item"]["s3_key"]

# Read contents of S3 object
bucket, key = s3_key[5:].split("/")  # remove "s3://" prefix and split on "/"
response = s3.get_object(Bucket=bucket, Key=key)
lorem_from_s3 = response["Body"].read().decode()

print(lorem_from_s3 == lorem) # prints True
```
