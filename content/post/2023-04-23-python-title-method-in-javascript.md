---
author: Thomas Taylor
categories:
- programming
date: 2023-04-23 23:25:00-04:00
description: How to implement the Python title method in JavaScript
tags:
- javascript
title: Python title method in JavaScript
---

What is the equivalent for the Python string `title` method in JavaScript? Python's native `str.title()` method returns a string with title-casing— i.e. the first letter of each word is capitalized.

## `str.title()` method in JavaScript

Unfortunately, JavaScript does not contain a standardized `str.title()` method; however, a function can be created that implements equivalent behavior.

In Python, here are a few examples of the `str.title()` method:

```python
print("WeIrD cAsInG".title()) # Weird Casing
print("HELLO WORLD".title()) # Hello World
print("nospaceHERE".title()) # Nospacehere
print("there's a snake in my boot".title()) # There'S A Snake In My Boot
```

This is an equivalent JavaScript implementation:

```javascript
function title(str) {
  return str.toLowerCase().split(' ').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
}

console.log(title("WeIrD cAsInG")); // Weird Casing
console.log(title("HELLO WORLD")); // Hello World
console.log(title("nospaceHERE")); // Nospacehere
console.log(title("there's a snake in my boot")); // There'S A Snake In My Boot
```