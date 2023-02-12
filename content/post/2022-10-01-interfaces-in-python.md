---
title: Interfaces in Python
date: 2022-10-01T15:30:00-04:00
author: Thomas Taylor
description: How to implement or create interfaces in Python
categories:
- Programming
tags:
- Python
---

Python does not have the traditional `interface` keyword as seen in other programming languages. Instead, the language supports ducktyping and multiple inheritance which may satisfy the need for interfaces for some use cases.

However, there are native pythonic methods to create / implement an interface.

## Ducktyping 

If it quacks like a duck and walks like a duck, Python assumes it's a duck:

```python
from dataclasses import dataclass

@dataclass
class User:
    id: str
    name: str

class UserService:
    def get_user_by_id(self, id: str) -> User:
        """Retrieve user by ID"""
        pass

class Database(UserService):
    def get_user_by_id(self, id: str) -> User:
        """Retrieves user by ID from an database"""
        # Implementation goes here
        pass

class Cache(UserService):
    def get_user_by_id(self, id: str) -> User:
        """Retrieves user by ID from cache"""
        # Implementation goes here
        pass
```

Due to the lack of enforcement, this paradigm may not scale well for the implementer's needs.

## Abstract Base Classes

Introduced in Python 2.6, abstract base classes allow for interface creation.

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass

@dataclass
class User:
    id: str
    name: str

class UserService(ABC):
    @abstractmethod
    def get_user_by_id(self, id: str) -> User:
        """Retrieve user by ID"""
        raise NotImplementedError

class Database(UserService):
    def get_user_by_id(self, id: str) -> User:
        """Retrieves user by ID from a database"""
        # Implementation goes here
        pass
```

This covers two cases:

1. The inheriting class _must_ implement the abstract method
2. The implementation cannot instantiate this parent's method: `super().get_user_by_id(id)`
