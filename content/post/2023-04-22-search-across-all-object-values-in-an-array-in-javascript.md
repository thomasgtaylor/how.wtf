---
title: Search across all object values in an array in JavaScript 
date: 2023-04-22T11:45:00-04:00
author: Thomas Taylor
description: How to search across all object values in an array JavaScript
categories:
- Programming
tags:
- JavaScript
---

If there is a need to search across all object values in an array in JavaScript, a combination of `filter`, `entries`, and `some` can be used.

## How to search across object values

In a frontend data table, rows may contain information about people:

```javascript
const people = [
  {
    "id": 5,
    "firstName": "Buzz",
    "lastName": "Lightyear2"
  },
  {
    "id": 2,
    "firstName": "Buzz",
    "lastName": "Lightyear"
  },
  {
    "id": 1,
    "firstName": "Woody",
    "lastName": "Pride"
  },
  {
    "id": 3,
    "firstName": "Potato",
    "lastName": "Head"
  },
  {
    "id": 4,
    "firstName": "Slinky",
    "lastName": "Dog"
  }
];
```

To provide a "search" across all of the values, use the following:

```javascript
const query = "Slinky".toLowerCase();
const results = people.filter(o => Object.entries(o).some(e => String(e[1]).toLowerCase().includes(query)));
console.log(results); // [ { id: 4, firstName: 'Slinky', lastName: 'Dog' } ]
```

If `id` or other fields are not preferable in the search, use the `rest` operator.

```javascript
const query = "Slinky".toLowerCase();
const results = people.filter(o => {
  const { id, ...rest } = o;
  return Object.entries(rest).some(e => String(e[1]).toLowerCase().includes(query))
});
console.log(results); // [ { id: 4, firstName: 'Slinky', lastName: 'Dog' } ]
```
