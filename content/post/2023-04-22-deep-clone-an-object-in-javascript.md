---
author: Thomas Taylor
categories:
- programming
date: 2023-04-22 22:15:00-04:00
description: How to deep clone an object in JavaScript
tags:
- javascript
title: Deep clone an object in JavaScript
---

Deep cloning an object in JavaScript was natively added in [Node 17](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone#browser_compatibility).

## Deep clone an object using `structuredClone`

Deepling cloning an object is completed using `structuredClone`.

```javascript
const a = {
  col1: 'val1',
  col2: {
      nestedObjected: {
          col1: 'val1'
      }
  }
}

const b = structuredClone(a);
console.log(b); 
// {"col1":"val1","col2":{"nestedObjected":{"col1":"val1"}}}
```

## Deep clone an object using `JSON`

If the `structuredClone` method is not available and the user does _not_ want to add an external library, using `JSON` may satisfy the requirement. If the following types are not used:

- `Date`
- `undefined`
- `Infinity`
- Regular expressions
- Maps
- Sets
- Blobs
- other compex types within an object

a simple one liner may be sufficient.

```javascript
const a = {
  col1: 'val1',
  col2: {
      nestedObjected: {
          col1: 'val1'
      }
  }
}

const b = JSON.parse(JSON.stringify(a))
console.log(b); 
// {"col1":"val1","col2":{"nestedObjected":{"col1":"val1"}}}
```