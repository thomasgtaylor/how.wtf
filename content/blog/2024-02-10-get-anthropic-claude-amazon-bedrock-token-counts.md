---
author: Thomas Taylor
categories:
- ai
- programming
date: 2024-02-10T01:10:00-05:00
description: This post showcases how to get the Anthropic Claude Amazon Bedrock token input and output counts.
tags:
- generative-ai
- python 
title: "Get Anthropic Claude Amazon Bedrock token counts"
---

Last year, I wrote a post showcasing how to [tokenize words using the Anthropic SDK][1] to track token usage. 

While this method continues to work, it's not necessary since the Amazon Bedrock team added token metrics to the SDK response metadata.

In this guide, we'll explore the SDK and how to get those token counts.

## Install the AWS SDK

To begin, install `boto3`, the AWS SDK for Python, using `pip`:

```shell
pip install boto3
```

## List model access

The [`invoke_model` call requires a model id][2]. To determine which models are accessible in your AWS account, run the following command using the `aws` cli:

```shell
aws bedrock list-foundation-models \
    --by-provider anthropic \
    --query "modelSummaries[*].modelId"
```

Output:

```json
[
    "anthropic.claude-instant-v1:2:100k",
    "anthropic.claude-instant-v1",
    "anthropic.claude-v1",
    "anthropic.claude-v2:0:18k",
    "anthropic.claude-v2:0:100k",
    "anthropic.claude-v2:1:18k",
    "anthropic.claude-v2:1:200k",
    "anthropic.claude-v2:1",
    "anthropic.claude-v2"
]
```

## Call Claude using Bedrock client

The AWS SDK [provides a `bedrock-runtime` client with an `invoke_model` function][2]. We'll use this and [the Claude inference parameters documentation][3] to invoke it.

```python
import boto3
import json

bedrock = boto3.client("bedrock-runtime")

params = {
    "prompt": "\n\nHuman: Who are you?\n\nAssistant:",
    "max_tokens_to_sample": 200,
}

response = bedrock.invoke_model(
    body=json.dumps(params).encode(),
    modelId="anthropic.claude-instant-v1"
)

print(response)
```

Here's the output pretty-printed in `json` format:

```json
{
  "ResponseMetadata": {
    "RequestId": "d72967be-90c2-4118-951e-a555455d5d7a",
    "HTTPStatusCode": 200,
    "HTTPHeaders": {
      "date": "Sat, 10 Feb 2024 05:55:23 GMT",
      "content-type": "application/json",
      "content-length": "117",
      "connection": "keep-alive",
      "x-amzn-requestid": "d72967be-90c2-4118-951e-a555455d5d7a",
      "x-amzn-bedrock-invocation-latency": "430",
      "x-amzn-bedrock-output-token-count": "17",
      "x-amzn-bedrock-input-token-count": "13"
    },
    "RetryAttempts": 0
  },
  "contentType": "application/json",
  "body": "..."
}
```

Notice the information it provides us in the `ResponseMetadata.HTTPHeaders`?

## Count the Anthropic Claude token input and output

We can modify the code snippet above to reveal the model's output and token usage:

```python
import boto3
import json

bedrock = boto3.client("bedrock-runtime")

params = {
    "prompt": "\n\nHuman: Who are you?\n\nAssistant:",
    "max_tokens_to_sample": 200,
}

response = bedrock.invoke_model(
    body=json.dumps(params).encode(), modelId="anthropic.claude-instant-v1"
)

body = response["body"].read()
data = json.loads(body)
completion = data.get("completion")

input_token_count = response["ResponseMetadata"]["HTTPHeaders"][
    "x-amzn-bedrock-input-token-count"
]

output_token_count = response["ResponseMetadata"]["HTTPHeaders"][
    "x-amzn-bedrock-output-token-count"
]

print(completion, input_token_count, output_token_count, sep="\n")
```

Output:

```text
 My name is Claude. I'm an AI assistant created by Anthropic.
13
20
```

That was easy!

[1]: https://how.wtf/how-to-count-amazon-bedrock-claude-tokens-step-by-step-guide.html
[2]: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/bedrock-runtime/client/invoke_model.html
[3]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-claude.html
