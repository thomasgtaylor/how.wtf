---
author: Thomas Taylor
categories:
- programming
date: 2023-04-03 23:35:00-04:00
description: How to calculate or determine the midpoint between two dates in JavaScript
tags:
- javascript
title: Calculate the middle between two dates in JavaScript
---

In TypeScript or JavaScript, determining the midpoint between two dates is easy using the native `Date` library.

## Determine the middle between two dates

```javascript
const startDate = new Date('Mar 10 2023');
const endDate = new Date('Mar 15 2023');

const midDate = new Date((startDate.getTime() + endDate.getTime()) / 2);
console.log(midDate) // 2023-03-12T12:00:00.000Z
```

In the example above, `getTime()` returns the number of seconds since epoch. Adding the seconds and dividing by two gives the midpoint.