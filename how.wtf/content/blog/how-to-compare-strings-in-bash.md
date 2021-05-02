Title: How to Compare Strings in Bash
Date: 2021-05-02 11:00
Category: Programming
Tags: Bash
Authors: Thomas Taylor
Description: Bash string comparison: operators, string equality, substrings, etc.

Need to check if two strings are equal, check if a string contains a substring, or check if a string is empty? For Bash users, these are common questions and scenarios. 

# Comparison Operators

Comparison operators, as their name implies, allow for value comparisons that return true or false. Take a look at the different _string_ comparison operators for Bash:

Description|Example
- | -
is equal to | `[ str1 = str2 ]`
is equal to | `[[ str1 == str2 ]]`
is not equal to | `[ str1 != str2 ]`
is equal to regex | `[[ str1 =~ regex ]]`
is less than | `[[ str1 < str2 ]]`
is greater than | `[[ str1 > str2 ]]`
is null | `[ -z str1 ] (zero length)`
is not null | `[ -n str1 ]`

# Examples

Before diving into the examples, note that there are behavioral diffences between single brackets (`[`) and double brackets (`[[`).

1. `[` [is POSIX](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html)
2. `[[` [is a Bash extension](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-_005b_005b)

Key takeaways:

- The single bracket `[ expression ]` is syntactic sugar for `test expression`.
- `[[` is _generally_ considered safer to use
- `[` is more portable

You can find more information in this Stack Overflow [thread](https://stackoverflow.com/q/669452).

## Test if two strings are equal

```bash
#!/bin/bash

str1="hi"
str2="hi"

if [ "$str1" = "$str2" ]; then
    echo "Strings are equal."
fi
# Output: Strings are equal
```

```bash
#!/bin/bash

str1="hi"
str2="hi"

if [[ "$str1" = "$str2" ]]; then
    echo "Strings are equal."
fi
# Output: Strings are equal
```

