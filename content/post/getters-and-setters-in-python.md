---
title: Getters and setters in Python
date: 2023-04-14T23:45:00-04:00
author: Thomas Taylor
description: How to write getter and setter methods in Python.
categories:
- Programming
tags:
- Python
---

Writing getter and setter methods in Python is seamless using the [`@property` decorator](https://docs.python.org/3/library/functions.html#property).

## Using the `@property` decorator for getter and setter methods

Directly from the documentation:

```python
class C(object):
    def __init__(self):
        self._x = None

    @property
    def x(self):
        """I'm the 'x' property."""
        print("getter of x called")
        return self._x

    @x.setter
    def x(self, value):
        print("setter of x called")
        self._x = value

    @x.deleter
    def x(self):
        print("deleter of x called")
        del self._x


c = C()
c.x = 'foo'  # setter called
foo = c.x    # getter called
del c.x      # deleter called
```

An implementation of this method could be a product where a user can set a price _after_ its instantiation. 

```python
class Product:
    def __init__(self, name):
        self._name = name

    @property
    def price(self):
        return self._price

    @price.setter
    def price(self, new_price):
        if new_price < 0 or not isinstance(new_price, float):
            raise Exception("price must be greater than 0 and a float")
        self._price = new_price

    @price.deleter
    def price(self):
        del self._price


p1 = Product("one")
p1.price = 5.5
```
