---
author: Thomas Taylor
categories:
- programming
date: 2023-03-29 12:50:00-04:00
description: How to match everything between two characters using Regex
tags:
- regex
title: Match everything between two characters in Regex
---

Matching everything between two delimiters in Regex is supported. In the examples below, the `[` and `]` characters were used as example delimiters.

## Match between characters using lookahead / lookbehind

Using lookbehind and lookahead, the following patterns will match between two delimiters:

```text
(?<=\[)(.*?)(?=\])
```

Using [regex101](https://regex101.com/r/RBo7NU/1), the explanation can summarized as:

> Match the non-greedy capture group `(.*?)` that is preceded by a `[` and is followed by `]` but do not capture the delimiters.

## Match between characters without lookahead / lookbehind

Without using lookbehind or lookahead, the following pattern will match contents between two delimiters _including_ the delimiters:

```text
\[(.*?)\]
```

Here is the [regex101](https://regex101.com/r/2BZJ4u/1) link.

To remove the delimiters, the first captured group of each match will need to be used.