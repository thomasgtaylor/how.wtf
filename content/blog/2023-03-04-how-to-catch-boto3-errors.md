---
author: Thomas Taylor
categories:
- programming
date: 2023-03-04 01:25:00-04:00
description: How to catch errors in Boto3 with Python
tags:
- python
title: How to catch Boto3 errors
---

Catching errors with the `boto3` library is straightfoward.

## Catching `boto3` errors with `ClientError`

```python3
import boto3
import botocore

s3 = boto3.client("s3")

try:
    s3.get_object(Bucket="bucket", Key="key")
except botocore.exceptions.ClientError as e:
    if e.response["Error"]["Code"] == "AccessDenied":
        print(e.response["Error"]["Message"])
    else:
        raise
```

Other information in the `e.response` object may additionally be useful:
- `e.response["Error"]["Code"]` for the error code
- `e.response["Error"]["Message"]` for the error message
- `e.response["ResponseMetadata"]["RequestId"]` for the request id
- `e.response["ResponseMetadata"]["HTTPStatusCode"]` for the status code

`e.response`'s full dictionary:

```text
{
    'Error': {
        'Code': 'AccessDenied',
        'Message': 'Access Denied'
    }, 
    'ResponseMetadata': {
        'RequestId': 'requestId',
        'HostId': 'hostId',
        'HTTPStatusCode': 403,
        'HTTPHeaders': {
            'x-amz-request-id': 'requestId',
            'x-amz-id-2': 'id-2',
            'content-type': 'application/xml',
            'transfer-encoding': 'chunked',
            'date': 'Sat, 04 Mar 2023 06:11:15 GMT',
            'server': 'AmazonS3'
        },
        'RetryAttempts': 0
    }
}
```

## Catching `boto3` errors with service exceptions

For some clients, the AWS Python SDK has exposed service exceptions:

```python3
import boto3
import botocore

s3 = boto3.client("s3")

try:
    s3.create_bucket(Bucket="bucket")
except s3.exceptions.BucketAlreadyExists:
    print("s3 bucket already exists")
except botocore.exceptions.ClientError as e:
    print(e)
```