---
title: Conditionally add properties to an object in JavaScript
date: 2023-03-08T08:45:00-04:00
author: Thomas Taylor
description: How to conditionally add properties or fields or members to an object in JavaScript or TypeScript
categories:
- Programming
tags:
- JavaScript
---

Conditionally adding properties/fields/members to an object in JavaScript or TypeScript can be completed using a combination of the logical and spread operators or simply an `if` statement.

## Add conditional properties using `if`

A simple technique is using an if statement to conditionally add members:

```javascript
let obj = {}
if (condition)
  obj.field = 5;
```

There are no thrills to this technique, but it's straight forward.

## Add conditional properties using logical and spread operators

For a shorter syntax, ES5 introduced the ability to do this:

```javscript
const obj = {
  ...(condition && {field: 5})
}
```

This technique works due to how logical operators function in JavaScript.

```javascript
console.log(true && {field: 5})
```

The snippet above is processed as follows: starting from left and traversing right, the first operand that is evaluated as `falsy` is returned. In the expression above, there are no `falsy` operands so the right-most is returned.

The output:

```text
{field: 5}
```

Additionally, the `spread` operator has a lower precedence than the `&&` operator because the underlying implementation uses `Object.assign()`

If the condition is false:

```javascript
const obj = {
  val: 2,
  ...(false && {field: 5})
}
console.log(obj)
```

The spread operation will be result in nothing being added.

```text
{val:2}
```