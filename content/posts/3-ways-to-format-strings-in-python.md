---
title: 3 ways to format strings in Python
date: 2021-04-21T01:25:00-04:00
author: Thomas Taylor
description: "There are several methods to answer the question: \"How to format strings in Python?\""
categories:
- Programming
tags:
- Python
---

In Python versions 3.6 and above, literal string interpolation receives the hype; however, did you know that there are several ways to format strings in Python?

# String Formatting (printf-style)

String objects have a built-in operation: the **%** operator (modulo).

If the operator is used once in a string, then a single non-tuple object may be used:
```python3
>>> "Ogres are like %s" % "onions"
'Ogres are like onions'
```
In this example, the conversion type, `%s` (string), will be replaced by "onions". 

Otherwise, the strings must be placed within a tuple of __exact length__ or a dictionary.

**Tuple**:
```python3
>>> "%s are like %s" % ("Ogres", "onions")
'Ogres are like onions'
```

**Dictionary**:
```python3
>>> "%(character)s are like %(vegetable)s" % {"character": "Ogres", "vegetable": "onions"}
'Ogres are like onions'
```

Additionally, there are flag characters and other types. To represent an integer, the type `%d` (for decimal) could be used. In the example below, `%d` was used in combination with the `0` flag character to add trailing zeros.
```python3
>>> "%03d - License to kill" % 7
'007 - License to kill'
```

More information can be found [here](https://docs.python.org/3/library/stdtypes.html#printf-style-string-formatting) about the printf-style string formatting.

# String Format Method

While the predecessor leveraged type conversions and flag characters, Python 3 introduced the `str.format(*args, **kwargs)` string method.

**Using positional arguments**:
```python3
>>> "{}, {}, {}".format("one", "two", "three")
'one, two, three'
```

**Using indices**:
```python3
>>> "{2}, {1}, {0}".format("apple", "orange", "cow")
'cow, orange, apple'
```

**Using repeated indices**:
```python3
>>> "{1}, it's {0}. Why {0}?".format(13, 'Naturally')
"Naturally, it's 13. Why 13?"
```

**Named arguments**:
```python3
>>> "{character} are like {food}".format(character="Ogres", food="onions")
'Ogres are like onions'
```

**Accessing arguments' items**:
```python3
>>> coord = (1, 5)
>>> "Plot the coordinate: ({0[0]}, {0[1]})".format(coord)
'Plot the coordinate: (1, 5)'
```

**Thousands separator**:
```python3
>>> "It's over {:,}!".format(9000)
"It's over 9,000!"
```

... and more format string syntax tricks [here](https://docs.python.org/3/library/string.html#format-string-syntax).

# Literal String Interpolation

Python 3.6 introduced literal string interpolation, also known as f-strings. F-strings allow you to embed expressions inside string constants.
```python3
>>> pet_name = "Toto"
>>> state = "Kansas"
>>> f"{pet_name}, I've a feeling we're not in {state} anymore."
"Toto, I've a feeling we're not in Kansas anymore"
```

F-strings are prefixed with the letter `f` and allow you to complete operations inline within the string.
```python3
>>> f"3 + 5 = {3+5}"
'3 + 5 = 8'
```

The existing syntax from the `str.format()` method can be used.
```python3
>>> f"It's over {9000:,}!"
"It's over 9,000!"
```
