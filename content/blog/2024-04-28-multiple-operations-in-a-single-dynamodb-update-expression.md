---
author: Thomas Taylor
categories:
- cloud
- database
- programming
date: '2024-04-28T13:10:00-04:00'
description: In this post, we'll explore how to perform multiple operations using clauses and keywords in a single DynamoDB update expression.
tags:
- aws
- dynamodb
- serverless
title: 'Multiple operations in a single DynamoDB update expression'
---

DynamoDB supports an `UpdateItem` operation that modifies an existing or creates a new item. The `UpdateItem` accepts an `UpdateExpression` that dictates which operations will occur on the specified item.

In this post, we'll explore how to perform multiple operations including within a clause/keyword and with multiple clauses/keywords.

## What is an update expression

An update expression supports four keywords:

1. `SET` (modify or add item attributes)
2. `REMOVE` (deleting attributes from an item)
3. `ADD` (updating numbers and sets)
4. `DELETE` (removing elements from a set)

The syntax for an update expression is as follows:

```text
update-expression ::=
    [ SET action [, action] ... ]
    [ REMOVE action [, action] ...]
    [ ADD action [, action] ... ]
    [ DELETE action [, action] ...]
```

As you can view, DynamoDB supports four main clauses that begin with one of the specified operations.

For a detailed explanation of update expressions, [please refer to the AWS documentation][1].

For demonstration purposes, I'm going to create a DynamoDB table named `books` with a number hash key named `id`.

```shell
aws dynamodb create-table \
  --table-name books \
  --attribute-definitions AttributeName=id,AttributeType=N \
  --key-schema AttributeName=id,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

I'll also add an item to the table:

```json
{
  "id": {
    "N": "1"
  },
  "title": {
    "S": "Iliad"
  },
  "author": {
    "S": "Homer"
  },
  "genre": {
    "S": "Epic Poetry"
  },
  "publication_year": {
    "N": "1488"
  }
}
```

```shell
aws dynamodb put-item \
    --table-name books \
    --item file://book.json
```

## How to specify a single keyword in DynamoDB update expression

Let's showcase a basic use-case of adding an element to an existing item:

```shell
aws dynamodb update-item \
    --table-name books \
    --key '{"id":{"N":"1"}}' \
    --update-expression "SET category = :c" \
    --expression-attribute-values '{":c":{"S":"Poem"}}'
```

Now the item has a new `category` attribute:

```shell
aws dynamodb get-item \
    --table-name books \
    --key '{"id":{"N":"1"}}' \
    --projection-expression "category"
```

Output:

```json
{
  "Item": {
    "category": {
      "S": "Poem"
    }
  }
}
```

## How to specify a single keyword with multiple actions in DynamoDB update expression

To showcase mutliple `SET` operations in a single DynamoDB update expression, we'll use a comma (`,`) to separate them.

In the following example, we're changing the `category` from `poem` -> `poetry` and adding a new element named `genre`.

```shell
aws dynamodb update-item \
    --table-name books \
    --key '{"id":{"N":"1"}}' \
    --update-expression "SET category = :c, genre = :g" \
    --expression-attribute-values '{":c":{"S":"poetry"}, ":g":{"S":"Epic poetry"}}' \
    --return-values UPDATED_NEW
```

Output:

```json
{
  "Attributes": {
    "category": {
      "S": "poetry"
    },
    "genre": {
      "S": "Epic poetry"
    }
  }
}
```

As you see, the `update-expression` includes a comma between the two operations:

`SET category = :c, genre = :g`

## How to specify multiple keywords with multiple actios in DynamoDB update expression

Lastly, let's showcase leveraging _multiple_ keywords with their respective actions.

We're going to perform the following:

1. Set a new string attribute named `product_category` with a value of `poem`
2. Remove the `category` attribute
4. Add `1` to existing `checkout_total` number or initialize it with the number value of `1`
3. Add `Trojan War` to existing `subjects` set or initialize it with the first index being string value of `Trojan War`

```shell
aws dynamodb update-item \
    --table-name books \
    --key '{"id":{"N":"1"}}' \
    --update-expression "SET #pc = :pc REMOVE #c ADD #ct :inc, #s :s" \
    --expression-attribute-names '{"#s":"subjects","#pc":"product_category","#c":"category","#ct":"checkout_total"}' \
    --expression-attribute-values '{":s":{"SS":["Trojan War"]},":pc":{"S":"poem"},":inc":{"N":"1"}}' \
    --return-values UPDATED_NEW
```

Output:

```json
{
  "Attributes": {
    "checkout_total": {
      "N": "1"
    },
    "subjects": {
      "SS": [
        "Trojan War"
      ]
    },
    "product_category": {
      "S": "poem"
    }
  }
}
```

It's important to note that because the `ADD` operation will continue incrementing and the `SET` data structure doesn't allow duplicates, we can rerun the same operation and `checkout_total` will increase by `1`.

For readability, let's substitute the `expression-attribute-names` and `expression-attribute-values` back into the `update-expression`:

```text
SET product_category = poem REMOVE category ADD checkout_total 1, subjects ["Trojan War"]
```

To summarize, using mutliple clauses in a DynamoDB `UpdateExpression` is supported by simply separating the clauses by keywords.

If you want to perform multiple operations using the same clause, use a comma (`,`) to separate them.

[1]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.UpdateExpressions.html
