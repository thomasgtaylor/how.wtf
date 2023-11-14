---
author: Thomas Taylor
categories:
- cloud
date: 2023-03-22 00:25:00-04:00
description: How to filter S3 list-objects results by pattern
tags:
- aws
- aws-cli
title: Filter S3 files in bucket by pattern using AWS CLI
---

Filtering S3 files using a pattern, or finding all files in an S3 bucket that contain a substring can be completed using the AWS CLI.

## Filter by S3 object prefix

If the S3 object prefix is predictable, a quick solution is using the native `--prefix` argument.

```shell
aws s3api list-objects-v2 \
	--bucket BUCKET_NAME \
	--prefix PREFIX_STRING
```

Output:

```json
{
	"Contents":[
		{
			"Key":"prefix/",
			"LastModified":"2021-11-22T07:51:03+00:00",
			"ETag":"...",
			"Size":0,
			"StorageClass":"STANDARD"
		},
		{
			"Key":"prefix/example.txt",
			"LastModified":"2021-12-12T17:18:32+00:00",
			"ETag":"...",
			"Size":1646,
			"StorageClass":"STANDARD"
		}
	]
}
```

## Find S3 objects containing keyword/substring

To find all S3 object keys that contain a certain substring, the `--query` argument can be utilized.

```shell
aws s3api list-objects-v2 \
	--bucket BUCKET_NAME \
	--query "Contents[?contains(Key, `SEARCH_PATTERN`)]"
```

Output:

```json
[
	{
		"Key":"name-with-substring",
		"LastModified":"2021-12-12T17:18:32+00:00",
		"ETag":"...",
		"Size":1646,
		"StorageClass":"STANDARD"
	},
	{
		"Key":"another-name-with-substring",
		"LastModified":"2021-11-22T07:52:45+00:00",
		"ETag":"...",
		"Size":1645,
		"StorageClass":"STANDARD"
	}
]
```