---
author: Thomas Taylor
categories:
- os
date: 2023-02-23 23:15:00-04:00
description: How to play sounds, music, or audio from the Linux terminal
tags:
- linux
title: Play sounds or music from Linux terminal
---

Playing music or sounds from the command line is simple with Sound eXchange (`SoX`). It supports many audio file types: **mp3**, **wav**, **ogg**, etc.

## What is `SoX`?

As described by its man page, Sound eXchange is the Swiss Army knife of audio manipulation. It's a cross platform command line utility used to convert, apply affects, record, or play audio files.

## How to play audio from the terminal

1. Install `sox` using your package manager with all the encoders.

   For Ubuntu:

   ```shell
   sudo apt-get update
   ```

   ```shell
   sudo apt-get install sox libsox-fmt-all
   ```

2. After the installation is complete, use the `play` command to play an audio file.

   ```shell
   play filename.mp3
   ```