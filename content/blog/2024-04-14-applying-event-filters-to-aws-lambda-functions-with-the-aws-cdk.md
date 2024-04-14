---
author: Thomas Taylor
categories:
- cloud
- programming
date: '2024-04-14T12:30:00-04:00'
description: How to deploy a lambda function with event filters using the AWS CDK
tags:
- typescript
- aws
- aws-cdk
- serverless
title: 'Applying event filters to AWS Lambda Functions with the AWS CDK'
---

The primary motive for writing this article is to address the common error I repeatedly received while troubleshooting event filters:

> Invalid filter pattern definition. (Service: AWSLambda; Status Code: 400; Error Code: InvalidParameterValueException"

For my case, the goal was to invoke an AWS Lambda function via a DynamoDB stream.

## What are Lambda Event Filters

Lambda event filters allow developers to specify [which types of records from a stream or queue are submitted to a Lambda][1]. Event filters are included in event source mapping definitions so that Lambda functions are only invoked when the filter criteria is met.

## DynamoDB TTL deletion event filter

My use case involved invoking a lambda function to archive resources when a DynamoDB TTL expiry was met. Fortunately, the DynamoDB documentation [has a section that describes how to achieve this][2].

The required filter criteria is as follows:

```json
{
  "Filters": [
    {
      "Pattern": {
        "userIdentity": {
          "type": ["Service"],
          "principalId": ["dynamodb.amazonaws.com"]
        }
      }
    }
  ]
}
```

This filter patterns suggests that only actions submitted by the service principal `dynamodb.amazonaws.com` should be processed by the receiving consumer. This makes sense because the DynamoDB service deletes expired TTL items on our behalf.

## Adding event filters to Lambda Functions with AWS CDK

The following example demonstrates how to add event filters to a Lambda function using the AWS CDK in TypeScript:

```typescript
import * as path from 'path';

import { 
  Code, 
  FilterCriteria,
  Function,
  Runtime,
  StartingPosition
} from 'aws-cdk-lib/aws-lambda';

import { AttributeType, StreamViewType, Table } from 'aws-cdk-lib/aws-dynamodb';

import { DynamoEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';

const table = new Table(this, 'Table', {
  partitionKey: {
    name: 'id',
    type: AttributeType.STRING
  },
  stream: StreamViewType.NEW_IMAGE
});

const lambda = new Function(this, 'Function', {
  runtime: Runtime.NODEJS_20_X,
  handler: 'index.handler',
  code: Code.fromAsset(path.join(__dirname, 'lambda-handler'))
});

lambda.addEventSource(
  new DynamoEventSource(databaseTable, {
    startingPosition: StartingPosition.TRIM_HORIZON,
    filters: [
      FilterCriteria.filter({
        userIdentity: {
          type: ['Service'],
          principalId: ['dynamodb.amazonaws.com']
        }
      })
    ]
  })
)
```

The crucial part is the inner `filters` attribute within the event source definition:

```typescript
lambda.addEventSource(
  new DynamoEventSource(databaseTable, {
    startingPosition: StartingPosition.TRIM_HORIZON,
    filters: [
      FilterCriteria.filter({
        userIdentity: {
          type: ['Service'],
          principalId: ['dynamodb.amazonaws.com']
        }
      })
    ]
  })
)
```

It's important to note that the [static method of `FilterCriteria.filter`][10] **adds the `pattern` top-level attribute and marshals the inner JSON on our behalf.**

As of April 2024, the `filters` attribute is available on many supported event sources:

- The `DynamoEventSource` [documentation definition][3]
- The `KafkaEventSource` [documentation definition][4]
- The `KinesisEventSource` [documentation definition][5]
- The `ManagedKafkaEventSource` [documentation definition][6]
- The `S3EventSource` [documentation definition][7]
- The `SelfManagedKafkaEventSourceProps` [documentation definition][8]
- The `SqsEventSourceProps` [documentation definition][9]

[1]: https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventfiltering.html
[2]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/time-to-live-ttl-streams.html#streams-archive-ttl-deleted-items
[3]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.DynamoEventSourceProps.html
[4]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.KafkaEventSourceProps.html
[5]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.KinesisEventSourceProps.html
[6]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.ManagedKafkaEventSourceProps.html
[7]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.S3EventSourceProps.html
[8]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.SelfManagedKafkaEventSourceProps.html
[9]: https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_event_sources.SqsEventSourceProps.html
[10]: https://github.com/aws/aws-cdk/blob/bb90b4ccdbddbbce08a7d6f1b7d7e625263a70cf/packages/aws-cdk-lib/aws-lambda/lib/event-source-filter.ts#L75