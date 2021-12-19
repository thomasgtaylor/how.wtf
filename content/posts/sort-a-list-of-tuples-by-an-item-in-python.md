---
title: Sort a list of tuples by an item in Python
date: 2021-05-08T23:00:00-04:00
author: Thomas Taylor
description: It's possible to sort a list of tuples by an indexed value using Python's native sort functions.
categories:
- Programming
tags:
- Python
---

Python has native `sort` capabilities available for use. You can sort a list of objects by leveraging one of the method specified below.

The questions that this post addresses:

1. **Q:** How do you sort a list of tuples by the 1st item? 
2. **Q:** How do you sort a list of tuples by the 2nd item?
3. **Q:** How do you sort a list of tuples in reverse?

# sorted() function

The `sorted()` function returns a sorted iterable object, such as a list, in a specified order. It does **not** modify the list in place.

By default, the `sorted()` function evaluates the items to determine their order. In the example below, the lexical ordering of the 1st index determines the sorted list.

```python3
lst = [("val2", 2), ("val1", 1)]
print(sorted(lst))
# Output: [('val1', 1), ('val2', 2)]
```

If the 1st elements are identical, the 2nd element determines the ordering:

```python3
lst = [("val1", 2), ("val1", 1)]
print(sorted(lst))
# Output: [('val1', 1), ('val2', 2)]
```

You can optionally specify an index to sort on using a lambda function:

```python3
lst = [("val2", 2), ("val1", 1)]
print(sorted(lst, key=lambda x: x[1]))
# Output: [('val1', 1), ('val2', 2)]
```

Reverse as well:

```python3
lst = [("val2", 2), ("val1", 1)]
print(sorted(lst, key=lambda x: x[1], reverse=True))
# Output: [('val2', 2), ('val1', 1)]
```

Using `itemgetter` instead of `lambda`:

```python3
from operator import itemgetter
lst = [("val1", 1), ("val2", 2)]
print(sorted(lst, key=itemgetter(1), reverse=True))
# Output: [('val2', 2), ('val1', 1)]
```

# list.sort() function

The `list.sort()` method sorts a list **in place** and does **not** return a value.

Similar to the `sorted()` function, it uses the lexical ordering of the 1st index to determine the sorted list.

```python3
lst = [("val2", 2), ("val1", 1)]
lst.sort()
print(lst)
# Output: [('val1', 1), ('val2', 2)]
```

If the 1st elements are identical, the 2nd element determines the ordering:

```python3
lst = [("val1", 2), ("val1", 1)]
lst.sort()
print(lst)
# Output: [('val1', 1), ('val2', 2)]
```

You can optionally specify an index to sort on using a lambda function:

```python3
lst = [("val2", 2), ("val1", 1)]
lst.sort(key= lambda x: x[1])
print(lst)
# Output: [('val1', 1), ('val2', 2)]
```

Reverse as well:

```python3
lst = [("val1", 1), ("val2", 2)]
lst.sort(key= lambda x: x[1], reverse=True)
print(lst)
# Output: [('val2', 2), ('val1', 1)]
```

Using `itemgetter` instead of `lambda`:

```python3
from operator import itemgetter
lst = [("val1", 1), ("val2", 2)]
lst.sort(key=itemgetter(1), reverse=True)
print(lst)
# Output: [('val2', 2), ('val1', 1)]
```
