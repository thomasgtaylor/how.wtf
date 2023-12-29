---
author: Thomas Taylor
categories:
- cloud
- programming
- ai
date: 2023-12-20T02:30:00-05:00
description: How to invoke Amazon Bedrock models using Step Functions with the AWS CDK
images:
- images/nauk58.png
tags:
- aws
- aws-cdk
- python
- serverless
- generative-ai
title: Invoke Amazon Bedrock models from Step Functions with AWS CDK
---

![invoke Amazon bedrock models directly from Step Function statemachines](images/nauk58.png)

AWS released an [optimized integration][1] for Amazon Bedrock. It allows StepFunction statemachines to directly call the Amazon Bedrock API without needing to write a Lambda function.

## How to deploy a StepFunction with Amazon Bedrock integration using AWS CDK

Follow the instructions below to deploy a StepFunction with Amazon Bedrock integration using the AWS CDK. The following tutorial uses Python, but the same principles can be used with any language.

### Create a requirements.txt

For this tutorial, version 2.115.0 of the AWS CDK was used.

```text
aws-cdk-lib==2.115.0
constructs>=10.0.0,<11.0.0
```

### Install the dependencies

```shell
pip3 install -r requirements.txt
```

### Create stack.py with the step function and bedrock task

For this tutorial, I opted to use the Claude V1 instant model. If you're unsure where the `sfn.TaskInput.from_object()` parameters originate from, please review my [article describing how to invoke Bedrock models directly][2].

```python
from aws_cdk import (
    App,
    CfnOutput,
    Stack,
    aws_stepfunctions as sfn,
    aws_stepfunctions_tasks as tasks,
    aws_bedrock as bedrock,
)


class StepFunctionBedrockStack(Stack):
    def __init__(self, scope: App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        model = bedrock.FoundationModel.from_foundation_model_id(
            self, "Model", bedrock.FoundationModelIdentifier.ANTHROPIC_CLAUDE_INSTANT_V1
        )
        invoke_model_task = tasks.BedrockInvokeModel(
            self,
            "InvokeModel",
            model=model,
            body=sfn.TaskInput.from_object(
                {
                    "prompt": "\n\nHuman:Give me a cowboy joke\n\nAssistant:",
                    "max_tokens_to_sample": 256,
                }
            ),
            result_selector={"joke": sfn.JsonPath.string_at("$.Body.completion")},
        )
        state_machine = sfn.StateMachine(
            self,
            "StateMachine",
            definition_body=sfn.DefinitionBody.from_chainable(invoke_model_task),
        )

        CfnOutput(self, "StateMachineArn", value=state_machine.state_machine_arn)
```

The code above creates a `BedrockInvokeModel` task with a `body` that's specific for Anthropic Claude's input and a `result_selector` that extracts the `completion`.

### Create app.py

```python
import aws_cdk as cdk

from stack import StepFunctionBedrockStack

app = cdk.App()
StepFunctionBedrockStack(app, "StepFunctionBedrockStack")

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
├── requirements.txt
└── stack.py
```

### Deploy the stack

```shell
cdk deploy
```

Because of the `CfnOutput`, the statemachine's arn is in an output:

```text
Outputs:
StepFunctionBedrockStack.StateMachineArn = arn:aws:states:us-east-1:0123456789101:stateMachine:StateMachine2E01A3A5-GeJycj800pUN
```

### Start a statemachine execution

With the statemachine name, we can start an execution using the AWS CLI:

```shell
aws stepfunctions start-execution  \
    --state-machine-arn <statemachine arn here>
```

Output:

```json
{
    "executionArn": "arn:aws:states:us-east-1:0123456789101:execution:StateMachine2E01A3A5-GeJycj800pUN:387b0976-feb6-4c8c-9abe-af427546df3c",
    "startDate": "2023-12-20T01:48:56.396000-05:00"
}
```

then, we can describe the execution using the execution arn:

```shell
aws stepfunctions describe-execution \
    --execution-arn <execution arn here>
```

Output:

```json
{
    "executionArn": "arn:aws:states:us-east-1:0123456789101:execution:StateMachine2E01A3A5-GeJycj800pUN:387b0976-feb6-4c8c-9abe-af427546df3c",
    "stateMachineArn": "arn:aws:states:us-east-1:0123456789101:stateMachine:StateMachine2E01A3A5-GeJycj800pUN",
    "name": "387b0976-feb6-4c8c-9abe-af427546df3c",
    "status": "SUCCEEDED",
    "startDate": "2023-12-20T01:48:56.396000-05:00",
    "stopDate": "2023-12-20T01:48:57.814000-05:00",
    "input": "{}",
    "inputDetails": {
        "included": true
    },
    "output": "{\"joke\":\" Here's one: Why don't seagulls fly over the bay? Because then they'd be bagels!\"}",
    "outputDetails": {
        "included": true
    },
    "redriveCount": 0,
    "redriveStatus": "NOT_REDRIVABLE",
    "redriveStatusReason": "Execution is SUCCEEDED and cannot be redriven"
}
```

### Pass information from the statemachine input to Bedrock

If you want to pass the input to the foundational model, you can do this using a combination of:

`sfn.JsonPatch.string_at()` and `States.Format` intrinsic function

```python
from aws_cdk import (
    App,
    CfnOutput,
    Stack,
    aws_stepfunctions as sfn,
    aws_stepfunctions_tasks as tasks,
    aws_bedrock as bedrock,
)


class StepFunctionBedrockStack(Stack):
    def __init__(self, scope: App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        model = bedrock.FoundationModel.from_foundation_model_id(
            self, "Model", bedrock.FoundationModelIdentifier.ANTHROPIC_CLAUDE_INSTANT_V1
        )
        invoke_model_task = tasks.BedrockInvokeModel(
            self,
            "InvokeModel",
            model=model,
            body=sfn.TaskInput.from_object(
                {
                    "prompt": sfn.JsonPath.string_at(
                        "States.Format('\n\nHuman:{}\n\nAssistant:', $$.Execution.Input.prompt)"
                    ),
                    "max_tokens_to_sample": 256,
                }
            ),
            result_selector={"joke": sfn.JsonPath.string_at("$.Body.completion")},
        )
        state_machine = sfn.StateMachine(
            self,
            "StateMachine",
            definition_body=sfn.DefinitionBody.from_chainable(invoke_model_task),
        )

        CfnOutput(self, "StateMachineArn", value=state_machine.state_machine_arn)
```

Now we can start the statemachine execution with a prompt:

```shell
aws stepfunctions start-execution  \
    --state-machine-arn <statemachine arn here> \
    --input '{"prompt": "Write me a joke"}'
```

[1]: https://aws.amazon.com/about-aws/whats-new/2023/11/aws-step-functions-optimized-integration-bedrock/
[2]: https://how.wtf/amazon-bedrock-runtime-examples-using-boto3.html
