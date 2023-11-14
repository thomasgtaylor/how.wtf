---
author: Thomas Taylor
categories:
- programming
date: 2023-04-10 23:50:00-04:00
description: How to implement enums in Golang
tags:
- go
title: Enums in Golang
---

GO does not natively support an `enum` keyword; however, an enum-like syntax can be implemented using the help of `iota`.

## What is `iota`?

`iota` is an identifier that auto increments constants.

In the following code, the constant number is manually incremented:

```go
const (
    ZERO = 0
    ONE = 1
    TWO = 2
)
```

however, it can be simplified to:

```go
const (
	ZERO = iota // 0
	ONE         // 1
	TWO         // 2
)
```

If desired, the `iota` keyword can be used on each line:

```go
const (
	ZERO = iota // 0
	ONE  = iota // 1
	TWO  = iota // 2
)
```

If a `const` keyword is used again, the `iota` will reset to 0.

```go
const (
	ZERO = iota // 0
	ONE         // 1
	TWO         // 2
)

const (
	ZEROAGAIN = iota // 0
	ONEAGAIN         // 1
	TWOAGAIN         // 2
)
```

## Implementing an enum in GO

Using a combination of `iota`, `int` and `const`, the concept of an `enum` can be applied.

```go
package main

import "fmt"

type PizzaSize int

const (
	SMALL  PizzaSize = iota + 1 // 1
	MEDIUM                      // 2
	LARGE                       // 3
)

func (s PizzaSize) String() string {
	return [...]string{"Small", "Medium", "Large"}[s-1]
}

func (s PizzaSize) Index() int {
	return int(s)
}

func main() {
	size := SMALL
	fmt.Println(size)          // Print : Small
	fmt.Println(size.String()) // Print : Small
	fmt.Println(size.Index())  // Print : 1
}
```