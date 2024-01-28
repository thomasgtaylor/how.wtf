---
author: Thomas Taylor
categories:
- cloud
date: '2024-01-14T15:35:00-05:00'
description: An easy step-by-step guide for deploying CloudFormation templates using Rain, an AWS CLI tool for handling CloudFormation deployments.
tags:
- aws
- aws-cli
title: 'A guide for deploying CloudFormation with CLI using Rain'
---

Last year, I [wrote a post][1] describing the difference between `aws cloudformation deploy` and `aws cloudformation create-stack`. I concluded that the easiest method for deploying CloudFormation templates was `cloudformation deploy` since it handled change sets on your behalf.

My opinion has changed; I discovered a [new tool named Rain][2] that is maintained by AWS.

## What is Rain

For folks needing to deploy raw CloudFormation templates, rain is your hero. The tool brings you a lot of power:

1. Allows input parameters
2. Showcases real-time updates for stack deployments
3. Filters deployment logs sensibly
4. Provides the ability to generate CloudFormation templates via AI
5. Manipulates stack sets
6. Formats template files

And [many more features][3]! As a previous user of CloudFormation, this tool appears amazing.

## Installing Rain

There are a few options for installing Rain, but I'll use the `golang` install for this tutorial.

```shell
go install github.com/aws-cloudformation/rain/cmd/rain@latest
```

For MacOS users, `brew` is easy:

```shell
brew install rain
```

The remaining releases are [featured in their GitHub repository][4].

## Build CloudFormation stacks using Rain

The [build command][5] accepts a prompt parameter to generate CloudFormation templates using AI. Let's use it for generating a CloudFormation template with a S3 bucket.

```shell
rain build -p "A s3 bucket that is secure"
```

Output:

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: Create an S3 bucket

Resources:
  MyS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: my-secure-bucket
      AccessControl: Private
      VersioningConfiguration:
        Status: Enabled
```

Although the `AccessControl` [property is a considered legacy][6], it's great that the template was generated on my behalf!

In addition, the `build` property will generate a skeleton for resources as well:

```shell
rain build AWS::Route53::CidrCollection
```

or 

```shell
rain build CidrCollection
```

This outputs a template with all the parameters and dummy `CHANGEME` values for a Route53 CIDR collection:

```yaml
AWSTemplateFormatVersion: "2010-09-09"

Description: Template generated by rain

Resources:
  MyCidrCollection:
    Type: AWS::Route53::CidrCollection
    Properties:
      Locations:
        - CidrList:
            - CHANGEME
          LocationName: CHANGEME
      Name: CHANGEME

Outputs:
  MyCidrCollectionArn:
    Value: !GetAtt MyCidrCollection.Arn

  MyCidrCollectionId:
    Value: !GetAtt MyCidrCollection.Id
```

If you prefer `json`, there's a flag for that:

```shell
rain build CidrCollection --json
```

If you supply the command an ambigious term like "collection", it provides you a warning:

```shell
rain build collection
```

Output:

```text
Ambiguous resource type 'collection'; could be any of:
  AWS::DevOpsGuru::ResourceCollection
  AWS::Location::GeofenceCollection
  AWS::OpenSearchServerless::Collection
  AWS::Rekognition::Collection
  AWS::Route53::CidrCollection
```

## Bootstrap using Rain

Before deploying stacks into an environment, let's run the bootstrap command:

```shell
rain bootstrap
```

Output:

```text
Rain needs to create an S3 bucket called 'rain-artifacts-012345678901-us-east-1'. Continue? (Y/n)
```

This command creates an artifacts bucket that `rain` references when deploying stacks.

It has the following naming convention:

```text
rain-artifacts-{accountId}-{regionName}
```

## Deploying stacks using Rain

In this section, we'll explore deploying templates with `rain`.

### Deploying an S3 bucket

Using the S3 template `rain build` generated, let's deploy it!

This is my current directory structure:

```text
project
└── s3.yml
```

This is the command I'll use to deploy the `s3.yml` with a stack name of `s3-bucket-stack`:

```shell
rain deploy s3.yml s3-bucket-stack
```

If `rain bootstrap` was not executed before deploying, it'll prompt you to do so.

My deployment failed with the following message:

```text
CloudFormation will make the following changes:
Stack s3-bucket-stack:
  + AWS::S3::Bucket MyS3Bucket
Do you wish to continue? (Y/n)
Deploying template 's3.yml' as stack 's3-bucket-stack' in us-east-1.
Stack s3-bucket-stack: ROLLBACK_COMPLETE
Messages:
  - MyS3Bucket: Resource handler returned message: "my-secure-bucket already exists (Service: S3, Status Code: 0, Request ID: null)" (RequestToken: c4a528c1-2fa0-e75e-efb1-5cfacc2aebd6, HandlerErrorCode: AlreadyExists)
failed deploying stack 's3-bucket-stack'
```

Since S3 is a global service, the bucket name `my-secure-bucket` exists in another account or region. I modified the `BucketName` to be `how-wtf-rain-bucket` and issued the same command:

```text
Deleted existing, empty stack.
CloudFormation will make the following changes:
Stack s3-bucket-stack:
  + AWS::S3::Bucket MyS3Bucket
Do you wish to continue? (Y/n)
Deploying template 's3.yml' as stack 's3-bucket-stack' in us-east-1.
Stack s3-bucket-stack: CREATE_COMPLETE
Successfully deployed s3-bucket-stack
```

A couple of awesome things to note:

1. It handled the failure of the stack gracefully _and_ gave me the exact issue
2. I deployed again and it took care of _everything_
3. I did this all without touching the AWS console.

I am impressed by this tool already!

### Deploying a Lambda function

I want to test the `rain pkg` command with lambda artifacts. Like the `cloudformation package` command, we specify a lambda directory _or_ handler and it'll handle zipping and uploading it!

I created a file named `lambda.yml` with the following contents:

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: Create an lambda function

Resources:
  LambdaExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
  MyLambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      Code: lambdafunction/
      FunctionName: MyLovelyFunction
      Handler: index.handler
      Role: !GetAtt LambdaExecutionRole.Arn 
      Runtime: python3.12

Outputs:
  LambdaFunctionArn:
    Description: The ARN of the Lambda function
    Value: !GetAtt MyLambdaFunction.Arn
```

This stack creates two resources:

1. A lambda execution role with basic permissions granted by the `AWSLambdaBasicExecutionRole` policy
2. A lambda function with the `lambdafunction/` contents

And outputs the lambda function arn.

I ran the `fmt` command with the `--verify` flag:

```shell
rain fmt lambda.yml --verify
```

The `--verify` command is best saved for CI environments since it outputs a 0 or 1 depending if the formatting is correct.

Output:

```text
lambda.yml: would reformat
```

I ran it with the `--write` command so that it fixed them:

```shell
rain fmt lambda.yml --write
```

Let's run the `pkg` command with an output file named `out.yml`:

```shell
rain pkg lambda.yml --output out.yml
```

Here is a snapshot of my directory structure after doing the `pkg` command:

```text
project
├── lambda.yml
├── lambdafunction
│   └── index.py
└── out.yml
```

Now let's deploy the `out.yml` template:

```shell
rain deploy out.yml lambda-function-stack
```

Output:

```text
CloudFormation will make the following changes:
Stack lambda-function-stack:
  + AWS::IAM::Role LambdaExecutionRole
  + AWS::Lambda::Function MyLambdaFunction
Do you wish to continue? (Y/n)
Deploying template 'out.yml' as stack 'lambda-function-stack' in us-east-1.
Stack lambda-function-stack: CREATE_COMPLETE
  Outputs:
    LambdaFunctionArn: arn:aws:lambda:us-east-1:012345678901:function:MyLovelyFunction # The ARN of the Lambda function
Successfully deployed lambda-function-stack
```

Using the `LambdaFunctionArn` output, let's invoke the function to ensure everything worked correctly:

```shell
aws lambda invoke --function-name MyLovelyFunction response.txt
```

Here is the resulting `response.txt`:

```text
"Hello world!"
```

## View logs of deployments

Another powerful feature of `rain` is that it can display _sensible_ logs for stack deployments. 

### Using log command

Using the lambda function stack from the prior section, we can inspect the logs using the `log` command:

```shell
rain log lambda-function-stack
```

Output:

```text
No interesting log messages to display. To see everything, use the --all flag
```

Since there were no "interesting" log messages to display, let's see them all!

```shell
rain log lambda-function-stack --all
```

Output:

```text
Jan 14 20:08:52 lambda-function-stack/lambda-function-stack (AWS::CloudFormation::Stack) CREATE_COMPLETE
Jan 14 20:08:50 lambda-function-stack/MyLambdaFunction (AWS::Lambda::Function) CREATE_COMPLETE
Jan 14 20:08:43 lambda-function-stack/MyLambdaFunction (AWS::Lambda::Function) CREATE_IN_PROGRESS "Resource creation Initiated"
Jan 14 20:08:42 lambda-function-stack/MyLambdaFunction (AWS::Lambda::Function) CREATE_IN_PROGRESS
Jan 14 20:08:40 lambda-function-stack/LambdaExecutionRole (AWS::IAM::Role) CREATE_COMPLETE
Jan 14 20:08:24 lambda-function-stack/LambdaExecutionRole (AWS::IAM::Role) CREATE_IN_PROGRESS "Resource creation Initiated"
Jan 14 20:08:22 lambda-function-stack/LambdaExecutionRole (AWS::IAM::Role) CREATE_IN_PROGRESS
Jan 14 20:08:19 lambda-function-stack/lambda-function-stack (AWS::CloudFormation::Stack) CREATE_IN_PROGRESS "User Initiated"
Jan 14 20:08:12 lambda-function-stack/lambda-function-stack (AWS::CloudFormation::Stack) REVIEW_IN_PROGRESS "User Initiated"
```

### Generating Gantt chart for deployment times

Another cool feature is viewing the Gantt chart for the deployment times of different resources:

```
rain log lambda-function-stack --chart > chart.html
```

Here is the resulting html page:

![Gantt chart displaying deployment times for various resources using Rain](images/ubJUKT.webp)

## Destroying stacks using Rain

Using the prior sections' stacks, let's use the `rm` command to showcase the stack deletion process:

```shell
rain rm lambda-function-stack
```

Output:

```text
Stack lambda-function-stack: CREATE_COMPLETE
Are you sure you want to delete this stack? (y/N) y
Successfully deleted stack 'lambda-function-stack'
```

and the S3 bucket stack with the `-y` so that we don't have to confirm again:

```shell
rain rm s3-bucket-stack -y
```

Output:

```text
Successfully deleted stack 's3-bucket-stack'
```

## Other features

There are other features not covered in this guide:

1. Stack sets
2. Forecasting errors using `rain forecast` (experimental)
3. Using rain's instrinsic functions & modules (experimental)

As previously stated, if you need to work with raw CloudFormation - give this tool a try!

[1]: https://how.wtf/cloudformation-create-stack-vs-deploy-in-aws-cli.html
[2]: https://github.com/aws-cloudformation/rain
[3]: https://github.com/aws-cloudformation/rain?tab=readme-ov-file#key-features
[4]: https://github.com/aws-cloudformation/rain/releases
[5]: https://aws-cloudformation.github.io/rain/rain_build.html
[6]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-s3-bucket.html#cfn-s3-bucket-accesscontrol