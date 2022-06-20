---
title: For loops in Bash
date: 2022-06-19T22:30:00-04:00
author: Thomas Taylor
description: How to write a for loop in Bash
categories:
- Programming
tags:
- Bash
---

Using a `for` loop in Bash is simple! 

# for loop over strings

```bash
for i in "follow" "the" "white" "rabbit"; do
    echo "${i}"
done
```

```text
follow
the
white
rabbit
```

# for loop with range

```bash
for i in {0..2}; do
    echo "${i}"
done
```

```text
0
1
2
```

> `bash` 4 added an increment parameter for ranges

```bash
for i in {0..6..2}; do
    echo "${i}"
done
```

```text
0
2
4
6
```

# for loop with array

```bash
a=("fried" "green" "tomatoes")
for i in ${a[@]}; do
    echo "${i}"
done
```

```text
fried
green
tomatoes
```

# for loop C-style

```bash
for (( i = 0; i <= 3; i++ )); do
    echo "${i}"
done
```

```text
0
1
2
3
```

# for loop control statements: break & continue

## break statement

```bash
for i in "first" "second" "break" "third"; do
    if [[ "${i}" == "break" ]]; then
        break
    fi
    echo "${i}"
done
```

```text
first
second
```

## continue statement

```bash
for i in "first" "second" "break" "third"; do
    if [[ "${i}" == "break" ]]; then
        continue
    fi
    echo "${i}"
done
```

```text
first
second
third
```
