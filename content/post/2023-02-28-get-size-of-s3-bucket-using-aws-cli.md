---
author: Thomas Taylor
categories:
- cloud
date: 2023-02-28 01:15:00-04:00
description: How to find the size of an Amazon S3 bucket using the AWS CLI
tags:
- aws
- aws-cli
title: Get size of an S3 bucket with AWS CLI
---

Using the AWS CLI, S3 bucket sizes can retrieved.

## Finding the S3 Bucket Size

Use the `s3` list command with the `--summarize` option.

```shell
aws s3 ls --summarize --human-readable --recursive s3://bucket-name/
```

Output:

```text
2023-02-27 00:11:33    5.1 KiB object1name
2023-02-06 00:31:42    5.5 KiB object2name

Total Objects: 2
   Total Size: 10.6 KiB
```

If the output is too noisy, we can retrieve the last 2 lines of the output:

```shell
aws s3 ls --summarize --human-readable --recursive s3://bucket-name/ | tail -2
```

Output:

```text
Total Objects: 2
   Total Size: 10.6 KiB
```