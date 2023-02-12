---
title: How to Set Default Audio in Ubuntu
date: 2022-06-27T02:10:00-04:00
author: Thomas Taylor
description: How to set default audio in Ubuntu on startup using pactl
categories:
- OS
tags:
- Linux
---

Using the `pactl` command, setting default audio in Ubuntu is straightforward. For startup persistence, Ubuntu Startup Applications comes in handy.

`pactl` is the cli entry for the PulseAudio sound server and will be used in this tutorial.

## List all input and output audio

List audio outputs:

```text
pactl list short sinks
```

```text
1	alsa_output.pci-0000_06_00.6.HiFi__hw_Generic__sink	module-alsa-card.c	s16le 2ch 48000Hz	RUNNING
```

List audio inputs:

```text
pactl list short sources
```

```text
1	alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2019_02_24_60522-00.analog-stereo	module-alsa-card.c	s16le 2ch 44100Hz	SUSPENDED
2	alsa_input.pci-0000_06_00.6.HiFi__hw_Generic__source	module-alsa-card.c	s16le 2ch 44100Hz	SUSPENDED
3	alsa_input.pci-0000_06_00.6.HiFi__hw_acp__source	module-alsa-card.c	s32le 2ch 48000Hz	SUSPENDED
```

Take note of the devices listed in the output.

## Set default input and output audio

Command to set default audio output:

```text
pactl set-default-sink <device>
```

Example usage:

```text
pactl set-default-sink alsa_output.pci-0000_06_00.6.HiFi__hw_Generic__sink
```

Command to set default audio input:

```text
pactl set-default-source <device>
```

Example usage:

```text
pactl set-default-source alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2019_02_24_60522-00.analog-stereo
```

## Persist command on start/restart

Persisting audio input: 

1. Open the application named "Startup Applications" (should be preinstalled)
2. Click "Add" button in the upper right hand corner
3. Enter a command name such as: "Set default audio output" in the `Name:` field
4. Place the `pactl set-default-sink <device>` command in the `Command:` field
5. Click "Add" button in the bottom right hand corner of the prompt

Persisting audio output:

1. Click "Add" button in the upper right hand corner
2. Enter a command name such as: "Set default audio input" in the `Name:` field
3. Place the `pactl set-default-source <device>` command in the `Command:` field
4. Click "Add" button in the bottom right hand corner of the prompt
