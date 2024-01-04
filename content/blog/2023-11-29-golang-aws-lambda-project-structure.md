---
author: Thomas Taylor
categories:
- programming
date: 2023-11-29T01:45:00-05:00
description: This article describes my method for structuring AWS Lambda projects with GO
images:
- images/yI9Hqu.webp
tags:
- go
title: Golang AWS Lambda project structure
---

![how to structure a Golang AWS Lambda project](images/yI9Hqu.webp)

AWS Lambda is an easy-to-use serverless offering that enables developers to quickly deploy code without worrying about maintenance, orchestration, scaling, etc. It's simple to get started and its free tier is generous!

## Golang project structure

GO does not have a recommended project structure. In fact, keeping a project structure flat is preferrable for small apps:

```text
project/
├── go.mod
├── go.sum
├── user.go
└── main.go
```

My personal preference is to use the flat structure for small apps or a combination of `internal` + `cmd`:

```text
project/
├── cmd
│   └── app1
│       └── main.go
├── go.mod
├── go.sum
└── internal
    └── user.go
```

### What is the internal module

The `internal` module can only be imported from packages rooted at the parent of the internal folder. In other words, the `internal` folder is "private" or non-existent outside the package. It reduces API surface area and establishes a clear domain boundary that [is enforced by GO][1].

### What is the cmd module

The `cmd` directory is [a common convention][2] I prefer for organizing sub-apps into runnable binaries. For example, a larger project may have multiple "apps" required to run it:

```text
store/
├── cmd
│   ├── api
│   │   └── main.go
│   ├── frontend
│   │   └── main.go
│   └── worker
│       └── main.go
├── go.mod
├── go.sum
└── internal
    ├── cart.go
    ├── product.go
    └── user.go
```

Each "app" within the `cmd` directory will have a distributable binary that can be invoked with required / optional flags. For example, the `frontend` binary may have a `-port` flag. The intention of the `main.go` files are to be **THIN** entry points that delegate the heavy processing to the `internal` layer.

It's common for a simple `main.go` to look like this:

```go
package main

import (
    "github.com/user/repo/internal"
)

func main() {
    c := internal.NewClient()
    c.DoSomething()
}
```


## Golang AWS Lambda project structure

Following the prior convention, lambdas can be similary nested in the `cmd` directory:

```text
project/
├── cmd
│   ├── function1
│   │   └── main.go
│   └── function2
│       └── main.go
├── go.mod
├── go.sum
└── internal
    └── user.go
```

With very **THIN** `main.go` entry handlers:

```go
package main

import (
    "github.com/aws/aws-lambda-go/lambda"

    "github.com/user/repo/internal"
)

func HandleRequest() error {
    c := internal.NewClient()
    c.DoSomething()
}

func main() {
    lambda.Start(HandleRequest)
}
```

If `cmd` doesn't fit your use case, creating another folder is __completely__ fine:

```text
project/
├── lambda 
│   ├── function1
│   │   └── main.go
│   └── function2
│       └── main.go
├── go.mod
├── go.sum
└── internal
    └── user.go
```

Even having separate `cmd` and `lambda` folders to distinguish between CLI-invocable apps and Lambda-invocable apps is fine.

The main point is keeping the `main.go` entry points thin.

## Golang AWS Lambda project structure with CDK

For my use-case, I kept the lambda handlers nested within the `cmd` directoy. In addition, I created a `deploy` app for the CDK that contains the stack-creation.

```text
project/
├── cdk.json
├── cmd
│   ├── function1
│   │   └── main.go
│   └── infrastructure
│       └── main.go
├── go.mod
├── go.sum
└── internal
    └── s3.go
```

The `cdk.json` is simple:

```json
{
  "app": "go mod download && go run cmd/deploy/main.go"
}
```

[1]: https://go.dev/doc/go1.4#internalpackages
[2]: https://github.com/golang-standards/project-layout#cmd
