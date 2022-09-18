---
description: Describe the syntax and value types used in config files.
---

# Config files

### Syntax

Config files consist of sections, and key-value pairs.

```
key 1 = value 1

section 1:
    key 2 = value 2
    key 3 = value 3

section 2:
    key 4 = value 4
```

The equal sign must have a one space character on both sides.

Keys and values can contain spaces in them.

Key-value pairs under a section must be indented by one tab character.

### Value Types

* `integer` can be `{..., -2, -1, 0, 1, 2, ...}`
* `integer pair` is two integers separated by a space: `640 480`
* `decimal` value can be an integer, optionally followed by a dot (decimal point) and up to 5 digits: `12.34567`
* `scale` is a decimal value with an `"x"` in front: `x0.25`
* `rgb` value is hexadecimal digits:
  * `0` is black, `f` is white.
  * `0` to `f` is grayscale.
  * `00` to `ff` is grayscale.
  * `000` to `fff` is RGB.
  * `000000` to `ffffff` is RRGGBB.
* `dice` value is an integer pair with a `"d"` in the middle: `3d8`
  * Integers must be greater than zero.
* `deviation` value is an integer pair: `2 3`
  * For `n`, the above value would produce the range `{n-2, ..., n+3}`

