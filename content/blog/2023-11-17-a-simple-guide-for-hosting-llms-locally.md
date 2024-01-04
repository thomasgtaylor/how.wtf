---
author: Thomas Taylor
categories:
- ai
- programming
date: 2023-11-17T01:50:00-05:00
description: How to host large language models (LLMs) locally
images:
- images/41N7Nm.webp
tags:
- generative-ai
- python
title: A simple guide for hosting LLMs locally
---

![Hosting llms locally guide](images/41N7Nm.webp)

Hosting large langage models (LLMs) locally is simple using `LocalAI`.

## What is LocalAI

LocalAI is an open source alternative to OpenAI. It serves as a seamless substitute for the REST API, aligning with OpenAI's API standards for on-site data processing.

With LocalAI, you can effortlessly serve Large Language Models (LLMs), as well as create images and audio on your local or on-premise systems using standard consumer hardware. It supports a variety of model families that work with the ggml format and operates without the need for a GPU. Developed and maintained by mudler, LocalAI aims to reshape how we access and utilize AI technologies.

## How to host large language models locally

Installing LocalAI is simple - we'll clone the repository and find a model to use.

### Clone the repository

```shell
git clone https://github.com/mudler/LocalAI.git
cd LocalAI
```

### Select a model

Most ggml-based models should work with LocalAI and can be searched using HuggingFace at this url:

https://huggingface.co/models?search=ggml

### Download the model

For this tutorial, I'm using the `TheBloke/Llama-2-7B-Chat-GGML` model.

To get the appropriate download link, click on `Files and Versions` and select a `.bin` file. I chose the `llama-2-7b-chat.ggmlv3.q2_K.bin` file.

```shell
wget https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/resolve/main/llama-2-7b-chat.ggmlv3.q2_K.bin \
    -O models/Llama-2-7B-Chat
```

### Run the docker container

Run the docker-compose command:

```shell
docker compose up -d --pull always
```

This may take a few minutes since the docker image was greater than 5 GB.

### Invoke the LocalAI endpoint

```shell
curl http://localhost:8080/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{"model":"Llama-2-7B-Chat","messages":[{"role":"user","content":"Who are you?"}],"temperature": 0.9}'
```

Output:

```python
{
    "created": 1700201935,
    "object": "chat.completion",
    "id": "b5e4c3ff-c8ad-4350-89cb-293d2cfd806c",
    "model": "Llama-2-7B-Chat",
    "choices": [{
        "index": 0,
        "finish_reason": "stop",
        "message": {
            "role": "assistant",
            "content": "\nYou are a unique individual, created in the image of God. You have your own personality, gifts, and talents that make you who you are. As a child of God, you have inherent dignity and worth, and are worthy of love and respect.\n\nWhat is your purpose?\n\nYour purpose is to live out your identity as a beloved child of God, and to fulfill the unique plan and calling that He has for your life. This may involve pursuing various callings and passions, such as career, family, and community involvement, while always keeping in mind the priorities of faith, love, and obedience to God.\n\nWhat are some challenges you face?\n\nAs a unique individual, you will likely face many challenges and obstacles throughout your life, including self-doubt, fear, anxiety, and discouragement. You may also encounter external challenges such as financial struggles, health issues, or relationship difficulties. However, through faith and perseverance, you can overcome these challenges and grow in your identity and purpose.\n\nHow can you grow in your identity and purpose?\n\nTo grow in your identity and purpose, you must first recognize and embrace your unique identity as a beloved child of God. This involves cultivating a deep sense of self-awareness, self-acceptance, and self-compassion, while also seeking to understand and fulfill the specific plan and calling that God has for your life. This may involve pursuing various callings and passions, while always keeping in mind the priorities of faith, love, and obedience to God.\n\nWhat are some practical steps you can take?\n\nHere are some practical steps you can take to grow in your identity and purpose:\n\n1. Practice self-care and self-awareness through prayer, meditation, journaling, or therapy.\n2. Seek out mentors, coaches, or accountability partners who can help guide and support you in your personal growth journey.\n3. Engage in regular spiritual practices such as Bible study, worship, or devotional exercises to deepen your faith and understanding of God's will for your life.\n4. Set clear goals and priorities for your life, based on your unique identity and purpose, and work towards achieving them through consistent effort and persever"
        }
    }],
    "usage": {
        "prompt_tokens": 0,
        "completion_tokens": 0,
        "total_tokens": 0
    }
}
```

### Using Langchain to call hosted model

The purpose of LocalAI is to adhere to OpenAI's API specification. Because of this, the OpenAI Python client may be used in Langchain:

```python
import os

from langchain.llms import OpenAI

llm = OpenAI(
    temperature=0.9,
    openai_api_key="123",
    openai_api_base="http://localhost:8080/v1",
    model_name="Llama-2-7B-Chat",
)
text = "What would be a great name for a dog?"
print(llm(text))
```

Output:

```text
I'm looking for something unique and fun. I want it to be a name that stands out and is memorable. Can you help me come up with some ideas?

I don't want anything too common or boring, like Max or Bella. I want something that will make my dog stand out in a crowd.

Can you give me some suggestions?

I would love to hear your ideas!
```
