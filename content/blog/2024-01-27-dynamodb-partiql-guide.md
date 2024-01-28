---
author: Thomas Taylor
categories:
- cloud
- database
- programming
date: '2024-01-27T22:30:00-05:00'
description: This article covers how to use the PartiQL query language with DynamoDB
images:
- images/BdySwv.webp
tags:
- aws
- dynamodb
- serverless
title: 'DynamoDB PartiQL guide'
---

![DynamoDB and PartiQL logos in a simple architecture image](images/BdySwv.webp)

AWS [introduced a PartiQL in 2019][1] as a "query language for all your data" that resembles SQL-like expressions. In November 2020, it was [natively integrated with DynamoDB][2].

In this post, we'll explore using PartiQL with DynamoDB.

## What is PartiQL

[PartiQL is an open source initiative][3] that is maintained by Amazon under the Apache 2.0 license. Its goal is to be a SQL-compatible query language for accessing relational, semi-structured, and nested data.

Many AWS services support PartiQL:
- [Amazon DynamoDB][4]
- [Amazon Redshift][5]
- [Amazon QLDB (Quantum Ledger Database)][6]
- [AWS TwinMaker][7]

## Note about DynamoDB

While PartiQL introduces SQL-like expressions for DynamoDB, DynamoDB is a **NoSQL** database. Optimizing your access patterns, understanding key structure, using secondary indexes, and ensuring you're not scanning over large amounts of data is still required.

PartiQL cannot escape DynamoDB's rigidness - a simple SELECT statement can mistakenly scan over the entire table's data. Because of this, ensure you're using `WHERE` clauses appropriately.

## Creating a table using AWS CLI

Let's first create a table using the [many-to-many relationship model from AWS's documentation][8].

```shell
aws dynamodb create-table \
    --table-name ExampleTable \
    --attribute-definitions \
        AttributeName=pk,AttributeType=S \
        AttributeName=sk,AttributeType=S \
    --key-schema \
        AttributeName=pk,KeyType=HASH \
        AttributeName=sk,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5
```

This creates a table with a hash key of `pk` and a range key of `sk`.

## Inserting data using PartiQL

With our `ExampleTable` in AWS, let's insert a single row of mock data using the `INSERT INTO` operator:

```sql
INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92551','sk':'INVOICE#92551','date':'2018-02-07'}
```

Using the AWS CLI

```shell
aws dynamodb execute-statement \
    --statement "INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92551','sk':'INVOICE#92551','date':'2018-02-07'}"
```

## Transactions using PartiQL

For the next bit, we're going to use the `transactions` API. DynamoDB [restricts all transactions to the same operation][9]: either `read` or `write`. In our case, we're going to write all the following records:

```shell
aws dynamodb execute-transaction \
    --transact-statements \
        "{\"Statement\":\"INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92551','sk':'BILL#4224663','date':'2018-02-07'}\"}" \
        "{\"Statement\":\"INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92551','sk':'BILL#4224687','date':'2018-01-09'}\"}" \
        "{\"Statement\":\"INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92552','sk':'INVOICE#92552','date':'2018-03-04'}\"}" \
        "{\"Statement\":\"INSERT INTO ExampleTable VALUE {'pk':'INVOICE#92552','sk':'BILL#4224687','date':'2018-01-09'}\"}" \
        "{\"Statement\":\"INSERT INTO ExampleTable VALUE {'pk':'BILL#4224663','sk':'BILL#4224663','date':'2017-12-03'}\"}"
```

## Inserting data using PartiQL with parameters

For the last insertion, we'll use the `--parameters` option. Like SQL, we can use the `?` question mark syntax to denote a parameter.

```shell
aws dynamodb execute-statement \
    --statement "INSERT INTO ExampleTable VALUE {'pk':?,'sk': ?,'date':?}" \
    --parameters '[{"S":"BILL#4224687"},{"S":"BILL#4224687"},{"S":"2018-01-09"}]'
```

## Updating data using PartiQL

PartiQL only supports updating [a single item at a time][10]. Let's update the `BILL#4224663` item with a new attribute named `foo` with a value of `bar`.

```shell
aws dynamodb execute-statement \
    --statement "UPDATE ExampleTable SET foo='bar' WHERE pk='BILL#4224663' and sk='BILL#4224663'"
```

The statement above creates a new attribute named `foo` with a vlaue of `bar` on the item with a `pk` and an `sk` of `BILL#4224663`. Like the DynamoDB `put-item` API call, we must specify the hash and range key values in the `WHERE` clause.

The following error will happen if we don't specify both:

```text
An error occurred (ValidationException) when calling the ExecuteStatement operation: Where clause does not contain a mandatory equality on all key attributes
```

## Removing an attribute or field using PartiQL

PartiQL also supports removing attributes using the following syntax:

```shell
aws dynamodb execute-statement \
    --statement "UPDATE ExampleTable REMOVE foo WHERE pk='BILL#4224663' and sk='BILL#4224663'"
```

This removes the `foo` field we created in the last section.

## Query examples using PartiQL

[As documented by AWS][11], the supported `SELECT` syntax for PartiQL is the following:

```sql
SELECT expression  [, ...]
FROM table[.index]
[ WHERE condition ] [ [ORDER BY key [DESC|ASC] , ...]
```

**YOU MUST SPECIFY PARTITION KEYS IF YOU DO NOT WANT TO PERFORM A FULL TABLE SCAN**.

Using our table with its data from the prior examples, let's select `BILL#4224663`'s record:

```sql
SELECT *
FROM ExampleTable
WHERE pk = 'BILL#4224663' AND sk = 'BILL#4224663'
```

AWS CLI:

```shell
aws dynamodb execute-statement \
    --statement "SELECT * FROM ExampleTable WHERE pk = 'BILL#4224663' AND sk = 'BILL#4224663'"
```

Output:

```json
{
    "Items": [
        {
            "sk": {
                "S": "BILL#4224663"
            },
            "date": {
                "S": "2017-12-03"
            },
            "pk": {
                "S": "BILL#4224663"
            }
        }
    ]
}
```

We can additionally select multiple records:

```sql
aws dynamodb execute-statement \
    --statement "SELECT pk, sk FROM ExampleTable WHERE pk IN ['INVOICE#92551', 'INVOICE#92552']"
```

PartiQL will execute two DynamoDB queries on our behalf since it's searching for two `pk` values.

## Querying with begins_with in PartiQL

Similarly, we can use the DynamoDB `begins_with` functionality in PartiQL.

In the example below, we query for all bills associated with `INVOICE#92551`

```sql
SELECT *
FROM ExampleTable
where pk = 'INVOICE#92551' AND begins_with(sk, 'BILL#')
```

AWS CLI:

```shell
aws dynamodb execute-statement \
    --statement "SELECT * FROM ExampleTable where pk = 'INVOICE#92551' AND begins_with(sk, 'BILL#')"
```

Output:

```json
{
    "Items": [
        {
            "sk": {
                "S": "BILL#4224663"
            },
            "date": {
                "S": "2018-02-07"
            },
            "pk": {
                "S": "INVOICE#92551"
            }
        },
        {
            "sk": {
                "S": "BILL#4224687"
            },
            "date": {
                "S": "2018-01-09"
            },
            "pk": {
                "S": "INVOICE#92551"
            }
        }
    ]
}
```

## Protecting against scans using PartiQL

PartiQL, while powerful, can be dangerous.

Let's try to find items with a `date` attribute that is greater than `2018-01-09`.

```sql
SELECT *
FROM ExampleTable
WHERE "date" > '2018-01-09'
```

AWS CLI:

```shell
aws dynamodb execute-statement \
    --statement "SELECT * FROM ExampleTable WHERE \"date\" > '2018-01-09'"
```

Output:

```json
{
    "Items": [
        {
            "sk": {
                "S": "BILL#4224663"
            },
            "date": {
                "S": "2018-02-07"
            },
            "pk": {
                "S": "INVOICE#92551"
            }
        },
        {
            "sk": {
                "S": "INVOICE#92551"
            },
            "date": {
                "S": "2018-02-07"
            },
            "pk": {
                "S": "INVOICE#92551"
            }
        },
        {
            "sk": {
                "S": "INVOICE#92552"
            },
            "date": {
                "S": "2018-03-04"
            },
            "pk": {
                "S": "INVOICE#92552"
            }
        }
    ]
}
```

A seemingly harmless query just completed an entire table scan because it used a non-key attribute in the `WHERE` clause.

To protect against these kinds of queries, [AWS recommends using a][12] `DENY` IAM policy:

```json
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Deny",
         "Action":[
            "dynamodb:PartiQLSelect"
         ],
         "Resource":[
            "arn:aws:dynamodb:us-east-1:123456789012:table/ExampleTable"
         ],
         "Condition":{
            "Bool":{
               "dynamodb:FullTableScan":[
                  "true"
               ]
            }
         }
      },
      {
         "Effect":"Allow",
         "Action":[
            "dynamodb:PartiQLSelect"
         ],
         "Resource":[
            "arn:aws:dynamodb:us-east-1:123456789012:table/ExampleTable"
         ]
      }
   ]
}
```

## Deleting data using PartiQL

Like updating, PartiQL can only delete 1 item from a table at a time. 

We must specify all the keys associated with an item:

```shell
aws dynamodb execute-statement \
    --statement "DELETE FROM ExampleTable WHERE pk='INVOICE#92551' AND sk='BILL#4224663'"
```

## Conclusion

In this post, we went over how to insert, update, query, and delete data from DynamoDB using PartiQL. PartiQL is a fun way to query DynamoDB, but, as we discussed, can _easily_ turn into a DynamoDB killer with full table scans. 

[1]: https://aws.amazon.com/blogs/opensource/announcing-partiql-one-query-language-for-all-your-data/
[2]: https://aws.amazon.com/about-aws/whats-new/2020/11/you-now-can-use-a-sql-compatible-query-language-to-query-insert-update-and-delete-table-data-in-amazon-dynamodb/
[3]: https://partiql.org/
[4]: https://aws.amazon.com/about-aws/whats-new/2020/11/you-now-can-use-a-sql-compatible-query-language-to-query-insert-update-and-delete-table-data-in-amazon-dynamodb/
[5]: https://aws.amazon.com/about-aws/whats-new/2020/12/amazon-redshift-announces-support-native-json-semi-structured-data-processing/
[6]: https://aws.amazon.com/blogs/aws/now-available-amazon-quantum-ledger-database-qldb/
[7]: https://aws.amazon.com/about-aws/whats-new/2022/11/twinmaker-knowledge-graph-generally-available-aws-iot-twinmaker/
[8]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-adjacency-graphs.html#bp-adjacency-lists
[9]: https://docs.aws.amazon.com/cli/latest/reference/dynamodb/execute-transaction.html
[10]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-reference.update.html
[11]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-reference.select.html
[12]: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ql-iam.html#access-policy-ql-iam-example6
