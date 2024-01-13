---
author: Thomas Taylor
categories:
- cloud
- database
- programming
date: '2024-01-13T12:30:00-05:00'
description: This article explains two methods for implementing version control in DynamoDB.
tags:
- aws
- dynamodb
- serverless
title: Implement version control in DynamoDB
---

Amazon DynamoDB is a fully managed service provided by AWS that enables developers to quickly store data for their applications. In this article, I will showcase how to implement version control in DynamoDB for recording changes to data over time.

## What is version control in DynamoDB

DynamoDB does not support native version control on a per-item basis. If you need to record changes to your data over time, it must be handled via the application. Luckily, there is a paradigm that supports storing multiple versions of the same data: duplication.

## How to implement versioning in DynamoDB

We have a few options for storing versioned data in DynamoDB. For the purposes of this tutorial, we will use a **single table** design: i.e., using a primary key and a sort key to manage multiple data types.

## Creating a table with versioning in DynamoDB

For the remaining sections of this tutorial, we'll leverage the same single table.

### Create a table

To begin, let's define a table using the AWS CLI:

```shell
aws dynamodb create-table \
    --table-name table \
    --attribute-definitions \
        AttributeName=PK,AttributeType=S \
        AttributeName=SK,AttributeType=S \
    --key-schema \
        AttributeName=PK,KeyType=HASH \
        AttributeName=SK,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5
```

I specified a primary key named `PK` and a sort key of `SK`.

### Time versioning

Time-based versioning may be useful for applications that need to store the status of data at certain timed intervals.

![DynamoDB key structure for time-based versioning](images/HSkq9c.webp)

#### Inserting example data

To showcase the power of DynamoDB, let's insert some values for a file object with an identifier of 1.

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#1"},"SK":{"S":"2024-01-13T11:25:27-05:00"}}'
```

and another:

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#1"},"SK":{"S":"2024-01-13T11:32:13-05:00"}}'
```

and one more:

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#1"},"SK":{"S":"2024-01-13T11:37:58-05:00"}}'
```

#### Query for latest versions

Because the timestamps are sortable, we can leverage DynamoDB to perform the following requests:

1. Grab the last 100 versions
2. Grab all the versions by a specific interval (year, month, day, etc.)

**Grab the latest 100 versions (or up to the DynamoDB limits):**

```shell
aws dynamodb query \
    --table-name table \
    --key-condition-expression "PK=:pk" \
    --expression-attribute-values '{":pk":{"S":"file#1"}}' \
    --no-scan-index-forward
```

The `--no-scan-index-forward` flag is important to sort the records in descending order rather than the default of ascending.

Output:

```json
{
    "Items": [
        {
            "PK": {
                "S": "file#1"
            },
            "SK": {
                "S": "2024-01-13T11:37:58-05:00"
            }
        },
        {
            "PK": {
                "S": "file#1"
            },
            "SK": {
                "S": "2024-01-13T11:32:13-05:00"
            }
        },
        {
            "PK": {
                "S": "file#1"
            },
            "SK": {
                "S": "2024-01-13T11:25:27-05:00"
            }
        }
    ],
    "Count": 3,
    "ScannedCount": 3,
    "ConsumedCapacity": null
}
```

**Grab all versions by a specific interval**:

Using the `begins_with` or `between` operators, we can query for specific dates.

In the case below, I want to query everything that starts with `2024-01-13T11:3`:

```shell
aws dynamodb query \
    --table-name table \
    --key-condition-expression "PK=:pk and begins_with(SK, :sk)" \
    --expression-attribute-values '{":pk":{"S":"file#1"},":sk":{"S":"2024-01-13T11:3"}}' \
    --no-scan-index-forward
```

Output:

```json
{
    "Items": [
        {
            "PK": {
                "S": "file#1"
            },
            "SK": {
                "S": "2024-01-13T11:37:58-05:00"
            }
        },
        {
            "PK": {
                "S": "file#1"
            },
            "SK": {
                "S": "2024-01-13T11:32:13-05:00"
            }
        }
    ],
    "Count": 2,
    "ScannedCount": 2,
    "ConsumedCapacity": null
}
```

### Number versioning

For applications that want to maintain a "latest" version with the ability to rollback to a prior version, a number-based versioning paradigm will be optimal.

![DynamoDB key structure for number-based versioning](images/Vdqrh1.webp)

#### Inserting example data

To showcase the power of DynamoDB, let's insert some values for a file object with an identifier of 2 and 2 different versions.

The first item will be the `metadata` for `file#2`. This contains the attributes for the `file#2` when the application needs to fetch the latest version with the appropriate values.

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#2"},"SK":{"S":"metadata"},"version":{"S":"2"},"foo":{"S":"baz"}}'
```

The second item will contain version 1's information.

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#2"},"SK":{"S":"version#1"},"version":{"S":"1"},"foo":{"S":"bar"}}'
```

The third item will contain version 2's information.

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#2"},"SK":{"S":"version#2"},"version":{"S":"2"},"foo":{"S":"baz"}}'
```

For this method, we duplicate the attributes and values of `version#2` onto the main `metadata` object.

#### Query for latest versions

Let's query for all versions:

```shell
aws dynamodb query \
    --table-name table \
    --key-condition-expression "PK=:pk and begins_with(SK, :sk)" \
    --expression-attribute-values '{":pk":{"S":"file#2"},":sk":{"S":"version#"}}' \
    --no-scan-index-forward
```

Output:

```json
{
    "Items": [
        {
            "version": {
                "S": "2"
            },
            "SK": {
                "S": "version#2"
            },
            "PK": {
                "S": "file#2"
            },
            "foo": {
                "S": "baz"
            }
        },
        {
            "version": {
                "S": "1"
            },
            "SK": {
                "S": "version#1"
            },
            "PK": {
                "S": "file#2"
            },
            "foo": {
                "S": "bar"
            }
        }
    ],
    "Count": 2,
    "ScannedCount": 2,
    "ConsumedCapacity": null
}
```

The user decides they want `version#1` to be the selected version for `file#2`. To satisfy the request perform the following steps:

1. Modify the `metadata` item's `version` attribute to `1`
2. Duplicate the version's attributes onto the `metadata` item

```shell
aws dynamodb put-item \
    --table-name table \
    --item '{"PK":{"S":"file#2"},"SK":{"S":"metadata"},"version":{"S":"1"},"foo":{"S":"bar"}}'
```

Next time we fetch the latest version it'll point to version 1:

```shell
aws dynamodb get-item \
    --table-name table \
    --key '{"PK":{"S":"file#2"},"SK":{"S":"metadata"}}'
```

Output:

```json
{
    "Item": {
        "version": {
            "S": "1"
        },
        "SK": {
            "S": "metadata"
        },
        "PK": {
            "S": "file#2"
        },
        "foo": {
            "S": "bar"
        }
    }
}
```
