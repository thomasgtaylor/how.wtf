---
author: Thomas Taylor
categories:
- cloud
date: '2024-04-06T16:20:00-04:00'
description: How to deploy a serverless lambda api with a function url using the AWS CDK
tags:
- typescript
- aws
- aws-cdk 
- serverless
title: 'Deploy serverless Lambda TypeScript API with function url using AWS CDK'
---

In November 2023, I wrote a post [describing how to deploy a lambda function with a function url][1] in Python. For this post, I want to showcase how streamlined and practical it is to deploy a "Lambdalith" (a single Lambda function) that contains an entire API.

What this means:

1. No API Gateway
2. **API requests can take longer than 30 seconds**
3. Faster deployments
4. Local testing without cloud deployment
5. Reduced costs *
6. Easy management *

* = Depends on the use-case

## How to deploy a serverless API using Fastify

To begin, let's initialize a CDK application for Typescript:

```
cdk init app --language typescript
```

This creates the boilerplate directories and files we'll need:

```text
serverless-api
├── README.md
├── bin
│   └── serverless-api.ts
├── cdk.json
├── jest.config.js
├── lib
│   └── serverless-api-stack.ts
├── package-lock.json
├── package.json
├── test
│   └── serverless-api.test.ts
└── tsconfig.json
```

## Install and configure Fastify

[Fastify is a JavaScript web framework][2] that intentionally aims for low overhead and speed over other frameworks such as express. I have arbitrarily chose it for this tutorial, but any web framework that supports routing will work.

### Install fastify

Install `fastify` using one of the methods [described in their documentation][3] and [their AWS Lambda adapter `@fastify/aws-lambda`][4].

For this tutorial, I'll use `npm`.

```
npm i fastify @fastify/aws-lambda @types/aws-lambda
```

### Create an entry file

To make it easy, we'll create an entry point for the lambda at `handler/index.ts` with the following contents:

```typescript
import Fastify from "fastify";
import awsLambdaFastify from "@fastify/aws-lambda";

function init() {
  const app = Fastify();
  app.get('/', (request, reply) => reply.send({ hello: 'world' }));
  return app;
}

if (require.main === module) {
  // called directly i.e. "node app"
  init().listen({ port: 3000 }, (err) => {
    if (err) console.error(err);
    console.log('server listening on 3000');
  });
} else {
  // required as a module => executed on aws lambda
  exports.handler = awsLambdaFastify(init())
}
```

The directory structure should look like the following tree:

```text
serverless-api
├── README.md
├── bin
│   └── serverless-api.ts
├── cdk.json
├── handler
│   └── index.ts
├── jest.config.js
├── lib
│   └── serverless-api-stack.ts
├── package-lock.json
├── package.json
├── test
│   └── serverless-api.test.ts
└── tsconfig.json
```

With this method, we are able to test locally _without_ deploying to the cloud.

First, transpile the Typescript files to JavaScript:

```shell
npm run build
```

Then execute the `handler/index.js` file with `node`:

```shell
node handler/index.js
```

If you visit [http://localhost:3000][5] in your browser, it should display:

```json
{
    "hello": "world"
}
```

## Deploying the function with the function url enabled

Fortunately, the AWS CDK enables users to quickly deploy using the `NodeJSFunction` construct. Replace the contents of `serverless-api-stack.ts` with the following snippet:

```typescript
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { NodejsFunction } from 'aws-cdk-lib/aws-lambda-nodejs';
import { FunctionUrlAuthType } from 'aws-cdk-lib/aws-lambda';

export class ServerlessApiStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const handler = new NodejsFunction(this, 'handler', {
      entry: './handler/index.ts',
      timeout: cdk.Duration.minutes(1)
    });
    const url = handler.addFunctionUrl({
      authType: FunctionUrlAuthType.NONE
    });
    new cdk.CfnOutput(this, 'url', {
      value: url.url
    });
  }
}
```

The code creates a `NodejsFunction` lambda, enables the function url without authentication, and outputs the url as a CloudFormation export.

Deploy the stack using the cdk:

```shell
npx cdk deploy
```

The command output contains the `CfnOutput` value:

```
Do you wish to deploy these changes (y/n)? y
ServerlessApiStack: deploying... [1/1]
ServerlessApiStack: creating CloudFormation changeset...

 ✅  ServerlessApiStack

✨  Deployment time: 38.19s

Outputs:
ServerlessApiStack.url = https://{id}.lambda-url.us-east-1.on.aws/
Stack ARN:
arn:aws:cloudformation:us-east-1:123456789012:stack/ServerlessApiStack/{id}
```

If you navigate to the url, you will view the expected results displayed:

```json
{
    "hello": "world"
}
```

All of this was completed with _very_ little infrastructure to manage and a single `index.ts` file. From here, you can expand the project to include as many routes as you prefer.

[1]: https://how.wtf/create-lambda-function-url-using-aws-cdk.html
[2]: https://fastify.dev/
[3]: https://fastify.dev/docs/latest/Guides/Getting-Started/
[4]: https://fastify.dev/docs/latest/Guides/Serverless/
[5]: http://localhost:3000
