---
description: Contains UI settings.
---

# ui.cfg

In this file, integers represent pixels.

The value type `size` is an integer pair where the first integer is on the x-axis, and the second integer is on the y-axis.

In the screen coordinate system:

* `+x` moves to the right.
* `-x` moves to the left.
* `+y` moves downwards.
* `-y` moves upwards.

#### Contents

`active color = rgb`

^ For radio buttons, this is the colour of the chosen button.

`button: background color = rgb`

^ Rectangles of buttons are filled with this colour.

`button: border color = rgb`

^ Colour of the borders around button rectangles. Useless if `button: border width = 0`

`button: border width = integer`

^ Draws borders around rectangles of buttons.

`button: click dent = size`

^ When holding down the left mouse-button, the button under it is nudged by this amount.

`button: padding = size`

^ The text inside the button has an offset by this amount, relative to the top-left corner of the surrounding rectangle.

`button: spacing = integer`

^ Spacing between multiple related buttons (like radio buttons).

`font file = string`

^ Path to a `.ttf` file relative to the `.exe` file.

`screen margin = size`

^ Margin between the game window and UI elements inside it.

`section spacing = size`

^ Some UI elements are grouped together to form sections. This is the spacing between them.

`text: color = rgb`

^ Colour of all the text on screen, except `active color`

`text: size = integer`

^ Pixel height of all text. This depends on the font file used.

`text: spacing = size`

^ Distance between the lines of text.

`window size = size`

^ Size of the game window.
