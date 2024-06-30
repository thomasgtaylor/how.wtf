---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-06-30T17:35:00-04:00'
description: In this post, we'll dive into how to implement API key authentication with API Gateway using a lambda authorizer.
tags:
- typescript
- aws
- aws-cdk
- serverless
title: 'API Key Authentication with API Gateway using AWS CDK'
---

API key authentication is a common method for securing APIs by controlling access to them. It's important to note that API keys are great for authentication, but further development should be made to ensure proper authorization at the business level. API keys do not ensure that the correct permissions are being enforced, only that the user has access to the API.

Regardless, let's get started! In this post, we're going to touch on a few services:

1. API Gateway with Proxy Integration
2. Lambda Authorizer
4. AWS CDK

## Get started

Conceptually, the flow of our application will look like this:

1. Client makes a request to API Gateway with API key
2. The lambda authorizer determines if the API key is valid
3. If the API key is valid, the policy is generated and the request is allowed to pass through to the lambda function
4. If the API key is invalid, the request is denied
5. The lambda function is invoked and returns a response

### Set up the CDK project

Firstly, let's create the CDK project. I will choose TypeScript as the language, but you can choose any language you prefer. Please refer to the [AWS CDK hello world documentation][1] for other supported languages.

```shell
cdk init --language typescript
```

Next, let's install the necessary dependencies:

```shell
npm i
```

In addition, install the `@types/aws-lambda` package:

```shell
npm i @types/aws-lambda
```

Let's start by finding the primary stack file which is located under the `lib` directory. In my case, it's `lib/api-key-gateway-stack.ts`.

## Edit the CDK stack

Luckily, in a few lines of code, we can spin up a full-featured API Gateway with a lambda handler using the AWS CDK.

```typescript
import { Duration, Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import { Runtime } from "aws-cdk-lib/aws-lambda";
import {
  LambdaRestApi,
  TokenAuthorizer,
  AuthorizationType,
} from "aws-cdk-lib/aws-apigateway";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";

export class ApiKeyGatewayStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);
    const fn = new NodejsFunction(this, "server", {
      entry: "bin/server.ts",
      handler: "handler",
      runtime: Runtime.NODEJS_20_X,
      timeout: Duration.minutes(1),
    });
    const auth = new NodejsFunction(this, "auth", {
      entry: "bin/auth.ts",
      handler: "handler",
      runtime: Runtime.NODEJS_20_X,
      timeout: Duration.seconds(10),
    });
    const api = new LambdaRestApi(this, "api", {
      handler: fn,
      defaultMethodOptions: {
        authorizationType: AuthorizationType.CUSTOM,
        authorizer: new TokenAuthorizer(this, "authorizer", {
          handler: auth,
        }),
      },
    });
  }
}
```

Let's break down the code:

1. The first construct, `NodejsFunction`, is a node lambda function that will serve as our primary handler.
2. The second construct, another `NodejsFunction`, is a lambda authorizer that will be used to validate the API key.
3. The third construct, `LambdaRestApi`, is the API Gateway that includes the first construct wired as the proxy integration and the second construct as the authorizer.

## Create the lambda handler

Located at `bin/server.ts`, we will create a simplistic lambda function that returns `Hello, World!`.

```typescript
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

export const handler = async (
  event: APIGatewayProxyEvent,
): Promise<APIGatewayProxyResult> => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello, World!" }),
  };
};
```

## Create the lambda authorizer

Next, let's create the lambda authorizer located at `bin/auth.ts`. This lambda function will be responsible for validating the API key.

To keep it simple, we will hardcode the API key to `Bearer abc123`.

```typescript
import { APIGatewayTokenAuthorizerEvent, Handler } from "aws-lambda";

export const handler: Handler = async (
  event: APIGatewayTokenAuthorizerEvent,
) => {
  const effect = event.authorizationToken == "Bearer abc123" ? "Allow" : "Deny";
  return {
    principalId: "abc123",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: effect,
          Resource: [event.methodArn],
        },
      ],
    },
  };
};
```

## Deploy the stack

Now that we have our stack and lambda handlers setup, let's deploy the stack!

```shell
npx cdk deploy
```

Once the deployment is complete, you should see the API Gateway endpoint as an output.

```text
Do you wish to deploy these changes (y/n)? y
ApiKeyGatewayStack: deploying... [1/1]
ApiKeyGatewayStack: creating CloudFormation changeset...

 ✅  ApiKeyGatewayStack

✨  Deployment time: 45.34s

Outputs:
ApiKeyGatewayStack.apiEndpoint9349E63C = https://x2s65m7xyd.execute-api.us-east-1.amazonaws.com/prod/
Stack ARN:
arn:aws:cloudformation:us-east-1:123456789012:stack/ApiKeyGatewayStack/0ca225a0-3727-11ef-ae64-0affd17461c9
✨  Total time: 117.33s
```

## Test the API

Let's use `curl` to test the API without the API key.

```shell
curl https://<id>.execute-api.us-east-1.amazonaws.com/prod/
```

Output:

```json
{"message":"Unauthorized"}
```

As expected, we received an unauthorized response. Now, let's test the API with the API key.

```shell
curl https://x2s65m7xyd.execute-api.us-east-1.amazonaws.com/prod/ \
    -H "Authorization: Bearer abc123"
```

Output:

```json
{"message":"Hello, World!"}
```

Great! We have successfully created an API Gateway with a lambda authorizer using the AWS CDK. At this point, you may choose to extend the Lambda Authorizer to query another data source like DynamoDB that stores API keys.

## Clean up

Lastly, let's clean up our AWS resources by destroying the stack:

```shell
npx cdk destroy
```

That's it! You successfully created an API Gateway with a lambda authorizer using the AWS CDK.

[1]: https://docs.aws.amazon.com/cdk/v2/guide/hello_world.html
