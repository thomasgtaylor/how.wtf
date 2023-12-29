---
author: Thomas Taylor
categories:
- cloud
date: 2023-02-13 00:20:00-04:00
description: How to create a new IAM user with the AWS CLI
tags:
- aws
- aws-cli
title: Adding a new IAM User using the AWS CLI
---

How to create a new IAM user with the AWS CLI?

## Create a new IAM User

To create a new IAM user, issue the following command:

```shell
aws iam create-user --user-name USER
```

```json
{
    "User": {
        "Path": "/",
        "UserName": "USER",
        "UserId": "AIDA...",
        "Arn": "arn:aws:iam::123456789012:user/USER",
        "CreateDate": "2023-02-13T05:03:54+00:00"
    }
}
```

## Add IAM User to an IAM Group

### Create IAM Group

If an IAM Group does not exist, create one.

```shell
aws iam create-group --group-name GROUP
```

```json
{
    "Group": {
        "Path": "/",
        "GroupName": "GROUP",
        "GroupId": "AGPA...",
        "Arn": "arn:aws:iam::123456789012:group/GROUP",
        "CreateDate": "2023-02-13T05:05:45+00:00"
    }
}
```

### Grant access to IAM Group

The managed policy arn `arn:aws:iam::aws:policy/PowerUserAccess` is attached to the group in this example.

```shell
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/PowerUserAccess --group-name GROUP
```

### Add the user to the IAM group.

```shell
aws iam add-user-to-group --user-name USER --group-name GROUP
```

### Verify user is added to group

```shell
aws iam get-group --group-name GROUP --query "Users[*].{name:UserName,id:UserId}"
```

```json
[
    {
        "name": "USER",
        "id": "AIDA..."
    }
]
```

## Grant AWS Console Access

```shell
aws iam create-login-profile --user-name USER --password PASSWORD --no-password-reset-required
```

```json
{
    "LoginProfile": {
        "UserName": "USER",
        "CreateDate": "2023-02-13T05:10:17+00:00",
        "PasswordResetRequired": false
    }
}
```

## Grant Programmatic Access

```shell
aws iam create-access-key --user-name USER
```

```json
{
    "AccessKey": {
        "UserName": "USER",
        "AccessKeyId": "AKIA...",
        "Status": "Active",
        "SecretAccessKey": "UU...",
        "CreateDate": "2023-02-13T05:11:18+00:00"
    }
}
```