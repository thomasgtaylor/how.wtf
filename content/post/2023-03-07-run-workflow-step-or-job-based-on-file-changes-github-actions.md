---
title: Run workflow, step, or job based on file changes GitHub Actions
date: 2023-03-07T08:50:00-04:00
author: Thomas Taylor
description: How to catch errors in Boto3 with Python
categories:
- Cloud
tags:
- Github Actions
---

There are options for conditionally running GitHub actions at the workflow, job, or step level based on file changes.

## Trigger GitHub Action workflow on file changes

GitHub actions natively support triggering workflows based on file changes:

```yaml
on:
  push:
    paths:
    - 'src/**'

jobs:
  job1:
    steps:
    - uses: actions/checkout@v3
    - name: tests
      run: ...
```

On a push to any file within the `src/**` directory, this workflow will execute job1 and its steps.

## Run job based on file changes in GitHub Actions

GitHub actions do not natively support triggering jobs based on file changes; however, there is a marketplace action that supports this use-case named [dorny/paths-filter](https://github.com/dorny/paths-filter).

```yaml
on:
  push:
    branches:
    - main

jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      src: ${{ steps.changes.outputs.src }}
      infra: ${{ steps.changes.outputs.infra }}
    steps:
    - uses: actions/checkout@v3
    - uses: dorny/paths-filter@v2
      id: changes
      with:
        filters: |
          src:
            - 'src/**'
          infra:
            - 'infra/**'

  src:
    needs: changes
    if: ${{ needs.changes.outputs.src == 'true' }}
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - run: ...

  infra:
    needs: changes
    if: ${{ needs.changes.outputs.infra == 'true' }}
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - run: ...
```

On a push to the `main` branch, this workflow will execute; however, the first action checks where changes occurred and outputs `true` or `false` for the specified filtered paths.

## Run step based on file changes in GitHub Actions

Similarly to jobs, GitHub actions to not natively support triggering individual steps based on file changes. [dorny/paths-filter](https://github.com/dorny/paths-filter) supports this use-case as well.

```yaml
on:
  push:
    branches:
    - main

jobs:
  job1:
    steps:
    - uses: actions/checkout@v3
    - uses: dorny/paths-filter@v2
      id: changes
      with:
        filters: |
          src:
            - 'src/**'
          infra:
            - 'infra/**'
            
    - name: src deploy
      if: steps.changes.outputs.src == 'true'
      run: ...
      
    - name: infra deploy
      if: steps.changes.outputs.infra == 'true'
      run: ...
    
    - name: e2e
      if: steps.changes.outputs.src == 'true' || steps.changes.outputs.infra == 'true'
      run: ...
```

## Pull requests

On a side note, [dorny/paths-filter](https://github.com/dorny/paths-filter) does _not_ need the checkout action for pull request triggered actions.

```yaml
on:
  pull_request:
    branches:
    - main

jobs:
  build:
    runs-on: ubuntu-latest
    # For pull requests, it's not necessary to checkout code
    permissions:
      pull-requests: read
    steps:
    - uses: dorny/paths-filter@v2
      id: filter
      with:
        filters: ... # Configure your filters
```
