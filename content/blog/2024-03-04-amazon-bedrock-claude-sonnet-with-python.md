---
author: Thomas Taylor
categories:
- cloud
- ai
date: 2024-03-04T23:30:00-05:00
description: "This post describes how to invoke Amazon Bedrock using the Claude 3 Sonnet model in Python with images (vision) and text."
tags:
- aws
- python
- generative-ai
title: 'Amazon Bedrock with images using Claude 3 Sonnet with Python'
---

On [March 4th, 2024][1], the Claude 3 Sonnet foundational model was made available in Amazon Bedrock. Not only is the model a major improvement over the Claude 2.0 family, but it allows for vision input.

In the post, we'll explore how to invoke Claude 3 Sonnet using Amazon's boto3 library in Python.

## Getting started

For those unfamiliar with the Bedrock runtime API, I have [a post that demonstrates how to invoke it using Claude 2.0 and Python boto3][2]. For this post, I'll be focusing specifically on image invocations.

Firstly, install `boto3`

```shell
pip3 install boto3
```

## How to send images to Amazon Bedrock

Fortunately, the API is straight forward to use. Let's instantiate the Amazon Bedrock Runtime client:

```python
import boto3

runtime = boto3.client("bedrock-runtime")
```

For Claude 3 Sonnet, we are [required to use the Anthropic Claude Messages API][3] as the inference parameter input.

```json
{
    "anthropic_version": "bedrock-2023-05-31", 
    "max_tokens": 1024,
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": "..."
                    }
                },
                {
                    "type": "text",
                    "text": "What is in this image?"
                }
            ]
        }
    ]
}
```

For the Claude 3 Sonnet model, the image is supplied using base64.

For my case, I will be using a local file for the model.

```python
with open("image.jpg", "rb") as image_file:
    image_bytes = image_file.read()

encoded_image = base64.b64encode(image_bytes).decode("utf-8")
```

You may choose to download image using the `requests` library.

```python
image_url = "https://url-to-the-image.com/file.jpg"
image_bytes = requests.get(url).content

encoded_image = base64.b64encode(image_bytes).decode("utf-8")
```

The image I'm using is the [Hohenzollern Castle in Germany][4].

Here is the full example:

```python
import base64
import json

import boto3

runtime = boto3.client("bedrock-runtime")

with open("image.jpg", "rb") as image_file:
    image_bytes = image_file.read()

encoded_image = base64.b64encode(image_bytes).decode("utf-8")

body = json.dumps(
    {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 1000,
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "image",
                        "source": {
                            "type": "base64",
                            "media_type": "image/jpeg",
                            "data": encoded_image,
                        },
                    },
                    {"type": "text", "text": "What is in this image?"},
                ],
            }
        ],
    }
)

response = runtime.invoke_model(
    modelId="anthropic.claude-3-sonnet-20240229-v1:0",
    body=body
)

response_body = json.loads(response.get("body").read())

print(response_body)
```

Here's the `response_body` converted to a JSON payload:

```json
{
  "id":"msg_01315rokf5kw6LSnnW6aWyVb",
  "type":"message",
  "role":"assistant",
  "content":[
    {
      "type":"text",
      "text":"This image shows the famous Hohenzollern Castle in Germany. The castle sits majestically atop a cliff, overlooking a river or lake in the foreground. The massive medieval fortress features ornate towers, spires, and archways in a Romanesque architectural style with red tiled roofs. The castle appears to be well-preserved and maintained, set against a picturesque blue sky with fluffy white clouds. The surrounding scenery includes bare trees and a small playground area near the water's edge, suggesting this is a popular tourist destination showcasing Germany's rich historical heritage and stunning natural landscapes."
    }
  ],
  "model":"claude-3-sonnet-28k-20240229",
  "stop_reason":"end_turn",
  "stop_sequence":null,
  "usage":{
    "input_tokens":1606,
    "output_tokens":130
  }
}
```

Sure enough, the model accurately depicted the image shown.

[1]: https://aws.amazon.com/blogs/aws/anthropics-claude-3-sonnet-foundation-model-is-now-available-in-amazon-bedrock/
[2]: https://how.wtf/amazon-bedrock-runtime-examples-using-boto3.html
[3]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html
[4]: https://upload.wikimedia.org/wikipedia/commons/8/8a/Schloss_Sigmaringen_2022.jpg
