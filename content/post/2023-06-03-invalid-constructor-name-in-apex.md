---
title: Invalid constructor name error in Apex
date: 2023-06-03T12:45:00-04:00
author: Thomas Taylor
description: What is the invalid constructor name error in Apex?
categories:
- Programming
tags:
- Apex
---

When deploying apex classes, a user may run into an odd error: `Error: Compile Error: Invalid constructor name`.

## How to solve `Invalid constructor name`

Upon initial inspection, this error may be misleading. The class in question contains a working constructor _or_ a new method was added that is __not__ a constructor.

**What gives?**

Normally, this error indicates that a new method was added without adding the return type.

Example:

```apex
public class Foo {

    private String bar;

    public Foo(String bar) {
        this.bar = bar;
    }

    public newMethod() {
        // logic
    }
}
```

To fix this, simply add the return type to the method:

```apex
public class Foo {

    private String bar;

    public Foo(String bar) {
        this.bar = bar;
    }

    // added void return type
    public void newMethod() {
        // logic
    }
}
```

## Why does this error happen?

When a return type is omitted, the method is interpreted as a constructor because constructors do not contain return types.
