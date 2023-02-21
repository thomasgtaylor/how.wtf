---
title: Using Virtualenv with Python
date: 2021-07-10T21:15:00-04:00
author: Thomas Taylor
description: How to use virtualenv with Python 3 to create virutal environments.
categories:
- Programming
tags:
- Python
---

## What is Virtualenv?

Virtualenv is a tool used for creating isolated Python environments. It allows multiple Python environments/projects to coexist on the same computer with their own dependencies, python versions, and pip versions.

## How to install Virtualenv

Using Python's package manager, `pip` or `pip3`, virtualenv can be installed with a single command:

```shell
pip install --user virtualenv
```

Optionally, you can install it for all users:

```shell
pip install virtualenv
```

## How do I create a new virtualenv environment?

Simply navigate to the project directory and use the `virtualenv` cli command with a name for the environment (`venv` in this case):

```shell
$ cd ~/projects/myproject
$ virtualenv venv
created virtual environment CPython3.8.5.final.0-64 in 1993ms
  creator CPython3Posix(dest=/home/user/projects/myproject, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=/home/user/.local/share/virtualenv)
    added seed packages: pip==21.0.1, setuptools==56.0.0, wheel==0.36.2
  activators BashActivator,CShellActivator,FishActivator,PowerShellActivator,PythonActivator,XonshActivator
``` 

This creates a new folder named `venv` in the project directory.

## How do I use/activate a virtualenv (venv) environment?

To activate the virtualized environment, run the following command from the project directory:

On Linux / MacOS:

```shell
source venv/bin/activate
```

On Windows:

```shell
.\venv\Scripts\activate
```

With the isolated environment activated, any `pip install packagename` will be contained within the directories of the virtualized environment.

## How do I deactivate a virtualenv (venv) environment?

Simply type the following command to deactivate:

```shell
deactivate
```
