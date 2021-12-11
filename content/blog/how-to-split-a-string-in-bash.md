Title: How to split a string in bash
Date: 2021-12-11 2:30
Category: Programming
Tags: Bash
Authors: Thomas Taylor
Description: How do I split a string in bash based on a delimiter?

Splitting a string in `bash` is easy with the help of the [internal field separator][1] (`IFS`). 

# Bash string split using `IFS`

```bash
string="you got a friend in me"
IFS=' ' read -ra split <<< "$string"
echo "${split[*]}"
# Output: you got a friend in me
echo "${split[3]}"
# Output: friend
```

The above method does not interfere with the `IFS` global variable since it's only set for that single invocation.

[1]: https://en.wikipedia.org/wiki/Input_Field_Separators
