---
title: Use virtualenv with a Python Jupyter notebook
date: 2023-06-08T23:50:00-04:00
author: Thomas Taylor
description: How to use a virtualenv with a Python Jupyter notebook 
categories:
- Programming
tags:
- Python
---

Using a virtual environment with a Jupyter notebook is easy!

## Install and use `virtualenv`

For instructions on installing, using, and activating `virtualenv`, refer to my blog article [here](https://how.wtf/using-virtualenv-with-python.html).

**NOTE**: You may use your virtual environment of choice.

## Add `virtualenv` environment to Jupyter notebook 

1. Activate the virtual environment
2. Install `ipykernel`

  ```shell
  pip3 install ipykernel
  ```

3. Use the `ipykernel install` command

  ```shell
  python3 -m ipykernel install --user --name=venv # this name can be anything
  ```

4. Open `jupyter-lab` and click on the environment labeled `venv`

The `ipykernel install` command uses the current environment when creating the kernel.
