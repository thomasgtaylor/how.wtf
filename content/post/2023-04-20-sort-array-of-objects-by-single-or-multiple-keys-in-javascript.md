---
title: Sort array of objects by single or multiple keys in JavaScript
date: 2023-04-20T23:45:00-04:00
author: Thomas Taylor
description: How to sort an array of objects by a single or multiple keys in JavaScript
categories:
- Programming
tags:
- JavaScript
---

In TypeScript or JavaScript, sorting an array of objects is made easy in ES6/ES2015.

Given an array of objects named `people`, sort them based on different criteria.

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

## Sorting an array of objects by a single key

### Sort ascending by number

```javascript
// sort ascending by id
people.sort((a, b) => a.id - b.id)
```

### Sort ascending by string

```javascript
// sort ascending by firstName
people.sort((a, b) => a.firstName.localeCompare(b.firstName))
```

### Sort descending by number

```javascript
// sort descending by id
people.sort((a, b) => b.id - a.id)
```

### Sort descending by string

```javascript
// sort descending by firstName
people.sort((a, b) => b.firstName.localeCompare(a.firstName))
```

## Sorting array of objects by multiple keys

If a secondary key is needed for additional sorting, the same `sort` method can be used.

```javascript
people.sort(
    (a, b) => a.firstName.localeCompare(b.firstName) ||
    a.lastName.localeCompare(b.lastName)
);
```

the or logical operator `||` chains multiple sort options.
