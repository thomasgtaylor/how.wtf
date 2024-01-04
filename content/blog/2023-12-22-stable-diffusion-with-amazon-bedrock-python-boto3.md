---
author: Thomas Taylor
categories:
- cloud
- programming
- ai
date: 2023-12-22T02:00:00-05:00
description: How to call use the Amazon Bedrock Runtime boto3 SDK to invoke the Stable Diffusion model
images:
- images/MGTrlU.webp
tags:
- aws
- aws-cdk
- python
- serverless
- generative-ai
title: Stable Diffusion with Amazon Bedrock Python boto3
---

![invoking amazon bedrock runtime stable diffusion model](images/MGTrlU.webp)

Amazon Bedrock is a managed service provided by AWS that allows users to invoke models. For more information about the service, please refer to their [user guide here][1].

For this article, we're going to focus on how to invoke the Stable Diffusion model using the Python SDK: `boto3`. If you want to learn about the Amazon Bedrock SDK in general or how to invoke Claude with it, I have an [article here][2] that goes into detail.

## What is Stable Diffusion

Stable diffusion is a text-to-image model first released in 2022. The term "diffusion" originates from [diffusion models][3] in machine learning. OpenAI's DALL-E 2 is another example of a model that leverages diffusion. It's open source, free, and easy to run! In addition, it has an active community and a plethora of how-to tutorials.

For more information about Stable Diffusion, check out the [AWS write up][4] about it.

## How use Stable Diffusion with Amazon Bedrock

For this article, we'll be leveraging the Python AWS SDK: `boto3` to call the Stable Diffusion model.

### Install boto3

Let's begin by installing the latest version of `boto3` and the Python image library `PIL`.

```shell
pip3 install boto3 Pillow
```

### Lookup the model inference parameters

Each model has specific inference parameters that must be supplied to Bedrock.

As of time of writing, Dec. 22nd 2023, the supported [inference parameters for Stable Diffusion 1.0 text-to-image are][5]:

```text
{
    "text_prompts": [
        {
            "text": string,
            "weight": float
        }
    ],
    "height": int,
    "width": int,
    "cfg_scale": float,
    "clip_guidance_preset": string,
    "sampler": string,
    "samples",
    "seed": int,
    "steps": int,
    "style_preset": string,
    "extras": JSON object     
}
```

The smallest payload we can send is this:

```text
{
    "text_prompts": [{"text": string}]
}
```

### Use the invoke_model API

```python
import base64
import json
import io
from PIL import Image

import boto3

client = boto3.client("bedrock-runtime", region_name="us-east-1")

body = {"text_prompts": [{"text": "A blue bird"}]}

response = client.invoke_model(
    body=json.dumps(body), modelId="stability.stable-diffusion-xl"
)

response_body = json.loads(response["body"].read())
finish_reason = response_body.get("artifacts")[0].get("finishReason")

if finish_reason in ["ERROR", "CONTENT_FILTERED"]:
    raise Exception(f"Image error: {finish_reason}")

base64_image = response_body["artifacts"][0]["base64"]
base64_bytes = base64_image.encode("ascii")
image_bytes = base64.b64decode(base64_bytes)
image = Image.open(io.BytesIO(image_bytes))
image.show()
```

Here is the line-by-line breakdown of the code above:
- Instantiate the `boto3.client("bedrock-runtime")` client with a `region_name` of `us-east-1`.
- `json.dumps` a dictionary of Stable Diffusion's required inference parameters
- Invoke the model by specifying the `body` (string) and `modelId`
- If the `finishReason` is `ERROR` or `CONTENT_FILTERED`, raise an error
- Convert the `response_body` to the necessary types for `PIL.Image`
- Use `image.show()` to display a simple gui with the image

Output:

![stable diffusion output using Amazon Bedrock](images/t1MP6o.webp)


[1]: https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html
[2]: https://how.wtf/amazon-bedrock-runtime-examples-using-boto3.html
[3]: https://en.wikipedia.org/wiki/Diffusion_model
[4]: https://aws.amazon.com/what-is/stable-diffusion/
[5]: https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-diffusion-1-0-text-image.html
