---
author: Thomas Taylor
categories:
- cloud
date: 2023-02-18 02:30:00-04:00
description: What is the difference between CloudFormation create stack and deployand when to use them?
tags:
- aws
- aws-cli
title: CloudFormation create stack vs deploy in AWS CLI
---

CloudFormation provides two options for deploying templates using the AWS CLI:

1. `aws cloudformation create-stack`
2. `aws cloudformation deploy`

What are the differences between the two?

## `create-stack`

Create stack is a specific API action for creating AWS CloudFormation stacks.

```shell
aws cloudformation create-stack \
    --stack-name STACK_NAME \
    --template-body file://path/to/file.json
```

## `deploy`

Deploy is an abstraction for managing AWS CloudFormation stacks and _change sets_. The [list of API actions available](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_Operations.html) for CloudFormation does _not_ include `deploy`.

Unlike `create-stack`, which is a direct API call, `deploy` combines `create-change-set` and `execute-change-set` in a single convenient command.

The following command will either create a new stack if one does not exist, or create a change set and execute the change set to update an existing stack.

```shell
aws cloudformation deploy \
    --stack-name STACK_NAME \
    --template-body file://path/to/file.json
```

If the author wants to review the change set before automatically applying, the flag `--no-execute-changeset` can be used:

```shell
aws cloudformation deploy \
    --stack-name STACK_NAME \
    --template-body file://path/to/file.json \
    --no-execute-changeset
```

## Should I use `create-stack` or `deploy`?

In general, `aws cloudformation deploy` will be easiest to use. It automatically handles creating or updating change sets on the user's behalf.