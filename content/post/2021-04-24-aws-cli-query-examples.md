---
author: Thomas Taylor
categories:
- cloud
date: 2021-04-24 15:30:00-04:00
description: AWS CLI provides native json filtering functionality using the query option.
tags:
- aws
- aws-cli
title: AWS CLI query examples
---

While some users may prefer to pipe AWS CLI JSON output to `jq` for parsing, it is possible to leverage the `--query` functionality that's built-in. 

Commonly, users deal with large JSON outputs when executing AWS CLI commands in their environments. To mitigate the process, [JMESPath](https://jmespath.org), a powerful filtering language, can specify resource properties, create lists, search output, etc.

## AWS CLI Output

For reference, the AWS CLI documentation lists JSON document outputs. The commands listed below use `aws ec2 describe-images`, but any combination of the examples can be used for other services and properties.

```shell
aws ec2 describe-images \
    --region us-east-1 \
    --image-ids ami-1234567890EXAMPLE
```

Output ([provided by AWS](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html#examples)):

```json
{
    "Images": [
        {
            "VirtualizationType": "hvm",
            "Description": "Provided by Red Hat, Inc.",
            "PlatformDetails": "Red Hat Enterprise Linux",
            "EnaSupport": true,
            "Hypervisor": "xen",
            "State": "available",
            "SriovNetSupport": "simple",
            "ImageId": "ami-1234567890EXAMPLE",
            "UsageOperation": "RunInstances:0010",
            "BlockDeviceMappings": [
                {
                    "DeviceName": "/dev/sda1",
                    "Ebs": {
                        "SnapshotId": "snap-111222333444aaabb",
                        "DeleteOnTermination": true,
                        "VolumeType": "gp2",
                        "VolumeSize": 10,
                        "Encrypted": false
                    }
                }
            ],
            "Architecture": "x86_64",
            "ImageLocation": "123456789012/RHEL-8.0.0_HVM-20190618-x86_64-1-Hourly2-GP2",
            "RootDeviceType": "ebs",
            "OwnerId": "123456789012",
            "RootDeviceName": "/dev/sda1",
            "CreationDate": "2019-05-10T13:17:12.000Z",
            "Public": true,
            "ImageType": "machine",
            "Name": "RHEL-8.0.0_HVM-20190618-x86_64-1-Hourly2-GP2"
        }
    ]
}
```

Please note `Images` is a top-level list-type element in the JSON document.

## Examples

**Warning**: The AWS `describe-images` commands outputs a large JSON document. The JMESPath [list slicing](https://jmespath.org/tutorial.html#list-and-slice-projections) (`Images[:3]`) feature is leveraged to truncate the results. If the full output is desired, use `Images[]` instead.

### Listing Outputs

**List the `ImageId` of the first 3 images owned by Amazon:**

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[:3].ImageId"
[
    "aki-04206613",
    "aki-0a4aa863",
    "aki-12f0127b"
]
```

**Note:** `Images[:3].ImageId` outputs the property into a single list. If a list for each image is desired, use `Images[:3].[ImageId]`. As shown in the next example, it's useful for listing multiple properties.

**List the `ImageId` and `OwnerId` of the first 3 images owned by Amazon:**

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[:3].[ImageId,OwnerId]"
[
    [
        "aki-04206613",
        "137112412989"
    ],
    [
        "aki-0a4aa863",
        "470254534024"
    ],
    [
        "aki-12f0127b",
        "470254534024"
    ]
]
```

**List the `ImageId` and `OwnerId` of the first 3 images owned by Amazon in a list of JSON objects:**

If desired, the output values can be nested in a hash object using JMESPath's [hash multi-selection](https://jmespath.org/tutorial.html#multiselect) feature.

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[:3].{image:ImageId,owner:OwnerId}"
[
    {
        "image": "aki-04206613",
        "owner": "137112412989"
    },
    {
        "image": "aki-0a4aa863",
        "owner": "470254534024"
    },
    {
        "image": "aki-12f0127b",
        "owner": "470254534024"
    }
]
```

### Filter Projection & Pipe Expressions

**List the `ImageId` of the first 3 images that are owned by Amazon's `OwnerId` of `137112412989`:**

JMESPath provides two features needed to accomplish this query:

1. [Filter Projection](https://jmespath.org/tutorial.html#filter-projections)
2. [Pipe Expressions](https://jmespath.org/tutorial.html#pipe-expressions)

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[?OwnerId=='137112412989'] | [:3].ImageId"
[
    "aki-04206613",
    "aki-499ccb20",
    "aki-5c21674b"
]
```

The combination of a filter projection, `Images[?OwnerId=='137112412989']`, and a pipe expression, `| [:3].ImageId` satisfies the requirement.

Here's the Python code representing the filter projection operation:

```python3
result = []
for image in inputData['Images']:
  if image['OwnerId'] == '137112412989'
    result.append(image)
return result
```

It returns:

```json
[
    {
        "ImageId": "aki-04206613",
        "OwnerId": "137112412989",
        "..."
    },
    {
        "ImageId": "aki-499ccb20",
        "OwnerId": "137112412989",
        "..."
    },
    {
        "ImageId": "aki-5c21674b",
        "OwnerId": "137112412989",
        "..."
    },
    "...",
    "...",
    "..."
]
```

Then, grab the first three using the pipe expression:

`| [:3]`

```json
[
    {
        "ImageId": "aki-04206613",
        "OwnerId": "137112412989",
        "..."
    },
    {
        "ImageId": "aki-499ccb20",
        "OwnerId": "137112412989",
        "..."
    },
    {
        "ImageId": "aki-5c21674b",
        "OwnerId": "137112412989",
        "..."
    }
]
```

Then, add the specific `ImageId` property:

`| [:3].ImageId`

```json
[
    "aki-04206613",
    "aki-499ccb20",
    "aki-5c21674b"
]
```

### Function Expressions

JMESPath supports function expressions:

**List the `Id` and `CreationDate` of the first 3 images that are owned by Amazon whose `PlatformDetails` contain the string 'Linux' in sorted order by `CreationDate`:** 

Step #1: Use the `contains` function and grab the first 3 results:

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[?contains(PlatformDetails, 'Linux')] | [:3]"
[
    {
        "CreationDate": "2016-09-28T21:31:10.000Z",
        "ImageId": "aki-04206613",
        "PlatformDetails": "Linux/UNIX",
        "..."
    },
    {
        "CreationDate": "2009-12-15T18:44:15.000Z",
        "ImageId": "aki-0a4aa863",
        "PlatformDetails": "Linux/UNIX",
        "..."
    },
    {
        "CreationDate": "",
        "ImageId": "aki-12f0127b",
        "PlatformDetails": "Linux/UNIX",
        "..."
    }
]
```

This filters the top-level `Images` for all objects with `Linux` in their `PlatformDetails` value.

Step #2: Sort by `CreationDate`:

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[?contains(PlatformDetails, 'Linux')] | [:3] | sort_by(@, &CreationDate)[].{CreationDate:CreationDate,Id:ImageId}"
```

The `sort_by` function requires an input similar to this:
```json
KeyNameHere: [
    {
        "key1": "val1",
        "key2": "val2"
    }
]
```

If results were ordered by the `key2` field, the query would be:
`sort_by(KeyNameHere, &key2)`

Similarly, the input to the `sort_by` function in the example was:
```json
[
    {
        "CreationDate": "2016-09-28T21:31:10.000Z",
        "ImageId": "aki-04206613",
        "PlatformDetails": "Linux/UNIX",
        "..."
    },
    { "..." },
    { "..." }
]
```

There is not a top-level key present. In this case, the character `@` is used to represent the list that is being passed. Additionally, the key that is being sorted on must begin with an `&`.

After the `sort_by` function, the list is "retrieved" `[]` and the result is formatted to a customized JSON output.

```json
[
    {
        "CreationDate": "",
        "Id": "aki-12f0127b"
    },
    {
        "CreationDate": "2009-12-15T18:44:15.000Z",
        "Id": "aki-0a4aa863"
    },
    {
        "CreationDate": "2016-09-28T21:31:10.000Z",
        "Id": "aki-04206613"
    }
]
```

The first object contains a null `CreationDate` value. Luckily, it can be removed from the output using the `not_null` function.

```shell
$ aws ec2 describe-images \
  --owner amazon \
  --query "Images[?contains(PlatformDetails, 'Linux')] | [:4] | @[?not_null(CreationDate)] | sort_by(@, &CreationDate)[].{CreationDate:CreationDate,Id:ImageId}"
[
    {
        "CreationDate": "2009-12-15T18:44:15.000Z",
        "Id": "aki-0a4aa863"
    },
    {
        "CreationDate": "2010-09-28T03:52:22.000Z",
        "Id": "aki-1c669375"
    },
    {
        "CreationDate": "2016-09-28T21:31:10.000Z",
        "Id": "aki-04206613"
    }
]
```

Lastly, a common scenario is to filter based on environment variables:

**Retrieve a cloudformation export by name and store the value**
```shell
$ export_name=$(aws cloudformation list-exports \
    --query "Exports[?Name=='$ENV_VAR'].Value" \
    --output text)
$ echo $export_name
value_here
```

The environment variable was used by wrapping with single quotes!
