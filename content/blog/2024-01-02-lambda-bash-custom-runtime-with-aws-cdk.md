---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-01-02T11:25:00-05:00'
description: 
images:
- images/4PS3Zk.png 
tags:
- aws
- aws-cdk
- serverless
- bash
- python
title: 'Lambda Bash custom runtime with AWS CDK'
---

![A bald character looking at the Bash logo for deploying custom runtimes with AWS CDK](images/4PS3Zk.png)

For this post, I will extend the [AWS documentation for 'Building a custom runtime'][1] by additionally using the AWS CDK in Python to deploy the Bash custom runtime for AWS Lambda.

## How to deploy a Lambda custom runtime using AWS CDK

Follow the instructions below to deploy an AWS Lambda Function with a Bash custom runtime!

### Create a /handler folder with a bootstrap file 

AWS provides a `bootstrap` file that creates the custom runtime. Here is that script:

```shell
#!/bin/sh

set -euo pipefail

# Initialization - load function handler
source $LAMBDA_TASK_ROOT/"$(echo $_HANDLER | cut -d. -f1).sh"

# Processing
while true
do
  HEADERS="$(mktemp)"
  # Get an event. The HTTP request will block until one is received
  EVENT_DATA=$(curl -sS -LD "$HEADERS" "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next")

  # Extract request ID by scraping response headers received above
  REQUEST_ID=$(grep -Fi Lambda-Runtime-Aws-Request-Id "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)

  # Run the handler function from the script
  RESPONSE=$($(echo "$_HANDLER" | cut -d. -f2) "$EVENT_DATA")

  # Send the response
  curl "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response"  -d "$RESPONSE"
done
```

The tutorial explains what this script does in-depth, but here's the summary:

1. Initializes by loading the handler file provided by the lambda
2. Grabs the event data from the invocation event
3. Grabs the request id from the invocation header
4. Runs the handler, then passes the response to the lambda runtime API

For more information about the runtime process, check out the AWS documentation [here][2] that describes the process and the API.

I created a folder named `/handler` and added the `bootstrap` file into it.

### Create a requirements.txt

For this tutorial, version 2.117.0 of the AWS CDK was used.

```text
aws-cdk-lib==2.117.0
constructs>=10.0.0,<11.0.0
```

### Install the dependencies

```shell
pip3 install -r requirements.txt
```

### Add index.sh file to /handler directory

```shell
handler() {
  EVENT_DATA=$1
  echo "$EVENT_DATA" 1>&2;
  RESPONSE="Echoing request: '$EVENT_DATA'"
  echo $RESPONSE
}
```

### Create stack.py with the lambda function

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_lambda as lambda_


class BashFunctionStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        lambda_function = lambda_.Function(
            self,
            "Function",
            runtime=lambda_.Runtime.PROVIDED_AL2023,
            handler="index.handler",
            code=lambda_.Code.from_asset(path.join(path.dirname(__file__), "handler")),
        )

        cdk.CfnOutput(self, "FunctionName", value=lambda_function.function_name)
```

### Create app.py

```python
import aws_cdk as cdk

from stack import BashFunctionStack

app = cdk.App()
BashFunctionStack(app, "BashFunctionStack")

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
│   ├── bootstrap
│   └── index.sh
├── requirements.txt
└── stack.py
```

### Deploy the stack

```shell
cdk deploy
```

Because of the `CfnOutput`, the function name is an output:

```text
Outputs:
BashFunctionStack.FunctionName = BashFunctionStack-Function76856677-TiMb7dPSe1lE
```

### Invoke the function

If everything worked correctly, we can invoke the function using the AWS CLI:

```shell
aws lambda invoke response.txt \
    --function-name FUNCTION_NAME \
    --payload '{"text":"Hello"}' \
    --cli-binary-format raw-in-base64-out
```

and receive the following output:

```json
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

with a `response.txt` of:

```text
Echoing request: '{"text":"Hello"}'
```

[1]: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-walkthrough.html
[2]: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
