---
author: Thomas Taylor
categories:
- cloud
- os
date: 2023-12-09T13:45:00-05:00
description: A guide on how to open a Github pull request from the command line
images:
- images/usbOAk.webp
tags:
- github
title: Open a GitHub pull request using the command line
---

![How to create a github pull requesting from the command line](images/usbOAk.webp)

After pushing changes to a remote repository, a common next step is creating a pull request for your team members to review. In this article, we'll discuss how to open a pull request from the command line using the GitHub CLI.

## What is the GitHub CLI

The GitHub CLI is a tool that allows users to interact with GitHub directly from the terminal. It simplifies and streamlines GitHub workflows, enabling users to issue pull requests, check issues, clone repositories, etc., without leaving the terminal.

## How to open a PR from the terminal

Opening a PR from the command line is straightforward using the `gh` CLI.

### Install the GitHub CLI

To begin, install the GitHub CLI using the [installation instructions][1].

For MacOS, the `brew` package manager is an easy option:

```shell
brew install gh
```

### Authenticate the GitHub CLI

After the GitHub CLI is installed, authenticate using the following command:

```shell
gh auth login
```

If you're having trouble, follow the [instructions provided by the GitHub team here][2] for more options.

### Open a pull request from the terminal

The following opens an interactive experience for your current branch:

```shell
gh pr create
```

### Create a pull request in the browser from the terminal

If you prefer opening pull requests in the web version, the CLI can direct you to it:

```shell
gh pr create --web
```

### Create a pull request using a template from the terminal

If your organization requires using a PR template, this is supported as well:

```shell
gh pr create --template <file>
```

### Create a draft pull request from the terminal

If you want to create a draft pull request, the GitHub CLI has you covered:

```shell
gh pr create --draft
```

### Create a pull request using a title and body from the terminal

The CLI supports explicitly defining the `--title` and `--body`:

```shell
gh pr create --title "Some title" --body "Some body"
```

### Create a pull request for a different branch from the terminal

You may want to create a PR for a different branch using the CLI. This is covered as well:

```shell
gh pr create --base main --head feature-branch
```

## Conclusion

To wrap up, using the GitHub CLI can significantly boost your workflow. I encourage you to explore this tool – it's like having a superpower right in your terminal.

[1]: https://github.com/cli/cli#installation
[2]: https://cli.github.com/manual/gh_auth_login
