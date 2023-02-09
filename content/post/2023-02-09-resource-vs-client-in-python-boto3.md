---
title: Resource vs. Client in Python Boto3
date: 2023-02-09T00:45:00-04:00
author: Thomas Taylor
description: What is the difference between a Python Boto3 Resource and Client?
categories:
- Cloud
tags:
- AWS
- Python
---

**Resource** and **Client** are two different abstractions in the Boto3 SDK. What are the differences between the two?

## Clients

Clients provide lower-level access to AWS Services. They typically represent a 1:1 functionality mapping of any AWS service API and are generated via JSON service definition files such as the one for [DynamoDB](https://github.com/boto/botocore/blob/develop/botocore/data/dynamodb/2012-08-10/service-2.json). The botocore library is shared between the AWS CLI & Boto3.

For example, the DynamoDB `PutItem` API call requires `TableName` and `Item` [parameters to be supplied](https://github.com/boto/botocore/blob/ed72f826cb837e24693f540fc19c6e25ade75a95/botocore/data/dynamodb/2012-08-10/service-2.json#L4301). The `Item` parameter is required to be a `PutItemAttributeMap` which forces the user to add typing for each value. In addition to handling the strict input types, users are required to handle pagination.

```python3
import boto3

dynamodb = boto3.Client("dynamodb")
dynamodb.put_item(
    TableName="table_name",
    Item={
        "id": { "S": "test" }
    }
)
```

## Resources

Resources provide higher-level access to AWS Services and reside within `boto3`. They are only supported for a subset of AWS services and are generated via JSON resource definition files such as the one for [DynamoDB](https://github.com/boto/boto3/blob/develop/boto3/data/dynamodb/2012-08-10/resources-1.json)

For example, the DynamoDB `PutItem` API call is completed using the `Table` object. 

```python3
import boto3

dynamodb = boto3.Resource("dynamodb")
table = dynamodb.Table("table_name")
table.put_item(
    Item={
        "id": "test"
    }
)
```

As opposed to the clients, resources typically handle marshalling data and pagination.

## Should I use a client or resource?

If resources are available for the service your application is interfacing with, use them. Otherwise, use clients. The full list of services are [here](https://github.com/boto/boto3/tree/develop/boto3/data).

## Note

Per the [boto3 resources documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/resources.html),

> The AWS Python SDK team does not intend to add new features to the resources interface in boto3. Existing interfaces will continue to operate during boto3's lifecycle. Customers can find access to newer service features through the client interface.

The AWS Python SDK team [will not be adding new resource abstractions](https://github.com/boto/boto3/discussions/3563); however, the resources that are supported will function in perpetuity.
