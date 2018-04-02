# lua-resty-imagick

Lua bindings to ImageMagick's
[MagicWand](http://www.imagemagick.org/script/magick-wand.php) for
LuaJIT using FFI.

Reimplement [magick](https://github.com/leafo/magick)

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Installation](#installation)
* [Basic Usage](#basic-usage)
* [Authors](#authors)
* [Copyright and License](#copyright-and-license)

Status
======
This library is under early development.

Installation
============

You'll need both LuaJIT (any version) and MagickWand.


To use ImageMagick, you might run:

On Ubuntu

```bash
$ sudo apt-get install libmagickwand-dev
```

On Centos

```bash
$ sudo yum install ImageMagick ImageMagick-devel
```

On MacOS
```bash
$ brew install imagemagick
```

It's recommended to use opm to install **lua-resty-imagick**.

```bash
$ opm install lua-resty-imagick
```
[Back to TOC](#table-of-contents)

Basic Usage
===========

If you just need to resize/crop an image, use the `thumb` function. It provides
a shorthand syntax for common operations.

```lua
local magick = require("resty.imagick")
magick.thumb("input.png", "100x100", "output.png")
```

The second argument to `thumb` is a size string, it can have the following
kinds of values:


```lua
"500x300"       -- Resize image such that the aspect ratio is kept,
                --  the width does not exceed 500 and the height does
                --  not exceed 300
"500x300!"      -- Resize image to 500 by 300, ignoring aspect ratio
"500x"          -- Resize width to 500 keep aspect ratio
"x300"          -- Resize height to 300 keep aspect ratio
"50%x20%"       -- Resize width to 50% and height to 20% of original
"500x300#"      -- Resize image to 500 by 300, but crop either top
                --  or bottom to keep aspect ratio
"500x300+10+20" -- Crop image to 500 by 300 at position 10,20
```

If you need more advanced image operations, you'll need to work with the
`Image` object. Read on.

Functions
=========

All functions contained in the table returned by `require("resty.imagick")`.

`thumb(input_fname, size_str, out_fname=nil)`
-----

Loads and resizes image. Write output to `out_fname` if provided, otherwise
return image blob. (`input_fname` can optionally be an instance of `Image`)

`load_image(fname)`
-----

Return a new `Image` instance, loaded from filename. Returns `nil` and error
message if image could not be loaded.

`load_image_from_blob(blob)`
-----

Loads an image from a Lua string containing the binary image data.

`Image` object
==============

Calling `load_image` or `load_image_from_blob` returns an `Image` object.


```lua
local magick = require "resty.imagick"

local img = assert(magick.load_image("hello.png"))

print("width:", img:get_width(), "height:", img:get_height());

img:resize(200, 200)
img:write("resized.png")
```

Images are automatically freed from memory by LuaJIT's garbage collector, but
images can take up a lot of space in memory when loaded so it's recommended to
call `destroy` on the image object as soon as possible.

Load ImageMagick directly:

```lua
magick = requrie "resty.imagick.wand"
local img = magick.load_image("some_image.png")
```

Methods
=======

Methods mutate the current image when appropriate. Use `clone` to get an
independent copy.

`img:resize(w,h, f="Lanczos2", blur=1.0)`
-----

Resizes the image, `f` is resize function, see [Filer Types](http://www.imagemagick.org/api/MagickCore/resample_8h.html#a12be80da7313b1cc5a7e1061c0c108ea)

`img:adaptive_resize(w,h)`
-----

Resizes the image using [adaptive resize](http://imagemagick.org/Usage/resize/#adaptive-resize)

`img:crop(w,h, x=0, y=0)`
-----

Crops image to `w`,`h` where the top left is `x`, `y`

`img:blur(sigma, radius=0)`
-----

Blurs the image with specified paramaters. See [Blur Arguments](http://www.imagemagick.org/Usage/blur/#blur_args)

`img:rotate(degrees, r=0, g=0, b)`
-----

Rotates the image by specified number of degrees. The image dimensions will
enlarge to prevent cropping. The triangles on the corners are filled with the
color specified by `r`, `g`, `b`. The color components are specified as
floating point numbers from 0 to 1.

`img:sharpen(sigma, radius=0)`
-----

Sharpens the image with specified parameters. See [Sharpening Images](http://www.imagemagick.org/Usage/blur/#sharpen)

`img:resize_and_crop(w,h)`
-----

Resizes the image to `w`,`h`. The image will be cropped if necessary to
maintain its aspect ratio.

`img:get_blob()`
-----

Returns Lua string containing the binary data of the image. The blob is
formatated the same as the image's current format (eg. PNG, Gif, etc.). Use
`image:set_format` to change the format.

`img:write(fname)`
-----

Writes the the image to disk

`img:get_width()`
-----

Gets the width of the image

`img:get_height()`
-----

Gets the height of the image

`img:get_format()`
-----

Gets the current format of image as a file extension like `"png"` or `"bmp"`.
Use `image:set_format` to change the format.

`img:set_format(format)`
-----

Sets the format of the image, takes a file extension like `"png"` or `"bmp"`

`img:get_quality()`
-----

Gets the image compression quality.

`img:set_quality(quality)`
-----

Sets the image compression quality.

`img:get_gravity()`
-----

Gets the image gravity type.

`img:set_gravity(gravity)`
-----

Sets the image's gravity type:

`gravity` can be one of the values listed in [data.lua](https://github.com/kwanhur/lua-resty-imagick/blob/master/lib/resty/imagick/wand/data.lua#L81)

`img:get_option(magick, key)`
-----

Returns all the option names that match the specified pattern associated with a
image (e.g `img:get_option("webp", "lossless")`)

`img:set_option(magick, key, value)`
-----

Associates one or options with the img (e.g `img:set_option("webp", "lossless", "0")`)

`img:scale(w, h)`
-----

Scale the size of an image to the given dimensions.

`img:coalesce()`
-----

Coalesces the current image by compositing each frame on the previous frame.
This un-optimized animated images to make them suitable for other methods.

`img:composite(source, x, y, compose)`
-----

Composite another image onto another at the specified offset `x`, `y`.

`compose` can be one of the values listed in [data.lua](https://github.com/kwanhur/lua-resty-imagick/blob/master/lib/resty/imagick/wand/data.lua#L10)

`img:strip()`
-----

Strips image of all profiles and comments, useful for removing exif and other data

`r,g,b,a = img:get_pixel(x, y)`
-----

Get the r,g,b,a color components of a pixel in the image as doubles from `0` to `1`

`img:clone()`
-----

Returns a copy of the image.

`img:modulate(brightness=100, saturation=100, hue=100)`
-----

Adjust the brightness, saturation, and hue of the image. See [Modulate Brightness, Saturation, and Hue](http://www.imagemagick.org/Usage/color_mods/#modulate)

`img:thumb(size_str)`
-----

Mutates the image to be a thumbnail. Uses the same size string format described
at the top of this README.

`img:destroy()`
-----

Immediately frees the memory associated with the image, it is invalid to use the
image after calling this method. It is unecessary to call this method normally
as images are tracked by the garbage collector.

`img:animate(server_name)`
-----
Animates an image or image sequence.

`img:black_threshold(threshold)`
-----
Like MagickThresholdImage() but forces all pixels below the threshold into black 
while leaving all pixels above the threshold unchanged.

`img:border(border_color, width, height, compose)`
-----
Surrounds the image with a border of the color defined by the bordercolor pixel wand.

`img:charcoal(sigma, radius)`
-----
Simulates a charcoal drawing.

`img:chop(width, height, x, y)`
-----
Removes a region of an image and collapses the image to occupy the removed portion.

`img:clamp()`
-----
Restricts the color range from 0 to the quantum depth.

`img:clip()`
-----
Clips along the first path from the 8BIM profile, if present.

`img:clip_path(path, inside)`
-----
Clips along the named paths from the 8BIM profile, if present. Later operations take effect 
inside the path. Id may be a number if preceded with #, to work on a numbered path, e.g., "#1" to use the first path.

`img:comment(comment)`
-----
Adds a comment to your image.

`img:contrast(sharpen)`
-----
Enhances the intensity differences between the lighter and darker elements of the image. 
Set sharpen to a value other than 0 to increase the image contrast otherwise the contrast is reduced.

`img:contrast_stretch(black_point, white_point)`
-----
Enhances the contrast of a color image by adjusting the pixels color to span the entire range of colors available. 
You can also reduce the influence of a particular channel with a gamma value of 0.

`img:cycle_colormap(displace)`
-----
Displaces an image's colormap by a given number of positions. 
If you cycle the colormap a number of times you can produce a psychodelic effect.

`img:constitute(columns, rows, map, storage, pixels)`
-----
Adds an image to the wand comprised of the pixel data you supply. The pixel data must be in scanline order top-to-bottom. 
The data can be char, short int, int, float, or double. Float and double require the pixels to be normalized [0..1], 
otherwise [0..Max], where Max is the maximum value the type can accomodate (e.g. 255 for char). 

`img:decipher(passphrase)`
-----
Converts cipher pixels to plain pixels.

`img:deconstruct()`
-----
Compares each image with the next in a sequence and returns the maximum bounding region of any pixel differences it discovers.

`img:deskew(threshold)`
-----
Removes skew from the image. Skew is an artifact that occurs in scanned images because of the camera being misaligned, 
imperfections in the scanning or surface, or simply because the paper was not placed completely flat when scanned.

`img:despeckle()`
-----
Reduces the speckle noise in an image while perserving the edges of the original image.

`img:display(server_name)`
-----
Displays an image.

`img:display_multi(server_name)`
-----
Displays an image or image sequence.

`img:distort(method, num_args, args, bestfit)`
-----
Distorts an image using various distortion methods, by mapping color lookups of the source image to a new destination 
image usally of the same size as the source image, unless 'bestfit' is set to true.

If 'bestfit' is enabled, and distortion allows it, the destination image is adjusted to ensure the whole source 'image' 
will just fit within the final destination image, which will be sized and offset accordingly. 
Also in many cases the virtual offset of the source image will be taken into account in the mapping.

`img:draw(draw)`
-----
Renders the drawing wand on the current image.

`img:edge(radius)`
-----
Enhance edges within the image with a convolution filter of the given radius. 
Use a radius of 0 and Edge() selects a suitable radius for you.

`img:emboss(radius, sigma)`
-----
Returns a grayscale image with a three-dimensional effect. We convolve the image with a Gaussian operator of the given 
radius and standard deviation (sigma). For reasonable results, radius should be larger than sigma. 
Use a radius of 0 and Emboss() selects a suitable radius for you.

`img:encipher(passphrase)`
-----
Converts plaint pixels to cipher pixels.

`img:enhance()`
-----
Applies a digital filter that improves the quality of a noisy image.

`img:equalize()`
-----
Equalizes the image histogram.

`img:evaluate(operator, value)`
-----
Applys an arithmetic, relational, or logical expression to an image. Use these operators to lighten or darken an image, 
to increase or decrease contrast in an image, or to produce the "negative" of an image.

`img:export_pixels(x, y, columns, rows, map, storage, pixels)`
-----
Extracts pixel data from an image and returns it to you. 
The method returns MagickTrue on success otherwise MagickFalse if an error is encountered. 
The data is returned as char, short int, int, ssize_t, float, or double in the order specified by map.

Suppose you want to extract the first scanline of a 640x480 image as character data in red-green-blue order:
img:export_pixels(0, 0, 640, 1, "RGB", "Char", pixels)

`img:extent(w, h, x, y)`
-----
Extends the image as defined by the geometry, gravity, and wand background color. Set the (x,y) offset of the geometry 
to move the original wand relative to the extended wand.

[Back to TOC](#table-of-contents)

Authors
=======

kwanhur <huang_hua2012@163.com>, VIPS Inc.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the MIT License .

Copyright (C) 2018, by kwanhur <huang_hua2012@163.com>, VIPS Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)

