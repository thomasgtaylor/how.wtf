---
title: Spread operator in Python
date: 2021-04-28T1:00:00-04:00
author: Thomas Taylor
description: JavaScript provides a spread operator for unpacking elements of iterable objects. The same functionality can be achieved in Python.
categories:
- Programming
tags:
- Python
---

The JavaScript spread operator `(...)` is a useful and convenient syntax for expanding iterable objects into function arguments, array literals, or other object literals. 

Python contains a similar "spread" operator that allows for iterable unpacking. Each of the examples below will demonstrate the comparison between the two languages.

## Function Arguments

JavaScript:
```javascript
function multiply(a, b) {
    return a * b;
}
const numbers = [3, 5];
console.log(multiply(...numbers));
// Output: 15
```

Python:
```python
def multiply(a, b):
    return a * b
numbers = [3, 5]
print(multiply(*numbers))
# Output: 15
```

## Array Literals
```javascript
const numbers = [1, 2, 3];
const newNumbers = [0, ...numbers, 4]
console.log(newNumbers);
// Output: [ 0, 1, 2, 3, 4 ]
```

```python
numbers = [1, 2, 3]
new_numbers = [0, *numbers, 4]
print(new_numbers)
# Output: [0, 1, 2, 3, 4]
```

## Object Literals

```javascript
const testObj = { foo: 'bar' };
console.log({ ...testObj, foo2: 'bar2' });
// Output: { foo: 'bar', foo2: 'bar2' }
```

A very similar technique can be applied with Python dictionaries. Notice the double asterisk operator (`**`).
```python
test_obj = { 'foo': 'bar' }
print({ **test_obj, 'foo2': 'bar2' })
# Output: {'foo': 'bar', 'foo2': 'bar2'}
```

To unpack keyword arguments, the double asterisk operator (`**`) is used. In contrast, the single asterisk operator (`*`) is used for iterable objects.
