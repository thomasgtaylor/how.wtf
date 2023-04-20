---
title: Function and method overloading in TypeScript
date: 2023-04-19T23:55:00-04:00
author: Thomas Taylor
description: How to implement function and method overloading in TypeScript
categories:
- Programming
tags:
- TypeScript
---

In Typescript, the declaration of an  `overload`  is defined by writing [overload signatures](https://www.typescriptlang.org/docs/handbook/2/functions.html#function-overloads).

> To do this, write some number of function signatures (usually two or more), followed by the body of the function

Be aware that the implementation signature type should be generic enough to include the overload signatures.

For example, an improper implementation signature:

```typescript
function fn(x: string): string;
// Return type isn't right
function fn(x: number): boolean;
// This overload signature is not compatible with its implementation signature.
function fn(x: string | number) {
  return  "oops";
}
```

## Function overloading

Define a `speak` function that accepts a `string` or a `number` in the signature.

```typescript
function speak(message: string): string;
function speak(num: number): string;
function speak(m: unknown) {
  if (typeof m === 'string') {
    return m;
  } else  if (typeof m === 'number') {
    return  `${m}`
  }
  throw  new  Error('Unable to greet');
}
console.log(speak(15)); // "15"
console.log(speak("a message")); // "a message"
```

In the implementation signature, `m` is of value `unknown` and covers _both_ overloaded signatures.

## Method overloading

Using the same technique as before, the `speak` method can be included in a class.

```typescript
class  Speaker {
  speak(message: string): string;
  speak(num: number): string;
  speak(m: unknown): unknown {
    if (typeof m === 'string') {
      return m;
    } else  if (typeof m === 'number') {
      return  `${m}`
    }
    throw  new  Error('Unable to greet');
  }
}
console.log(new  Speaker().speak(15));
console.log(new  Speaker().speak("a message"));
```
