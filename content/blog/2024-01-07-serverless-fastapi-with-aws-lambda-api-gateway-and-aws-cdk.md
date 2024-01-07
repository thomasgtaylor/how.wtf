---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-01-07T16:40:00-05:00'
description: 
images:
- images/XGSAmg.webp
tags:
- python
- aws
- aws-cdk
- serverless
title: 'Serverless FastAPI with AWS Lambda, API Gateway, and AWS CDK'
---

![API Gateway, Lambda, and FastAPI logos in a simple architecture image](images/XGSAmg.webp)

By the end of this article, you'll have a Python app deployed with FastAPI using AWS Lambda and API Gateway that is serving requests. In addition, you will have the infrastructure defined in code.

## What is AWS Lambda and API Gateway

[AWS Lambda][2] and [Amazon API Gateway][3] are two services offered by AWS that enable developers to quickly spin up infrastructure without the hassle of provisioning or maintaining servers. In our case, we'll host the FastAPI app in a Lambda function and the API Gateway will route requests to it.

This approach is immediately scalable upon deployment and includes a generous free tier by AWS.

## How to deploy FastAPI with AWS Lambda + API Gateway + AWS CDK

Follow the instructions below to successfully deploy an AWS CDK app that includes a lambda function and API Gateway.

### Create a requirements.txt

Create a `requirements.txt` file with the following information:

```text
aws-cdk-lib==2.118.0
aws-cdk.aws-lambda-python-alpha==2.118.0a0
constructs>=10.0.0,<11.0.0
fastapi==0.108.0
uvicorn==0.25.0
mangum==0.17.0
```

To serve FastAPI locally, [I chose `uvicorn`][4]. This is not mandatory if you do not care about testing locally. To adapt the FastAPI router for API Gateway, we [will use `mangum`][5].

### Install the dependencies

```shell
pip3 install -r requirements.txt
```

### Create /app folder with a main.py file

You can use your preferred file structure. Whether you use this:

```text
project/
├── app
│   ├── __init__.py
│   ├── main.py
│   ├── dependencies.py
│   └── routers
│   │   ├── __init__.py
│   │   ├── items.py
│   │   └── users.py
│   └── internal
│       ├── __init__.py
│       └── admin.py
```

or this

```text
project/
├── app
│   ├── __init__.py
│   └── main.py
```

ensure that there's a `main.py` at the root of the `app` folder.

For the purposes of this tutorial, we'll use a `app/main.py` file to keep it simple for a small todo app:

```
from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()


@app.get("/tasks")
async def get_tasks():
    # database lookup goes here
    return [{"id": "ptvWZ3", "text": "hello!"}, {"id": "cqDUr3", "text": "another!"}]


@app.get("/")
async def root():
    return {"message": "Hello World!"}


handler = Mangum(app, lifespan="off")
```

### Create a stack.py with an API Gateway and a lambda router

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_lambda as lambda_
import aws_cdk.aws_apigateway as apigateway
import aws_cdk.aws_lambda_python_alpha as python


class ApiStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        lambda_function = python.PythonFunction(
            self,
            "Function",
            entry=path.join(path.dirname(__file__), "app"),
            runtime=lambda_.Runtime.PYTHON_3_11,
            index="main.py",
        )

        api = apigateway.LambdaRestApi(self, "API", handler=lambda_function)
```

**NOTE**: We are using a construct that is in alpha. This enables the AWS CDK to use Docker to bundle our Python requirements together.

This seems small, but we are leveraging the power of the AWS CDK and [their L3 constructs][1]. This CDK app will:

1. Bundle python requirements and create a .zip file
2. Create a lambda function with the handler as `main.handler`
3. Create an API Gateway
4. Add a resource path of `{proxy+}` to the API
5. Add an `ANY` method to the resource path that points to the lambda function
6. Enable a "proxy integration" for the lambda function

#### What is an API Gateway proxy integration?

For the FastAPI logic to work appropriately, we need to configure the API Gateway to forward **full** API requests to the lambda function. With this setting, the lambda function's responsibility increases as it must fulfil the requirements of the API Gateway service.

Fortunately, `mangum` takes care of this.

### Create a requirements.txt file for the /app folder

As of time of writing (Jan. 7th, 2024), the python alpha function `entry` folder _must_ have the `requirements.txt` file in it. Create `app/requirements.txt` file with the following:

```text
fastapi==0.108.0
mangum==0.17.0
```

### Create infra.py

Create a file that provisions the CDK app. I named mine `infra.py`.

```python
import aws_cdk as cdk

from stack import ApiStack

app = cdk.App()
ApiStack(app, "ApiStack")

app.synth()
```

### Create cdk.json

Ensure that the entry file matches the one you created before.

```json
{
  "app": "python3 infra.py"
}
```

The directory structure should look like this:

```text
project/
├── app
│   ├── main.py
│   └── requirements.txt
├── cdk.json
├── infra.py
├── requirements.txt
└── stack.py
```

### Deploy the stack

Before deploying, ensure that Docker is running.

```shell
cdk deploy
```

After the stack is deployed, we're given the API endpoint in a stack output:

```text
Outputs:
ApiStack.APIEndpoint1793E782 = https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/
```

### Testing the proxy integration

We'll use `curl` to test our API:

```shell
curl https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/
```

Output:

```json
{"message": "Hello world!"}
```

The `/tasks` endpoint:

```shell
curl https://{api_id}.execute-api.us-east-1.amazonaws.com/prod/tasks
```

Output:

```json
[{"id":"ptvWZ3","text":"hello!"},{"id":"cqDUr3","text":"another!"}]
```

### Testing locally

The top-level `requirements.txt` enables us to test locally with uvicorn:

```shell
uvicorn app.main:app --reload
```

Using `curl`,

```shell
curl http://127.0.0.1:8000/
```

Output:

```json
{"message":"Hello World!"}
```

### Cleaning up

If you wish to destroy your CDK app, feel free to run the following command:

```shell
cdk destroy
```

## Conclusion

After following the prior steps, you will have an understanding of how to deploy a functioning API Gateway and Lambda function powered by FastAPI.

Enjoy building on this example!

[1]: https://docs.aws.amazon.com/cdk/v2/guide/constructs.html#constructs_lib
[2]: https://aws.amazon.com/lambda/
[3]: https://aws.amazon.com/api-gateway/
[4]: https://www.uvicorn.org/
[5]: https://mangum.io/
