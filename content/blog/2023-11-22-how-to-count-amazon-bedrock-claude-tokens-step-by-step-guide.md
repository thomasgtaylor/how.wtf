---
author: Thomas Taylor
categories:
- ai
- programming
date: 2023-11-22T11:50:00-05:00
description: This article describes how to track Amazon Bedrock Claude token usage
images:
- images/s6Kev8.webp
tags:
- generative-ai
- python 
title: How to count Amazon Bedrock Claude tokens step-by-step guide
---

![Counting Amazon Bedrock Claude tokens](images/s6Kev8.webp)

Monitoring token consumption in Anthropic-based models can be straightforward and hassle-free. In fact, Anthropic offers a simple and effective method for accurately counting tokens using Python!

In this guide, I'll show you how to count tokens for Amazon Bedrock Anthropic models.

## Installing the Anthropic Bedrock Python Client

To begin, install the Amazon Bedrock Python client using `pip`:

```shell
pip install anthropic-bedrock
```

For more information about the library, visit the [technical documentation here][1].

## Create the Amazon Bedrock connection

Instantiating the client is straightforward: use your AWS credentials to authenticate.

Since the `AnthropicBedrock` client uses `botocore` for authentication, you may use any AWS provider of your choosing:

- Environment variables
- AWS Configuration file
- Hardcoded `aws_access_key` + `aws_secret_key` in the `AnthropicBedrock` client directly

Here is the code snippet from the documentation:

```python
import anthropic_bedrock
from anthropic_bedrock import AnthropicBedrock

client = AnthropicBedrock(
    # Authenticate by either providing the keys below or use the default AWS credential providers, such as
    # using ~/.aws/credentials or the "AWS_SECRET_ACCESS_KEY" and "AWS_ACCESS_KEY_ID" environment variables.
    aws_access_key="<access key>",
    aws_secret_key="<secret key>",
    # Temporary credentials can be used with aws_session_token.
    # Read more at https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html.
    aws_session_token="<session_token>",
    # aws_region changes the aws region to which the request is made. By default, we read AWS_REGION,
    # and if that's not present, we default to us-east-1. Note that we do not read ~/.aws/config for the region.
    aws_region="us-east-1",
)
```

For the sake of this guide, I set my `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables. My client is using the default region of `us-east-1`:

```python
import anthropic_bedrock
from anthropic_bedrock import AnthropicBedrock

client = AnthropicBedrock()
```

## Listing model access

The `completions` Anthropic API requires a model id. To determine what models are accessible on your AWS account, run the following command using the `aws` cli:

```shell
aws bedrock list-foundation-models --by-provider anthropic --query "modelSummaries[*].modelId"
```

Output:

```text
[
    "anthropic.claude-instant-v1",
    "anthropic.claude-v1",
    "anthropic.claude-v2"
]
```

## Calling Claude on Bedrock using the client

Using the `anthropic.claude-instant-v1` model id from above, here's how to call it using the `completions` API:

```
import anthropic_bedrock
from anthropic_bedrock import AnthropicBedrock

client = AnthropicBedrock()

completion = client.completions.create(
    model="anthropic.claude-instant-v1",
    prompt=f"{anthropic_bedrock.HUMAN_PROMPT} Tell me a funny cowboy joke {anthropic_bedrock.AI_PROMPT}",
    max_tokens_to_sample=2000,
)

print(completion.completion)
```

Output:

```text
 Here's one: Why don't cowboys like to eat beef jerky in the desert? Because it's too chewy!
```

In the code above, I'm calling the `client.completions.create` function and supplying it:

1. The model id as a string
2. The prompt using the Anthropic provided constants: `anthropic_bedrock.HUMAN_PROMPT` and `anthropic_bedrock.AI_PROMPT`
3. The max tokens to sample is the maximum number of tokens to generate before stopping.

The prompt above resolved to this:

```python
import anthropic_bedrock

print(
    f"{anthropic_bedrock.HUMAN_PROMPT} Tell me a funny cowboy joke {anthropic_bedrock.AI_PROMPT}"
)
```

Output:

```text


Human: Tell me a funny cowboy joke

Assistant:
```

For more information about asynchronous or streamed responses, please refer to the [technical documentation here][2]

## Counting tokens using the client

Using the example before, we can count the token usage using a static method provided by Anthropic.

```python
from anthropic_bedrock import AnthropicBedrock

client = AnthropicBedrock()
print(client.count_tokens("Hello world!"))
```

As of November 2023, Anthropic charges based on [prompt tokens and completion tokens][3].

For tracking tokens, you can leverage this method to estimate:

```python
import anthropic_bedrock
from anthropic_bedrock import AnthropicBedrock

client = AnthropicBedrock()

prompt = f"{anthropic_bedrock.HUMAN_PROMPT} Tell me a funny cowboy joke {anthropic_bedrock.AI_PROMPT}"
prompt_tokens = client.count_tokens(prompt)
print(prompt_tokens)

result = client.completions.create(
    model="anthropic.claude-instant-v1",
    prompt=prompt,
    max_tokens_to_sample=2000,
)

completion = result.completion
completion_tokens = client.count_tokens(completion)
print(completion_tokens)
```

Output:

```text
14
28
```

[1]: https://docs.anthropic.com/claude/docs/claude-on-amazon-bedrock
[2]: https://github.com/anthropics/anthropic-bedrock-python
[3]: https://support.anthropic.com/en/articles/8114526-how-will-i-be-billed
