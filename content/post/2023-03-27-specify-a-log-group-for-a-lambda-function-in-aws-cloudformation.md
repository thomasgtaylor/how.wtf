---
title: Specify a log group for a lambda function in AWS CloudFormation
date: 2023-03-27T01:50:00-04:00
author: Thomas Taylor
description: How to specify a log group for a Lambda Function in AWS CloudFormation
categories:
- Cloud
tags:
- AWS

---

By default, lambda functions will create their own log groups if they are given proper permissions.

## Specifying a log group for a Lambda Function

The following CloudFormation template creates two resources:

1. `AWS::IAM::Role`
2. `AWS::Lambda::Function`

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  LambdaExecutionRole:
    Type: 'AWS::IAM::Role'
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
      Policies:
      - PolicyName: logs
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
          - Effect: Allow
            Action:
            - logs:CreateLogGroup
            - logs:CreateLogStream
            - logs:PutLogEvents
            Resource: '*'
  LambdaFunction:
    Type: 'AWS::Lambda::Function'
    Properties:
      FunctionName: 'LambdaTest'
      Handler: index.handler
      Runtime: nodejs18.x
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: |
          exports.handler = async (event) => {
            return 'Hello World!'
          }

```

The  `LambdaTest` function defaults to writing log events to a group named `/aws/lambda/LambdaTest` with a default retention of `Never expire`. To circumvent this behavior, a `AWS::Logs::LogGroup` resource can be explicitly created.

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  LambdaFunctionLogGroup:
      Type: 'AWS::Logs::LogGroup'
      Properties:
        LogGroupName: "/aws/lambda/LambdaTest"
        RetentionInDays: 1
  LambdaFunction:
    Type: 'AWS::Lambda::Function'
    DependsOn: LambdaFunctionLogGroup
    Properties:
      FunctionName: 'LambdaTest'
      Handler: index.handler
      Runtime: nodejs18.x
      Role: !GetAtt LambdaExecutionRole.Arn
      Code:
        ZipFile: |
          exports.handler = async (event) => {
            return 'Hello World!'
          }
  LambdaExecutionRole:
    Type: 'AWS::IAM::Role'
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
      Policies:
      - PolicyName: logs
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
          - Effect: Allow
            Action:
            - logs:CreateLogGroup
            - logs:CreateLogStream
            - logs:PutLogEvents
            Resource: !GetAtt LambdaFunctionLogGroup.Arn

```

A few aspects are different:

1. A new `AWS::Logs::LogGroup` was created with a retention period of 1 day
2. The `LambdaTest` resource uses `DependsOn: LambdaFunctionLogGroup`
3. The `LambdaExecutionRole` only allows writing logs to the `LambdaFunctionLogGroup.Arn` resource

**Warning**: If the log group already exists from a prior deployment, it will need to be deleted.
