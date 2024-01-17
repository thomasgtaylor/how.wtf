---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-01-17T00:45:00-05:00'
description: How to tag apps, resources, stacks, and other constructs using the AWS CDK.
tags:
- python
- aws
- aws-cdk
title: Tagging in AWS CDK
---

Tags are [key/value metadata][1] that enable users to categorize their AWS infrastructure. This is useful for identifying groups of resources, monitoring cloud spending, creating reports, etc.

In this post, we'll explore different methods for tagging infrastructure using the AWS CDK.

## Tagging constructs

Constructs are the [basic "building blocks" of the AWS CDK][2]. They act as components and encapsulate necessary information for CloudFormation. Fortunately, the AWS CDK provides an easy-to-use API.

The standard method for tagging resources are:

```python
Tags.of(construct).add("key", "value")
```

### Tag resources in AWS CDK

As shown above, tagging an individual resource is easy. 

The example below is in Python, but the same technique can be applied to other languages:

```python
from aws_cdk import App, Stack, Tags
from aws_cdk import aws_iam as iam


class MyStack(Stack):
    def __init__(self, scope: App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        my_role = iam.Role(self, "role", assumed_by=iam.AnyPrincipal())
        Tags.of(my_role).add("owner", "team@example.com")
```

A tag with "owner" and "team@example.com" was added to the role construct.

### Tag stacks in AWS CDK

Tagging a stack will apply tags to the stack construct _and_ all resources within it.

```python
from aws_cdk import App, Tags

from stack import MyStack

app = App()
my_stack = MyStack(app, "Stack")

Tags.of(my_stack).add("owner", "team@example.com")

app.synth()
```

A tag with "owner" and "team@example.com" was added to the stack construct and all constructs within the stack.

### Tag apps using AWS CDK

Like the previous example, tagging an app will auto tag the sub-constructs as well.

```python
from aws_cdk import App, Tags

from stack import MyStack

app = App()
my_stack = MyStack(app, "Stack")

Tags.of(app).add("owner", "team@example.com")

app.synth()
```

A tag with "owner" and "team@example.com" was added to the app construct and all constructs within the app.

### Tag stacks using AWS CDK CLI

If you prefer specifying a tag at `cdk deploy` time, the `--tags` flag is available:

```shell
cdk deploy Stack \
    --tags owner=team@example.com \
    --tags department=engineering
```

With the command above, two tags were applied to a stack named `Stack`.

### Tag stacks using AWS CDK cdk.json file

An alternative to the command line flag is using the `cdk.json` file to specify deploy time tags.

Simply add the `tags` key to your `cdk.json` file with your tags defined in an array:

```json
{
  "app": "python3 app.py",
  "tags": [
    {
      "Key": "owner",
      "Value": "team@example.com"
    },
    {
      "Key": "department",
      "Value": "engineering"
    }
  ]
}
```

## Duplicate tags in AWS CDK

Occasionally, there may be duplicate tags applied to the same resource.

To control which tags overwrite others, a `priority` parameter can be supplied to the `add` method. By default, all tags applied have a 100 priority.

```python
from aws_cdk import App, Tags

from stack import MyStack

app = App()
my_stack = MyStack(app, "Stack")

Tags.of(my_stack).add("owner", "team2@example.com", priority=101)
Tags.of(my_stack).add("owner", "team@example.com")

app.synth()
```

If both stacks have a priority of `100` – [the bottom-most tag][3] on the construct tree wins. In this case, the `101` priority superseded the bottom-most call.

[1]: https://aws.amazon.com/solutions/guidance/tagging-on-aws
[2]: https://docs.aws.amazon.com/cdk/v2/guide/constructs.html
[3]: https://docs.aws.amazon.com/cdk/v2/guide/tagging.html#w53aac21c26c25
