Title: How to upgrade the AWS CDK CLI
Date: 2021-08-28 1:10
Category: AWS
Tags: AWS CDK
Authors: Thomas Taylor
Description: Upgrading the AWS CDK CLI is simple - use node or yarn.

AWS CDK CLI users are commonly faced with an error:

```
This CDK CLI is no compatible with the CDK library used by your application. Please upgrade the CLI to the latest version
```

Luckily, there are two easy methods for resolving that involve a single command.

# NPM

`npm install -g aws-cdk@latest`

# Yarn

`yarn global upgrade aws-cdk`