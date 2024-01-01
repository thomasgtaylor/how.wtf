---
author: Thomas Taylor
categories:
- blogging
date: '2023-12-31T22:55:00-05:00'
description: 
images:
- images/HJEK0h.png
tags:
- analytics
title: 'Goatcounter for blog analytics'
---

Going into 2024, I wanted to minimize the footprint of [how.wtf][1].

This included:

1. Removing ads
2. Removing giscus, the commenting system
3. Removing **Google Analytics**
4. Reducing the website's size to [less than 20kb][2]
5. Changing the theme to be super minimal with a focus on content

I have nothing against Google Analytics; I simply wanted something with less impact on my website's loading speeds. Additionally, GDPR compliance requires companies using Google Analytics to gain explicit user consent for data collection. Personally, I just want a simple analytics - not a full-blown suite of tools.

## What is Goatcounter

After careful consideration, I chose [Goatcounter][3]. It's a minimal, opensource analytics tool that is easy to configure, privacy-aware, and lightweight. Like Google Analytics, I easily integrated it using a single script:

```html
<script data-goatcounter="https://yoursite.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>
```

It provides a streamlined interface that gives exactly what I'm looking for:

![image of goatcounter analytics for how.wtf](images/HJEk0H.png)

## Why I chose Goatcounter

Philosophically, I prefer minimalism. Goatcounter met my preferences and provided a _streamlined_ integration and set up process. After a few clicks to setup my account, I immediately had analytics flowing. There's always the option to self-host in the future, which is awesome!

To summarize here are my top reasons:

1. Open-source
2. Dead simple UI
3. Small (~3.5kb script)
4. Privacy-first
5. [Seemingly GDPR compliant][4]
6. Self-hosted option
7. API is _easy_ to use if I ever need to
8. JavaScript-free options such as [pixel tracking][5] or [logfile parsing][6]

[1]: https://how.wtf
[2]: https://512kb.club/
[3]: https://www.goatcounter.com/
[4]: https://www.goatcounter.com/help/gdpr#conclusion-306
[5]: https://www.goatcounter.com/help/pixel
[6]: https://www.goatcounter.com/help/logfile
