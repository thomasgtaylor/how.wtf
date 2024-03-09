---
author: Thomas Taylor
categories:
- cloud
- ai
date: 2024-03-09T12:45:00-05:00
description: "This post showcases how to invoke the Claude 3 Opus model using the Anthropic API in Python."
tags:
- python
- generative-ai
title: Using Claude 3 Opus with Anthropic API in Python
---

With the [recent release of the Claude 3 family][1], this was the perfect opportunity to use the Claude API access that I was recently granted.

The Claude 3 family boasts a *huge* improvement from the prior family, Claude 2. The introductory post goes into greater detail.

In this post, we'll explore how to invoke Claude 3 Opus using the Anthropic SDK.

## Getting started

For the purposes of this post, we'll leverage the Python Anthropic SDK.

```shell
pip3 install anthropic
```

To authorize requests, please export the `ANTHROPIC_API_KEY`:

```shell
export ANTHROPIC_API_KEY="sk..."
```

## How to invoke Claude 3 Opus

The API for invoking Anthropic models is simple. 

The model we'll use is for Opus: `claude-3-opus-20240229`.

If you wish to target other models, please refer to [Anthropic's model page for more information][2].

```python
from anthropic import Anthropic

model = "claude-3-opus-20240229"

client = Anthropic()

message = client.messages.create(
    max_tokens=1024,
    messages=[{"role": "user", "content": "Hello! How are you?"}],
    model=model,
)
print(message.content)
print(f"Input tokens: {message.usage.input_tokens}")
print(f"Output tokens: {message.usage.output_tokens}")
```

Output:

```text
[ContentBlock(text="Hello! I'm doing well, thank you for asking. As an AI language model, I don't have feelings, but I'm functioning properly and ready to assist you with any questions or tasks you may have. How can I help you today?", type='text')]
Input tokens 13
Output tokens 53
```

In the example above, the `Anthropic()` client was instantiated and automatically referenced the environment variable from earlier.

Then, [using the Messages API][3], we created a new message.

## How to invoke Claude 3 Opus with Streaming

Similarly to before, we also have the option to stream output using Anthropic's API.

```python
from anthropic import Anthropic

model = "claude-3-opus-20240229"

client = Anthropic()

stream = client.messages.create(
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": "Hello! How are you?",
        }
    ],
    model=model,
    stream=True,
)

message = ""
input_tokens = None
output_tokens = None
for event in stream:
    match event.type:
        case "message_start":
            input_tokens = event.message.usage.input_tokens
        case "content_block_start":
            message += event.content_block.text
        case "content_block_delta":
            message += event.delta.text
        case "message_delta":
            output_tokens = event.usage.output_tokens
        case "content_block_stop" | "message_stop":
            ...

print(message)
print(f"Input tokens: {input_tokens}")
print(f"Output tokens: {output_tokens}")
```

Output:

```text
Hello! As an AI language model, I don't have feelings, but I'm functioning well and ready to assist you. How can I help you today?
Input tokens: 13
Output tokens: 35
```

For the sake of the example, I concatenated the "text"-based events together for demonstration purposes.

For asynchronous eventing, please [refer to the Anthropic SDK documentation][4].

[1]: https://www.anthropic.com/news/claude-3-family
[2]: https://docs.anthropic.com/claude/docs/models-overview
[3]: https://docs.anthropic.com/claude/reference/messages_post
[4]: https://github.com/anthropics/anthropic-sdk-python?tab=readme-ov-file#async-usage
