---
title: How to view or tail AWS logs in real time
date: 2023-02-17T00:10:00-04:00
author: Thomas Taylor
description: How to view AWS logs in real time (like tail -f in linux)
categories:
- Cloud
tags:
- AWS
- AWS CLI
---

Since mid-2019, the AWS CLI natively supports real time viewing of aws logs.

## View latest logs using `--since`

View the latest 365 days worth of logs:

```shell
aws logs tail $GROUP --since 365d
```

View the latest 52 weeks worth of logs:

```shell
aws logs tail $GROUP --since 52w
```

View other supported units [here](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/logs/tail.html).

## Real time follow logs using `--follow`

Continuously poll for new logs using `--follow`:

```shell
aws logs tail $GROUP --follow
```

## Other options with `aws logs tail`

For other supported options with `aws logs tail`, view the full reference [here](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/logs/tail.html).
