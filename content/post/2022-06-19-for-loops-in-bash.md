---
author: Thomas Taylor
categories:
- programming
date: 2022-06-19 22:30:00-04:00
description: How to write a for loop in Bash
lastmod: 2022-06-19 23:45:00-04:00
tags:
- bash
title: For Loops in Bash
---

Using a `for` loop in Bash is simple! 

## for loop over strings

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

## for loop with range

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

## for loop with array

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

## for loop C-style

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

## for loop control statements: break & continue

### break statement

The `break` statement terminates the current loop.

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

### continue statement

The `continue` statement skips the current iteration and 'continues' to the next iteration. 

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