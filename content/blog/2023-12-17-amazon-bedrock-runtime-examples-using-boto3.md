---
author: Thomas Taylor
categories:
- cloud
- ai
date: 2023-12-17T00:55:00-05:00
description: This article showcases how to use Amazon "bedrock-runtime" with boto3 in Python.
images:
- images/xmzH72.webp
tags:
- aws
- python
title: Amazon Bedrock Runtime examples using boto3
---

![how to invoke amazon bedrock runtime using boto3](images/xmzH72.webp)

Amazon Bedrock is a managed service provided by AWS that provides foundational models at your fingertips through a unified API. The service offers a range of features including foundational model invocations, fine-tuning, agents, guardrails, knowledge base searching, and more!

To read more about the service offerings, refer to its [documentation][1].

## What is Amazon Bedrock Runtime?

For this article, we'll dive into using the Python AWS SDK, `boto3`, to call foundational models. [Amazon Bedrock Runtime][2] is the API entry point for invoking foundational models.

As of time of writing, Dec. 16th 2023, the supported [API actions are][2]:

1. `InvokeModel`
2. `InvokeModelWithResponseStream`

## How to call models using Python boto3

### Installing boto3

Invoking a foundational model using the `InvokeModel` API call is easy in Python! To begin, ensure that you have `boto3` installed:

```shell
pip3 install boto3
```

### How to use the invoke_model method

Let's instantiate the Amazon Bedrock Runtime client using boto3:

```python
import boto3

client = boto3.client("bedrock-runtime")
```

then lookup the inference parameters needed for the `body` [here][3]. For the sake of this example, I'm invoking the Anthropic Claude model. Its inference parameters are:

```json
{
    "prompt": "\n\nHuman:<prompt>\n\nAssistant:",
    "temperature": 0.5,
    "top_p": 1,
    "top_k": 250,
    "max_tokens_to_sample": 200,
    "stop_sequences": ["\n\nHuman:"]
}
```

The bare minimum request for Claude is:

```json
{
    "prompt": "\n\nHuman:<prompt>\n\nAssistant:",
    "max_tokens_to_sample": 200
}
```

The body passed into the client must be a file or bytes. For Claude, the `contentType` as `application/json`.

```python
import json

import boto3

client = boto3.client("bedrock-runtime", region_name="us-east-1")

body = json.dumps(
    {
        "prompt": "\n\nHuman:What is your name?\n\nAssistant:",
        "max_tokens_to_sample": 200,
    }
).encode()

response = client.invoke_model(
    body=body,
    modelId="anthropic.claude-v2",
    accept="application/json",
    contentType="application/json",
)

response_body = json.loads(response["body"].read())
print(response_body)
```

Here is the line-by-line breakdown of the code above:
- Instantiate the `boto3.client("bedrock-runtime")` client with a `region_name` of `us-east-1`.
- `json.dumps` a dictionary of Claude's required inference parameters
- Transform the JSON string into bytes using the `.encode()` method
- Invoke the model by specifying the body (bytes), model id, accept, and contentType parameters.
- Convert the `StreamingBody` to a JSON encoded string using `.read()` then turn the JSON string into a dictionary using `json.loads`

For more information about `StreamingBody`, refer to its documentation [here][4]. To keep it simple, we simply need to use the `read` method on the response body to get its contents.

Output:

```text
{'completion': ' My name is Claude.', 'stop_reason': 'stop_sequence', 'stop': '\n\nHuman:'}
```

The Claude JSON output includes a `completion` attribute with the text.

Here's how to grab that information:

```python
import json

import boto3

client = boto3.client("bedrock-runtime", region_name="us-east-1")

body = json.dumps(
    {
        "prompt": "\n\nHuman:What is your name?\n\nAssistant:",
        "max_tokens_to_sample": 200,
    }
).encode()

response = client.invoke_model(
    body=body,
    modelId="anthropic.claude-v2",
    accept="application/json",
    contentType="application/json",
)

response_body = json.loads(response["body"].read())
completion = response_body["completion"].strip()
print(completion)
```

Output:

```text
My name is Claude.
```

## How to stream models responses using Python boto3

Amazon Bedrock allows streaming LLM responses as well!

### How to use the invoke_model with response stream method

Using the same example from above, let's use the `invoke_model_with_response_stream` method:

```python
import json

import boto3

client = boto3.client("bedrock-runtime", region_name="us-east-1")

body = json.dumps(
    {
        "prompt": "\n\nHuman:Write me a 100 word essay about snickers candy bars\n\nAssistant:",
        "max_tokens_to_sample": 200,
    }
).encode()

response = client.invoke_model_with_response_stream(
    body=body,
    modelId="anthropic.claude-v2",
    accept="application/json",
    contentType="application/json",
)

stream = response["body"]
if stream:
    for event in stream:
        chunk = event.get("chunk")
        if chunk:
            print(json.loads(chunk.get("bytes").decode()))
```

Output:

```text
{'completion': ' Here', 'stop_reason': None, 'stop': None}
{'completion': ' is a 100 word essay', 'stop_reason': None, 'stop': None}
{'completion': ' about Snickers candy', 'stop_reason': None, 'stop': None}
{'completion': ' bars:\n\nS', 'stop_reason': None, 'stop': None}
{'completion': 'nickers is one of', 'stop_reason': None, 'stop': None}
{'completion': ' the most popular candy bars around. Introdu', 'stop_reason': None, 'stop': None}
{'completion': 'ced in 1930, it consists of nougat topped with', 'stop_reason': None, 'stop': None}
{'completion': ' caramel and peanuts that is encased in milk chocolate', 'stop_reason': None, 'stop': None}
{'completion': '. With its sweet and salty taste profile,', 'stop_reason': None, 'stop': None}
{'completion': ' Snickers provides the perfect balance of flavors. The candy', 'stop_reason': None, 'stop': None}
{'completion': " bar got its name from the Mars family's", 'stop_reason': None, 'stop': None}
{'completion': ' favorite horse. Bite', 'stop_reason': None, 'stop': None}
{'completion': ' into a Snickers and the rich', 'stop_reason': None, 'stop': None}
{'completion': ' chocolate and caramel intermingle in your mouth while the', 'stop_reason': None, 'stop': None}
{'completion': ' crunch of peanuts adds text', 'stop_reason': None, 'stop': None}
{'completion': 'ural contrast. Loaded with sugar, Snick', 'stop_reason': None, 'stop': None}
{'completion': 'ers gives you a quick burst of energy. It', 'stop_reason': None, 'stop': None}
{'completion': "'s a classic candy bar that has endured for", 'stop_reason': None, 'stop': None}
{'completion': ' decades thanks to its irresistible combination', 'stop_reason': None, 'stop': None}
{'completion': ' of chocolate,', 'stop_reason': None, 'stop': None}
{'completion': ' caramel, noug', 'stop_reason': None, 'stop': None}
{'completion': "at and peanuts. Snickers' popularity shows", 'stop_reason': None, 'stop': None}
{'completion': ' no signs of waning anytime soon.', 'stop_reason': 'stop_sequence', 'stop': '\n\nHuman:', 'amazon-bedrock-invocationMetrics': {'inputTokenCount': 21, 'outputTokenCount': 184, 'invocationLatency': 8756, 'firstByteLatency': 383}}
```

Instead of returning a `StreamingBody` like before, the `response["body"]` is an [`EventStream`][5] that can be iterated over in chunks.

[1]: https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html
[2]: https://docs.aws.amazon.com/bedrock/latest/APIReference/API_Operations_Amazon_Bedrock_Runtime.html
[3]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html
[4]: https://botocore.amazonaws.com/v1/documentation/api/latest/reference/response.html#botocore.response.StreamingBody.read
[5]: https://botocore.amazonaws.com/v1/documentation/api/latest/reference/eventstream.html
