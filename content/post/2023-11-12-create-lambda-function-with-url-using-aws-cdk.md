---
title: Create Lambda Function URL using AWS CDK
date: 2023-11-12T01:50:00-05:00
author: Thomas Taylor
description: How to deploy Lambda Functions with Function URLs using the AWS CDK
categories:
- Cloud
- Programming
tags:
- Python
- AWS
- AWS CDK
- Python
- Serverless
---

Deploying Lambda Function URLs with the AWS CDK is simple.

## How to deploy Function URLs using AWS Python CDK

Follow the instructions below to deploy an AWS Lambda Function with a URL.

### Create a requirements.txt

For this tutorial, version 2.106.1 of the AWS CDK was used.

```text
aws-cdk-lib==2.106.1
constructs>=10.0.0,<11.0.0
```

### Install the dependencies

```shell
pip3 install -r requirements.txt
```

### Create /handler folder with index.py

```python
def handler(event, context):
    return {
        "statusCode": 200,
        "body": {"message": "👋"}
    }
```

### Create stack.py with a basic lambda function

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_lambda as lambda_


class FunctionUrlStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        lambda_function = lambda_.Function(
            self,
            "Function",
            runtime=lambda_.Runtime.PYTHON_3_11,
            handler="index.handler",
            code=lambda_.Code.from_asset(path.join(path.dirname(__file__), "handler")),
        )

        function_url = lambda_function.add_function_url(
            auth_type=lambda_.FunctionUrlAuthType.NONE
        )

        cdk.CfnOutput(self, "FunctionUrl", value=function_url.url)
```

### Create app.py

```python
import aws_cdk as cdk

from stack import FunctionUrlStack

app = cdk.App()
FunctionUrlStack(app, "FunctionUrlStack")

app.synth()
```

### Create cdk.json

```json
{
  "app": "python3 app.py"
}
```

The directory structure should look like this:

```text
project/
├── app.py
├── cdk.json
├── handler
│   └── index.py
├── requirements.txt
└── stack.py
```

### Deploy the stack

```shell
cdk deploy
```

Because of the `CfnOutput`, the distribution's domain name is in an output:

```
Outputs:
FunctionUrlStack.FunctionUrl = https://<url>.lambda-url.us-east-1.on.aws/
```

The link will display the following text:

```json
{
    "message": "👋"
}
```
