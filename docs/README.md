---
description: Describe the syntax and value types used in these files.
---

# Config files

### Syntax

Config files consist of sections, and key-value pairs.

```
key 1 = value 1

section:
    key 2 = value 2
    key 3 = value 3
```

The equal sign must have a one space character on both sides.

Key-value pairs under a section must be indented by one tab character.

### Value Types

* `integer` can be `{..., -2, -1, 0, 1, 2, ...}`
* `decimal` values can be integers, optionally followed by a dot (decimal point) and up to 5 digits.

