---
title: Ternary operator in Bash
date: 2021-05-02T1:35:00-04:00
author: Thomas Taylor
description: "Many languages support a ternary operator: a short-form if/else statement for in-place conditional. This functionality can be mimicked in Bash."
categories:
- Programming
tags:
- Bash
---

The ternary operator is a form of syntactic sugar for an in-line if/else statement. Many languages natively support the operator:

**JavaScript:**

```javascript
const color = 'blue';
console.log(color === 'blue' ? '🟦' : '🟩');
// Output: 🟦
```

**Python:**

```python
color = "blue"
print("🟦" if color == "blue" else "🟩")
# Output: 🟦
```

**C:**

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char color[4] = "blue";
    printf("%s", (strcmp(color, "blue") == 0) ? "🟦" : "🟩");
}
// Output: 🟦
```

# Ternary Operation

Bash does not have a native ternary operator. Instead, the same functionality can be achieved using:

```bash
color="blue"
[[ "$color" == "blue" ]] && echo "🟦" || echo "🟩"
# Output: 🟦
```

`[[ "$color" == "blue" ]]` has an exit status of **0**, so it evaluates the right expression of the `&&` and echoes the blue emoji.

Similarly, if `color="green"`, the `[[ "$color" == "blue" ]]` expression would have a nonzero exit status, so it evaluates the next logical statement (`||`) and echos the green emoji.

## Saving to a variable

```bash
color="blue"
emoji=$([[ "$color" == "blue" ]] && echo "🟦" || echo "🟩")
echo $emoji
# Output: 🟦
```

## ⚠️ Caution

If the right-hand side of the `&&` condition has a nonzero exit status, it will silently default to the or (`||`) expression.

`[[ cond ]] && op1 || op2` ➜ `op2` will be selected if `op1` fails. 

**Takeaway**: Be mindful of the `op1` operation. Ensure it exits with a 0 status code, or you may receive a false negative.
