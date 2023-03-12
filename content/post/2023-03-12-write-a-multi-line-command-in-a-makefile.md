---
title: Write a multi-line command in a Makefile
date: 2023-03-12T09:45:00-04:00
author: Thomas Taylor
description: How to write a multi-line command in a Makefile
categories:
- Programming
tags:
- Makefile
---

Occasionally, there is a need for adding multiple continuous lines for one target in a Makefile.

## Writing multiple lines for a target

Executing multiple commands in a target is trivial:

```makefile
test:
	@echo 1
	@echo 2
```

Output:

```text
1
2
```

However, each line is executed in its own shell. If a continuous line is needed, the following rules must be applied:

1. Use `$$` instead of `$`
2. Terminate each line using a semicolon `;`
3. Add a trailing backslash at the ending of the line `\`

```makefile
test:
	var1=test; \
	echo $$var1
```

Output:

```text
var1=test; \
echo $var1
test
```

### A real use case using multi-line targets

For `how.wtf`, the CI/CD process invalidates a CloudFront distribution via id.

For context, the `aws` dependency verifies that `aws` is executable prior to the command execution. More information on that [here](https://how.wtf/check-if-a-program-exists-from-a-makefile.html).

```makefile
.PHONY: invalidate
invalidate: aws
	distribution_id=$$(aws cloudfront list-distributions --query "DistributionList.Items[?starts_with(Origins.Items[0].DomainName, '$(BUCKET)')].Id" --output text); \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*" \
		--query "Invalidation.Id" \
		--output text
```

```text
distribution_id=$(aws cloudfront list-distributions --query "DistributionList.Items[?starts_with(Origins.Items[0].DomainName, 'how.wtf')].Id" --output text); \
aws cloudfront create-invalidation \
	--distribution-id $distribution_id \
	--paths "/*" \
	--query "Invalidation.Id" \
	--output text
ID6WOFMWKLCYDYRUA6AGPXXXXX
```

### Writing multiple lines using `ONESHELL`

The `ONESHELL` [directive](https://www.gnu.org/software/make/manual/html_node/One-Shell.html) allows multiple lines to executed in the same shell; however, special characters like `@`, `-`, and `+` are interpreted differently.

```makefile
.ONESHELL:
test:
	var1=test
	echo $$var1
```

Output:

```text
var1=test
echo $var1
test
```