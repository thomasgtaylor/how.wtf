---
title: Check if a variable is an array in JavaScript
date: 2023-01-01T23:20:00-04:00
author: Thomas Taylor
description: How to check if a variable is an array in JavaScript
categories:
- Programming
tags:
- JavaScript
---

In TypeScript or JavaScript, checking if a variable is an array can be completed in two ways:

## Using the `Array.isArray()`

Using the native `Array.isArray()` method will yield a boolean result:

```javascript
const names = ["sally", "billy", "mary"];
const notAnArray = 'str';
console.log(Array.isArray(names)); // true
console.log(Array.isArray(notAnArray)); // false
```

## Using the `instanceOf` operator

Using the `instanceOf` operator is another option:

```javascript
const names = ["sally", "billy", "mary"];
const notAnArray = 'str';
console.log(names instanceof Array); // true
console.log(notAnArray instanceof Array); // false
```
