---
author: Thomas Taylor
categories:
- cloud
date: 2023-02-12 14:30:00-04:00
description: How to invalidate or clear all CloudFront cache and files using the AWS
  CLI
tags:
- aws
- aws-cli
title: Clear all CloudFront cache and files using AWS CLI
---

How to invalidate all files or clear all cache for CloudFront using the AWS CLI?

## Finding the distribution id

If the distribution id is unknown, issue the following command to list all distribution ids:

```shell
aws cloudfront list-distributions --query "DistributionList.Items[*].Id"
```

## Clear or Invalidate all cache for CoudFront

To invalidate all paths, run the `create-invalidation` command with a wildcard path `/*`.

```shell
aws cloudfront create-invalidation --distribution-id CF_DISTRIBUTION_ID --paths "/*"
```

```json
{
    "Location": "https://cloudfront.amazonaws.com/2020-05-31/distribution/CF_DISTRIBUTION_ID/invalidation/I3SD80NE98KDJA",
    "Invalidation": {
        "Id": "I3SD80NE98KDJA",
        "Status": "InProgress",
        "CreateTime": "2023-02-12T19:20:31.982000+00:00",
        "InvalidationBatch": {
            "Paths": {
                "Quantity": 1,
                "Items": [
                    "/*"
                ]
            },
            "CallerReference": "cli-1676229631-287576"
        }
    }
}
```

## Clear specific files from Cache

If one or more files need invalidation, but not the entire distribution, simply execute the following command:

```shell
aws cloudfront create-invalidation --distribution-id CF_DISTRIBUTION_ID \
    --paths "/path/of/file" "/path/to/other/file" "/path/to/folder/*"
```

Notice the wildcard for `/path/to/folder/*`. This allows any files under `/path/to/folder/` to be invalidated with the request.

## Check progress on validation

To check the progress on an invalidation request, issue the follow command:

```shell
aws cloudfront get-invalidation --id INVALIDATION_ID --distribution-id CF_DISTRIBUTION_ID
```

```json
{
    "Invalidation": {
        "Id": "I3SD80NE98KDJA",
        "Status": "Completed",
        "CreateTime": "2023-02-12T19:20:31.982000+00:00",
        "InvalidationBatch": {
            "Paths": {
                "Quantity": 1,
                "Items": [
                    "/*"
                ]
            },
            "CallerReference": "cli-1676229631-287576"
        }
    }
}
```