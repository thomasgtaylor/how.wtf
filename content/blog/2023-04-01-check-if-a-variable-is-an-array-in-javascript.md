---
author: Thomas Taylor
categories:
- programming
date: 2023-04-01 23:20:00-04:00
description: How to check if a variable is an array in JavaScript
tags:
- javascript
title: Check if a variable is an array in JavaScript
---

In TypeScript or JavaScript, checking if a variable is an array can be completed in two ways.

## Using the `Array.isArray()`

Using the native `Array.isArray()` method, a boolean will be returned.

```javascript
const names = ["sally", "billy", "mary"];
const notAnArray = 'str';
console.log(Array.isArray(names)); // true
console.log(Array.isArray(notAnArray)); // false
```

## Using the `instanceOf` operator

As an alternative option, `instanceOf` will yield the same results.

```javascript
const names = ["sally", "billy", "mary"];
const notAnArray = 'str';
console.log(names instanceof Array); // true
console.log(notAnArray instanceof Array); // false
```