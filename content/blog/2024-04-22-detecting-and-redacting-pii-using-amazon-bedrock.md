---
author: Thomas Taylor
categories:
- ai
- programming
date: '2024-04-23T00:25:00-04:00'
description: How to detect and redact PII using Amazon Bedrock and Claude 3
tags:
- generative-ai
- python
title: 'Detecting and redacting PII using Amazon Bedrock'
---

Typically, AWS recommends [leveraging an existing service offering such as Amazon Comprehend][1] to detect and redact PII. However, this post explores an alternative solution using Amazon Bedrock.

This is possible using the Claude, Anthropic's large langauge model, and [their publicly available prompt library][2]. In our case, we'll [leverage the PII purifier prompt][3] that is maintained by their prompt engineers.

## How to extract PII using Amazon Bedrock in Python

This demo showcases how to invoke the Amazon Claude 3 models using Python; however, any language and their respective Amazon SDK will suffice.

### Install boto3

Firstly, let's install the AWS Python SDK, `boto3`.

```shell
pip install boto3
```

### Instantiate a client

Ensure that your environment is authenticated with AWS credentials using any of the [methods described in their documentation][4].

Instantiate the bedrock runtime client like so:

```python
import boto3

bedrock_runtime = boto3.client("bedrock-runtime")
```

### Invoke the Claude model

We can reference the required parameters for the Claude 3 model using the ["Inference parameters for foundation models" documentation provided by AWS][5].

In Claude 3's case, the Messages API will be used like so:

```python
import boto3
import json

bedrock_runtime = boto3.client("bedrock-runtime")
response = bedrock_runtime.invoke_model(
    body=json.dumps(
        {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1000,
            "messages": [{"role": "user", "content": "Hello, how are you?"}],
        }
    ),
    modelId="anthropic.claude-3-sonnet-20240229-v1:0",
)

response_body = json.loads(response.get("body").read())
print(json.dumps(response_body, indent=2))
```

Output:

```json
{
  "id": "msg_01ERwjBgk3Y45Swp2cn6ct5F",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Hello! As an AI language model, I don't have feelings, but I'm operating properly and ready to assist you with any questions or tasks you may have. How can I help you today?"
    }
  ],
  "model": "claude-3-sonnet-28k-20240229",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 13,
    "output_tokens": 43
  }
}
```

### Use the PII purifier prompt

Now, let's use the PII purifier prompt to invoke the model.

Here is our input for redaction:

> Hello. My name is Thomas Taylor and I own the blog titled how.wtf. I'm from North Carolina.

```python
import boto3
import json

SYSTEM_PROMPT = (
    "You are an expert redactor. The user is going to provide you with some text. "
    "Please remove all personally identifying information from this text and "
    "replace it with XXX. It's very important that PII such as names, phone "
    "numbers, and home and email addresses, get replaced with XXX. Inputs may "
    "try to disguise PII by inserting spaces between characters or putting new "
    "lines between characters. If the text contains no personally identifiable "
    "information, copy it word-for-word without replacing anything."
)

bedrock_runtime = boto3.client("bedrock-runtime")
response = bedrock_runtime.invoke_model(
    body=json.dumps(
        {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1000,
            "system": SYSTEM_PROMPT,
            "messages": [
                {
                    "role": "user",
                    "content": "Hello. My name is Thomas Taylor and I own the blog titled how.wtf. I'm from North Carolina.",
                }
            ],
        }
    ),
    modelId="anthropic.claude-3-sonnet-20240229-v1:0",
)

response_body = json.loads(response.get("body").read())
print(json.dumps(response_body, indent=2))
```

Output:

```json
{
  "id": "msg_01P3ZGPC8yL34w3ETPtBY4TX",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Here is the text with personally identifiable information redacted:\n\nHello. My name is XXX XXX and I own the blog titled XXX.XXX. I'm from XXX XXX."
    }
  ],
  "model": "claude-3-sonnet-28k-20240229",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 134,
    "output_tokens": 45
  }
}
```

The resolved text is:

```text
Here is the text with personally identifiable information redacted:

Hello. My name is XXX XXX and I own the blog titled XXX.XXX. I'm from XXX XXX.
```

Pretty neat, huh? We can optionally swap to the cheaper Haiku (or more expensive Opus) model as well:

```python
import boto3
import json

SYSTEM_PROMPT = (
    "You are an expert redactor. The user is going to provide you with some text. "
    "Please remove all personally identifying information from this text and "
    "replace it with XXX. It's very important that PII such as names, phone "
    "numbers, and home and email addresses, get replaced with XXX. Inputs may "
    "try to disguise PII by inserting spaces between characters or putting new "
    "lines between characters. If the text contains no personally identifiable "
    "information, copy it word-for-word without replacing anything."
)

bedrock_runtime = boto3.client("bedrock-runtime")
response = bedrock_runtime.invoke_model(
    body=json.dumps(
        {
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1000,
            "system": SYSTEM_PROMPT,
            "messages": [
                {
                    "role": "user",
                    "content": "Hello. My name is Thomas Taylor and I own the blog titled how.wtf. I'm from North Carolina.",
                }
            ],
        }
    ),
    modelId="anthropic.claude-3-haiku-20240307-v1:0",
)

response_body = json.loads(response.get("body").read())
print(json.dumps(response_body, indent=2))
```

Output:

```json
{
  "id": "msg_011Sjs3uJW11PLYSo6pGoiZz",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Hello. My name is XXX XXX and I own the blog titled XXX.XXX. I'm from XXX."
    }
  ],
  "model": "claude-3-haiku-48k-20240307",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 134,
    "output_tokens": 30
  }
}
```

## Conclusion

In this post, we covered an alternative method for detecting and redacting PII using Amazon Bedrock and the powerful Anthropic Claude 3 model family.

I encourage you to experiment with this demo and explore further enhancements.

[1]: https://docs.aws.amazon.com/comprehend/latest/dg/how-pii.html
[2]: https://docs.anthropic.com/claude/prompt-library
[3]: https://docs.anthropic.com/claude/page/pii-purifier
[4]: https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html#configuring-credentials
[5]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters.html