---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-01-10T01:40:00-05:00'
description: This article showcases how IAM roles can be created using multiple principals in the AWS CDK.
tags:
- python
- aws
- aws-cdk
- serverless
title: 'Create IAM role with multiple principals in AWS CDK'
---

I need to create an IAM role that is assumable by multiple principals, but the AWS CDK [role creation documentation][1] only lists the following example:

```python
lambda_role = iam.Role(self, "Role",
    assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
    description="Example role..."
)

stream = kinesis.Stream(self, "MyEncryptedStream",
    encryption=kinesis.StreamEncryption.KMS
)

stream.grant_read(lambda_role)
```

That works great, but how do I list multiple principals?

## Specifying multiple principals for IAM role

Luckily, there is a solution: the `CompositePrincipal`.

### How to use the composite principal with AWS CDK

The [`CompositePrincipal` class][2] enables developers to pass in variadic arguments of type `IPrincipal`.

In the snippet of code below, I

1. Create two roles that are assumable by the `{"AWS": "*"}` principal.
2. Create a third role that contains a `CompositePrincipal` for both of the previous roles using `iam.ArnPrincipal`
3. Showcase the role arns in a CloudFormation output

```python
from os import path

import aws_cdk as cdk
import aws_cdk.aws_iam as iam


class MultiplePrincipalsStack(cdk.Stack):
    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        one = iam.Role(self, "Role1", assumed_by=iam.AnyPrincipal())
        two = iam.Role(self, "Role2", assumed_by=iam.AnyPrincipal())

        three = iam.Role(
            self,
            "RoleWithMultiplePrincipals",
            assumed_by=iam.CompositePrincipal(
                iam.ArnPrincipal(one.role_arn), iam.ArnPrincipal(two.role_arn)
            ),
        )

        cdk.CfnOutput(self, "RoleArn1", value=one.role_arn)
        cdk.CfnOutput(self, "RoleArn2", value=two.role_arn)
        cdk.CfnOutput(self, "RoleArn3", value=three.role_arn)
```

After running `cdk deploy`, here are the stack outputs:

```text
Outputs:
stack.RoleArn1 = arn:aws:iam::123456789012:role/stack-Role13A5C70C1-2RU2vpUAiHMy
stack.RoleArn2 = arn:aws:iam::123456789012:role/stack-Role291939BC6-4geKeo5cAu3w
stack.RoleArn3 = arn:aws:iam::123456789012:role/stack-RoleWithMultiplePrincipals7CD0E21E-Rd9Rxpc2Ioqe
```

### Testing the role assumption

Using the outputs from before, we can verify that everything worked correctly using the AWS CLI.

I assumed `Role1` by using the `aws sts assume-role` command:

```shell
aws sts assume-role \
    --role-arn arn:aws:iam::123456789012:role/stack-Role13A5C70C1-2RU2vpUAiHMy \
    --role-session-name test
```

I exported the credentials from the output then assumed `RoleWithMultiplePrincipals`:

```shell
aws sts assume-role \
    --role-arn arn:aws:iam::123456789012:role/stack-RoleWithMultiplePrincipals7CD0E21E-Rd9Rxpc2Ioqe \
    --role-session-name test2
```

Everything worked!

[1]: https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_iam/Role.html
[2]: https://docs.aws.amazon.com/cdk/api/v2/python/aws_cdk.aws_iam/CompositePrincipal.html
