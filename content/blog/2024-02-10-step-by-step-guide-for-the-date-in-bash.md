---
author: Thomas Taylor
categories:
- programming
date: '2024-02-10T22:00:07-05:00'
description: How to get or print the date in a Bash script using the date command.
tags:
- bash
title: 'Step by step guide for the date in Bash'
---

Unix provides a utility named `date`. As its name implies, it allows you to fetch your system's date.

## Display the current date

Displaying the current date is simple:

```bash
echo $(date)
```

Output:

```text
Sat Feb 10 21:29:37 EST 2024
```

The system date was printed with the timezone information.

## Display the current date in UTC

Similarly, we can display the current date in UTC (Coordinated Universal Time) using the `-u` flag:

```bash
echo $(date -u)
```

Output:

```text
Sun Feb 11 02:31:06 UTC 2024
```

The datetime was printed with the UTC timezone information.

## Format the current date

The default `date` output can easily be formatted in a bash script:

```bash
now="$(date '+%Y-%m-%d')"
echo $now
```

Output:

```text
2024-02-10
```

The `date` manual page [showcases all the formatting options][1] available.

## Getting a date from days ago

Using the `-d` or `--date` option, we can display a different date:

```bash
now="$(date -d '2 days ago' '+%Y-%m-%d')"
echo $now
```

Output:

```text
2024-02-08
```

For MacOS users, use the `-v` option:

```bash
now="$(date -v-2d '+%Y-%m-%d')"
echo $now
```

## ISO-8601 date in Bash

In 2011, the `-I` or `--iso-8601` [option was reintroduced][2] to the `date` utility.

```bash
now="$(date -Iseconds)"
echo $now
```

Output:

```text
2024-02-11T02:47:41+00:00
```

For MacOS users, the `-I` option does not exist. You must format instead:

```bash
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo $now
```

Output:

```text
2024-02-11T02:54:53Z
```

## Comparing two dates in Bash

Using `-d` to convert the dates to unix timestamp, we can compare them.

```bash
dateOne=$(date -d 2022-02-10 +%s)
dateTwo=$(date -d 2021-12-12 +%s)

if [ $dateOne -ge $dateTwo ]; then
    echo "woah!"
fi
```

For MacOS users, the equivalent option is:

```bash
dateOne=$(date -j -f "%F" 2022-02-10 +"%s")
dateTwo=$(date -j -f "%F" 2021-12-12 +"%s")

if [ $dateOne -ge $dateTwo ]; then
    echo "woah!"
fi
```

[1]: https://man7.org/linux/man-pages/man1/date.1.html
[2]: https://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=2f1384b7
