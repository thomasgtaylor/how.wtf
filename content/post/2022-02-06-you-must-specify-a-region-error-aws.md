---
title: You must specify a region error AWS
date: 2023-02-07T00:00:00-04:00
author: Thomas Taylor
description: 'You must specify a region. You can also configuration your region by running "aws configure"'
categories:
- Cloud
tags:
- AWS
---

**You must specify a region** error occurs when a default AWS Region is not configured.

**Error:**
```text
You must specify a region. You can also configure your region by running "aws configure"
```

## How to fix the `You must specify a region` error

**Method 1**:
Set the `AWS_DEFAULT_REGION` environment variable

```shell
export AWS_DEFAULT_REGION="us-east-1"
```

**Method 2**:
Include the default region in the `~/.aws/config` file _or_ run `aws configure`

```shell
> aws configure
  AWS Access Key ID [None]:
  AWS Secret Access Key [None]:
  Default region name [None]: us-east-1
  Default output format [None]:
```

The `~/.aws/config` file will be generated with the following configuration:

```text
[default]
region = us-east-1
```

**Method 3**:
Explicity specify the region with the AWS API

AWS CLI:

```shell
aws ec2 describe-instances --region us-east-1
```

Python Boto3:

```python3
import boto3

kms = boto3.client("kms", region_name="us-east-1")
```

JavaScript AWS SDK

```javascript
import { S3Client } from '@aws-sdk/client-s3';

const s3Client = new S3Client({
  region: 'us-east-1'
});
```
