---
author: Thomas Taylor
categories:
- programming
date: 2023-02-10 00:00:00-04:00
lastmod: 2024-03-06T23:05:00-5:00
description: How to get earliest or latest moment from a day in Python
tags:
- python
title: How to get start or end of a day in Python
---

In Python, `datetime` natively handles getting the earliest/latest moment of a given day using the `combine` function.

## Get the start of a day

```python3
from datetime import datetime, time

start_of_day = datetime.combine(datetime.now(), time.min)
print(start_of_day) # 2023-02-10 00:00:00
```

## Get the end of a day

```python3
from datetime import datetime, time

end_of_day = datetime.combine(datetime.now(), time.max)
print(end_of_day) # 2023-02-10 23:59:59.999999
```
