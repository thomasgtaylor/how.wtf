---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-01-05T03:05:00-05:00'
description: This article explains how to create a serverless API using Powertools for AWS Lambda and the AWS CDK
images:
- images/hwruz7.webp 
tags:
- python
- aws
- aws-cdk
- serverless
title: 'Creating a serverless API using AWS Lambda Powertools and CDK'
---

![API Gateway and Lambda Logo architecture image](images/hwruz7.webp)

Amazon API Gateway + AWS Lambda is a powerful duo for creating easy-to-deploy scalable infrastructure that is immediately accessible by thousands of users. For this post, we will create an API Gateway with an lambda proxy integration using the AWS Lambda Powertools library and the AWS CDK.

In just a few lines of code, we'll have our API deployed and ready to go! This tutorial assumes you know what the Amazon API Gateway and AWS Lambda services are.

## What is AWS Lambda Powertools

[AWS Lambda Powertools][3] is an SDK released by Amazon that aims to increase developer productiviy by bundling similar functionality together:

1. Tracing
2. Logging
3. Event handling
4. Typing / Validation
5. Middleware

and more!

With this SDK, we'll build a single lambda integration that will handle all the routes of our API Gateway.

If you've used Flask, Spring Boot, express, etc., this following code snippet should look familiar:

```python
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools.utilities.data_classes import event_source
from aws_lambda_powertools.utilities.data_classes.api_gateway_authorizer_event import (
    APIGatewayAuthorizerRequestEvent,
)

tracer = Tracer()
logger = Logger()
app = APIGatewayRestResolver()


@app.get("/pets")
@tracer.capture_method
def get_pets():
    return {"pets": []}


@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
@tracer.capture_lambda_handler
@event_source(data_class=APIGatewayAuthorizerRequestEvent)
def lambda_handler(
    event: APIGatewayAuthorizerRequestEvent, context: LambdaContext
) -> dict:
    return app.resolve(event.raw_event, context)
```

The `APIGatewayRestResolver` behaves like a router. The `lambda_handler` processes the API Gateway event then `resolve`s the route using the information that was passed from the lambda context. We'll reference this example when creating our own.

## How to deploy an API Gateway with Proxy Lambda with Powertools

Follow the instructions below to deploy a Lambda Function with Powertools bundled for an API Gateway proxy integration.

### Create a requirements.txt

For this tutorial, version 2.118.0 of the AWS CDK was used.

```text
aws-cdk-lib==2.118.0
constructs>=10.0.0,<11.0.0
```

### Install the dependencies

```shell
pip3 install -r requirements.txt
```

### Create /handler folder with an index.py file

```python
import json


def handler(event, context):
    return {"statusCode": 200, "body": json.dumps({"message": "Hello world!"})}
```

### Create stack.py with an API Gateway and a lambda router

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_lambda as lambda_
import aws_cdk.aws_apigateway as apigateway


class ApiStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        lambda_function = lambda_.Function(
            self,
            "Function",
            runtime=lambda_.Runtime.PYTHON_3_11,
            handler="index.handler",
            code=lambda_.Code.from_asset(path.join(path.dirname(__file__), "handler")),
        )

        api = apigateway.LambdaRestApi(self, "API", handler=lambda_function)
```

The AWS CDK [provides "L3" constructs][4]; constructs that abstract away configuration we otherwise explicitly need define. In the case above, the [L3 construct named `LambdaRestApi`][5] handles a few things:

1. API Gateway creation
2. Lambda handler configuration
3. Resource path `{proxy+}` creation
4. `ANY` method creation

### Create app.py

```python
import aws_cdk as cdk

from stack import ApiStack

app = cdk.App()
ApiStack(app, "ApiStack")

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

After the stack is deployed, we're given the API endpoint in a stack output:

```text
Outputs:
ApiStack.APIEndpoint1793E782 = https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/
```

### Testing the proxy integration

At this point, we can send any HTTP request and always get back the same response:

```shell
curl https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/
```

Output:

```json
{"message": "Hello world!"}
```

### Add Lambda Powertools lambda layer using AWS CDK + SAR

Rather than write our own routing function based on the API Gateway event, let's use AWS Lambda Powertools.

I have two preferred options for adding the Lambda Powertools layer:

1. Using the [AWS lambda layer construct provided by AWS][6] (requires Docker)
2. Explicitly using the AWS managed layer

For the purposes of this tutorial, I'll [reference the lambda layer using the serverless application respository][7].

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_lambda as lambda_
import aws_cdk.aws_apigateway as apigateway
import aws_cdk.aws_sam as sam

POWERTOOLS_BASE_NAME = "AWSLambdaPowertools"
POWERTOOLS_VERSION = "2.30.2"
POWERTOOLS_ARN = "arn:aws:serverlessrepo:eu-west-1:057560766410:applications/aws-lambda-powertools-python-layer"


class ApiStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        powertools_app = sam.CfnApplication(
            self,
            f"{POWERTOOLS_BASE_NAME}Application",
            location={
                "applicationId": POWERTOOLS_ARN,
                "semanticVersion": POWERTOOLS_VERSION,
            },
        )

        powertools_layer_arn = powertools_app.get_att(
            "Outputs.LayerVersionArn"
        ).to_string()

        powertools_layer_version = lambda_.LayerVersion.from_layer_version_arn(
            self, f"{POWERTOOLS_BASE_NAME}", powertools_layer_arn
        )

        lambda_function = lambda_.Function(
            self,
            "Function",
            runtime=lambda_.Runtime.PYTHON_3_11,
            handler="index.handler",
            code=lambda_.Code.from_asset(path.join(path.dirname(__file__), "handler")),
            layers=[powertools_layer_version],
        )

        api = apigateway.LambdaRestApi(self, "API", handler=lambda_function)
```

### Using AWS Lambda Powertools

Now that the lambda is successfully configured for AWS Lambda Powertools, let's experiment using a small todo app:

```python
from aws_lambda_powertools import Logger, Tracer
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.utilities.typing import LambdaContext

tracer = Tracer()
logger = Logger()
app = APIGatewayRestResolver()


@app.get("/tasks")
@tracer.capture_method
def get_tasks():
    # database lookup goes here
    return [{"id": "ptvWZ3", "text": "hello!"}, {"id": "cqDUr3", "text": "another!"}]


@logger.inject_lambda_context(correlation_id_path=correlation_paths.API_GATEWAY_REST)
@tracer.capture_lambda_handler
def handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
```

Now we can test the different routes:

```shell
curl https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/
```

Output:

```json
{"statusCode":404,"message":"Not found"}
```

and the real `/tasks` endpoint:

```shell
curl https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/tasks
```

Output:

```json
[{"id":"ptvWZ3","text":"hello!"},{"id":"cqDUr3","text":"another!"}]
```

## Conclusion

At this point, you will have a functioning AWS CDK application with an API Gateway Lambda Proxy integration setup! While the `/tasks` code is rudimentary, it provides the foundation for expansion for your own API!

Happy building!

[1]: https://aws.amazon.com/api-gateway/
[2]: https://aws.amazon.com/lambda/
[3]: https://docs.powertools.aws.dev/lambda/python/latest/
[4]: https://docs.aws.amazon.com/cdk/v2/guide/constructs.html#constructs_lib
[5]: https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_apigateway/LambdaRestApi.html
[6]: https://github.com/aws-powertools/powertools-lambda-layer-cdk
[7]: https://docs.powertools.aws.dev/lambda/python/latest/#sar
