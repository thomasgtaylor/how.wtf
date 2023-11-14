---
author: Thomas Taylor
categories:
- os
date: 2023-05-16 22:35:00-04:00
description: How to make AWS Signature V4 requests with curl
tags:
- linux
title: AWS SigV4 requests with curl
---

Curl handles AWS Signature Version 4 API requests natively.

## How to create AWS Signature Version 4 requests using `curl`

If an API Gateway is configured to use AWS IAM authorization, `curl` provides a seamless integration for HTTP requests.

```shell
curl "$url" \
	--user "$AWS_ACCESS_KEY_ID":"$AWS_SECRET_ACCESS_KEY" \
	--aws-sigv4 "aws:amz:us-east-1:execute-api"
```

In the example, the `$url` links to a custom domain that points to an API Gateway.

The [`--user` argument](https://curl.se/docs/manpage.html#-u) is given the `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` that links to the AWS IAM user.

The AWS service for invoking an API Gateway is `execute-api`. For `curl`, the full provider string is required:

```
--aws-sigv4 "aws:amz:region:service"
```