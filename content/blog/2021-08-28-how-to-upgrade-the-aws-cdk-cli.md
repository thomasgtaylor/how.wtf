---
author: Thomas Taylor
categories:
- cloud
date: 2021-08-28 01:10:00-04:00
description: Upgrading the AWS CDK CLI is simple - use node or yarn.
tags:
- aws
- aws-cdk
title: How to upgrade the AWS CDK CLI
---

AWS CDK CLI users are commonly faced with an error:

```
This CDK CLI is no compatible with the CDK library used by your application. Please upgrade the CLI to the latest version
```

Luckily, there are two easy methods for resolving that involve a single command.

## NPM

`npm install -g aws-cdk@latest`

## Yarn

`yarn global upgrade aws-cdk`