---
title: Set cache control on S3 objects using the AWS CLI
date: 2023-03-09T08:20:00-04:00
author: Thomas Taylor
description: How to set cache control headers on S3 objects using the AWS CLI
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

Cache-control can be set on S3 bucket objects.

## Setting cache control using `aws s3 cp`

An object's metadata may only be changed by overwriting it using the `metadata-directive` flag.

Single file:

```shell
aws s3 cp s3://bucket/example.txt s3://s3-bucket/file.txt \
  --metadata-directive REPLACE \
  --cache-control max-age=86400
```

All files:

```shell
aws s3 cp s3://bucket/ s3://bucket/ \
  --metadata-directive REPLACE \
  --cache-control max-age=86400 \
  --recursive
```

All image files / specific file extensions

```shell
aws s3 cp s3://bucket/ s3://bucket/ \
  --metadata-directive REPLACE \
  --cache-control max-age=86400 \
  --exclude "*" \
  --include "*.jpg" \
  --include "*.gif" \ 
  --include "*.png" \
  --recursive 
```

## Setting cache control for websites served by AWS CloudFront

CloudFront is a CDN service provided by AWS. The `max-age` directive sets the **browser** caching age in seconds while another directive named `s-maxage` sets the **CloudFront** caching in seconds.

Choosing from the examples above, add `s-maxage=86400` to the `--cache-control` flag for _all_ objects in a bucket.

```shell
aws s3 cp s3://bucket/ s3://bucket/ \
  --metadata-directive REPLACE \
  --cache-control max-age=86400,s-maxage=86400 \
  --recursive
```

## Setting cache control using `aws s3 sync`

**Warning**: Using this option only sets cache headers upon initial sync. The cp command will need to be used to replace headers on existing S3 objects.

```shell
aws s3 sync /path s3://bucket/ \
  --cache-control max-age=86400,s-maxage=86400
```