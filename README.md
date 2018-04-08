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

`img:clut(clut, method)`
-----
Replaces colors in the image from a color lookup table.

`img:color_decision_list()`
-----
Accepts a lightweight Color Correction Collection (CCC) file which solely contains one or more color corrections and 
applies the color correction to the image. Here is a sample CCC file:

    <ColorCorrectionCollection xmlns="urn:ASC:CDL:v1.2">
    <ColorCorrection id="cc03345">
          <SOPNode>
               <Slope> 0.9 1.2 0.5 </Slope>
               <Offset> 0.4 -0.5 0.6 </Offset>
               <Power> 1.0 0.8 1.5 </Power>
          </SOPNode>
          <SATNode>
               <Saturation> 0.85 </Saturation>
          </SATNode>
    </ColorCorrection>
    </ColorCorrectionCollection>

which includes the offset, slope, and power for each of the RGB channels as well as the saturation.

`img:colorize(colorize, blend)`
-----
Blends the fill color with each pixel in the image.

`img:color_matrix(color_matrix)`
-----
Apply color transformation to an image. The method permits saturation changes, hue rotation, luminance to alpha, and 
various other effects. Although variable-sized transformation matrices can be used, typically one uses a 5x5 matrix for 
an RGBA image and a 6x6 for CMYKA (or RGBA with offsets). The matrix is similar to those used by Adobe Flash except 
offsets are in column 6 rather than 5 (in support of CMYKA images) and offsets are normalized (divide Flash offset by 255).

`img:combine(color_space)`
-----
Combines one or more images into a single image. The grayscale value of the pixels of each image in the sequence is 
assigned in order to the specified hannels of the combined image. The typical ordering would be image 1 => Red, 2 => Green, 3 => Blue, etc.

`img:comment(comment)`
-----
Adds a comment to your image.

`img:compare_layers(method)`
-----
Compares each image with the next in a sequence and returns the maximum bounding region of any pixel differences it discovers.

`img:composite_layers(source, compose, x, y)`
-----
Composite the images in the source wand over the images in the destination wand in sequence, starting with the current image in both lists.

Each layer from the two image lists are composted together until the end of one of the image lists is reached. 
The offset of each composition is also adjusted to match the virtual canvas offsets of each layer. As such the 
given offset is relative to the virtual canvas, and not the actual image.

Composition uses given x and y offsets, as the 'origin' location of the source images virtual canvas (not the real image) 
allowing you to compose a list of 'layer images' into the destiantioni images. This makes it well sutiable for 
directly composing 'Clears Frame Animations' or 'Coaleased Animations' onto a static or other 'Coaleased Animation' 
destination image list. GIF disposal handling is not looked at.

Special case:- If one of the image sequences is the last image (just a single image remaining), that image is 
repeatally composed with all the images in the other image list. Either the source or destination lists may be the single image, for this situation.

In the case of a single destination image (or last image given), that image will ve cloned to match the number of 
images remaining in the source image list.

This is equivelent to the "-layer Composite" Shell API operator.

`img:compare(reference, metric, distortion)`
-----
Compares an image to a reconstructed image and returns the specified difference image.

`img:composite_gravity(source, compose, gravity)`
-----
Composite one image onto another using the specified gravity.

`img:contrast(sharpen)`
-----
Enhances the intensity differences between the lighter and darker elements of the image. 
Set sharpen to a value other than 0 to increase the image contrast otherwise the contrast is reduced.

`img:contrast_stretch(black_point, white_point)`
-----
Enhances the contrast of a color image by adjusting the pixels color to span the entire range of colors available. 
You can also reduce the influence of a particular channel with a gamma value of 0.

`img:convolve(kernel)`
-----
Applies a custom convolution kernel to the image.

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
The method returns True on success otherwise False if an error is encountered. 
The data is returned as char, short int, int, ssize_t, float, or double in the order specified by map.

Suppose you want to extract the first scanline of a 640x480 image as character data in red-green-blue order:
img:export_pixels(0, 0, 640, 1, "RGB", "Char", pixels)

`img:extent(w, h, x, y)`
-----
Extends the image as defined by the geometry, gravity, and wand background color. Set the (x,y) offset of the geometry 
to move the original wand relative to the extended wand.

`img:flip()`
-----
Creates a vertical mirror image by reflecting the pixels around the central x-axis.

`img:flood_fill_paint(fill, fuzz, border_color, x, y, invert)`
-----
Changes the color value of any pixel that matches target and is an immediate neighbor. 
If the method FillToBorderMethod is specified, the color value is changed for any neighbor pixel that does not match 
the bordercolor member of image.

`img:flop()`
-----
Creates a horizontal mirror image by reflecting the pixels around the central y-axis.

`img:forward_fourier_transform(magnitude)`
-----
Implements the discrete Fourier transform (DFT) of the image either as a magnitude / phase or real / imaginary image pair.

`img:inverse_fourier_transform(phase_wand, magnitude)`
-----
Implements the inverse discrete Fourier transform (DFT) of the image either as a magnitude / phase or real / imaginary image pair.

`img:frame(matte_color, w, h, inner_level, outer_level, compose)`
-----
Adds a simulated three-dimensional border around the image. The width and height specify the border width of the 
vertical and horizontal sides of the frame. The inner and outer bevels indicate the width of the inner and outer shadows of the frame.

`img:function(func, num_args, args)`
-----
Applys an arithmetic, relational, or logical expression to an image. Use these operators to lighten or darken an image, 
to increase or decrease contrast in an image, or to produce the "negative" of an image.

`img:fx(expression)`
-----
Evaluate expression for each pixel in the image.

`img:gamma(gamma)`
-----
Gamma-corrects an image. The same image viewed on different devices will have perceptual differences in the way 
the image's intensities are represented on the screen. Specify individual gamma levels for the red, green, 
and blue channels, or adjust all three with the gamma parameter. Values typically range from 0.8 to 2.3.

You can also reduce the influence of a particular channel with a gamma value of 0.

`img:gaussian_blur(radius, sigma)`
-----
Blurs an image. We convolve the image with a Gaussian operator of the given radius and standard deviation (sigma). 
For reasonable results, the radius should be larger than sigma. 
Use a radius of 0 and gaussian_blur() selects a suitable radius for you.

`img:get_image()`
-----
Gets the image at the current image index.

`img:get_alpha_channel()`
-----
Returns False if the image alpha channel is not activated. That is, the image is RGB rather than RGBA or CMYK rather than CMYKA.

`img:get_mask()`
-----
Gets the image clip mask at the current image index.

`img:get_background_color(background_color)`
-----
Returns the image background color.

`img:get_blobs()`
-----
Implements direct to memory image formats. It returns the image sequence as a blob and its length. 
The format of the image determines the format of the returned blob (GIF, JPEG, PNG, etc.).

`img:get_blue_primary(x, y, z)`
-----
Returns the chromaticy blue primary point for the image.

`img:get_red_primary(x, y, z)`
-----
Returns the chromaticy red primary point.

`img:get_border_color(border_color)`
-----
Returns the image border color.

`img:get_kurtosis(kurtosis, skewness)`
-----
Gets the kurtosis and skewness of one or more image channels.

`img:get_mean(mean, standard_deviation)`
-----
Gets the mean and standard deviation of one or more image channels.

`img:get_range(minima, maxima)`
-----
Gets the range for one or more image channels.

`img:get_colormap_color(color)`
-----
Returns the color of the specified colormap index.

`img:get_colors()`
-----
Gets the number of unique colors in the image.

`img:get_colorspace()`
-----
Gets the image colorspace.

`img:get_compose()`
-----
Returns the composite operator associated with the image.

`img:get_compression()`
-----
Gets the image compression.

`img:get_delay()`
-----
Gets the image delay.

`img:get_dispose()`
-----
Gets the image disposal method.

`img:get_endian()`
-----
Gets the image endian.

`img:get_filename()`
-----
Returns the filename of a particular image in a sequence.

`img:get_fuzz()`
-----
Gets the image fuzz.

`img:get_gamma()`
-----
Gets the image gamma.

`img:get_histogram(num_colors)`
-----
Returns the image histogram as an array of PixelWand wands.

`img:get_interpolate_method()`
-----
Returns the interpolation method for the sepcified image.

`img:get_iterations()`
-----
Gets the image iterations.

`img:get_matte_color(matte_color)`
-----
Returns the image matte color.

`img:get_page()`
-----
Returns the page geometry associated with the image.

`img:get_pixel_color(x,y,color)`
-----
Returns the color of the specified pixel.

`img:get_region(w, h, x, y)`
-----
Extracts a region of the image and returns it as a a new wand.

`img:get_rendering_intent()`
-----
Gets the image rendering intent.

`img:get_resolution(x, y)`
-----
Gets the image X and Y resolution.

`img:get_scene()`
-----
Gets the image scene.

`img:get_signature()`
-----
Generates an SHA-256 message digest for the image pixel stream.

`img:get_ticks_per_second()`
-----
Gets the image ticks-per-second.

`img:get_image_type()`
-----
Gets the potential image type:

Bilevel Grayscale GrayscaleMatte Palette PaletteMatte TrueColor TrueColorMatte ColorSeparation ColorSeparationMatte

`img:get_units()`
-----
Gets the image units of resolution.

`img:get_virtual_pixel_method()`
-----
Returns the virtual pixel method for the sepcified image.

`img:get_white_point(x, y, z)`
-----
Returns the chromaticy white point.

`img:get_number()`
-----
Returns the number of images associated with a magick wand.

`img:hald_clut(hald_wand)`
-----
Replaces colors in the image from a Hald color lookup table. A Hald color lookup table is a 3-dimensional color cube 
mapped to 2 dimensions. Create it with the HALD coder. You can apply any color transformation to the Hald image and 
then use this method to apply the transform to the image.

`img:has_next()`
-----
Returns True if the wand has more images when traversing the list in the forward direction.

`img:has_previous()`
-----
Returns True if the wand has more images when traversing the list in the reverse direction.

`img:identify()`
-----
Identifies an image by printing its attributes to the file. Attributes include the image width, height, size, and others.

`img:identify_type()`
-----
Gets the potential image type:

Bilevel Grayscale GrayscaleMatte Palette PaletteMatte TrueColor TrueColorMatte ColorSeparation ColorSeparationMatte

`img:implode(radius, method)`
-----
Creates a new image that is a copy of an existing one with the image pixels "implode" by the specified percentage. 
It allocates the memory necessary for the new Image structure and returns a pointer to the new image.

`img:import_pixels(x, y, columns, rows, map, storage, pixels)`
-----
Accepts pixel datand stores it in the image at the location you specify. The method returns False on success 
otherwise True if an error is encountered. 
The pixel data can be either char, short int, int, ssize_t, float, or double in the order specified by map.

Suppose your want to upload the first scanline of a 640x480 image from character data in red-green-blue order:

img:import_pixels(0,0,640,1,"RGB","Char",pixels);

`img:interpolative_resize(columns, rows, method)`
-----
Resize image using a interpolative method.

`img:label(label)`
-----
Adds a label to your image.

`img:level(black_point, gamma, white_point)`
-----
Adjusts the levels of an image by scaling the colors falling between specified white and black points to 
the full available quantum range. The parameters provided represent the black, mid, and white points. 
The black point specifies the darkest color in the image. Colors darker than the black point are set to zero. 
Mid point specifies a gamma correction to apply to the image. White point specifies the lightest color in the image. 
Colors brighter than the white point are set to the maximum quantum value.

`img:linear_stretch(black_point, white_point)`
-----
Stretches with saturation the image intensity.

`img:liquid_rescale(columns, rows, delta_x, rigidity)`
-----
Rescales image with seam carving.

`img:local_contrast(radius, strenght)`
-----
Attempts to increase the appearance of large-scale light-dark transitions. Local contrast enhancement works similarly to 
sharpening with an unsharp mask, however the mask is instead created using an image with a greater blur distance.

`img:magnify()`
-----
A convenience method that scales an image proportionally to twice its original size.

`img:minify()`
-----
A convenience method that scales an image proportionally to one-half its original size.

`img:merge_layers(method)`
-----
Composes all the image layers from the current given image onward to produce a single image of the merged layers.

The inital canvas's size depends on the given LayerMethod, and is initialized using the first images background color. 
The images are then compositied onto that image in sequence using the given composition that has been assigned to 
each individual image.

`img:montage(drawing, tile_geometry, thumbnail_geometry, mode, frame)`
-----
Creates a composite image by combining several separate images. The images are tiled on the composite image with 
the name of the image optionally appearing just below the individual tile.

`img:morph(num_frames)`
-----
Method morphs a set of images. Both the image pixels and size are linearly interpolated to give the appearance of 
a meta-morphosis from one image to the next.

`img:morphology(method, iterations, kernel)`
-----
Applies a user supplied kernel to the image according to the given mophology method.

`img:motion_blur(radius, sigma, angle)`
-----
Simulates motion blur. We convolve the image with a Gaussian operator of the given radius and standard deviation (sigma). 
For reasonable results, radius should be larger than sigma. Use a radius of 0 and MotionBlurImage() 
selects a suitable radius for you. Angle gives the angle of the blurring motion.

`img:negate(gray)`
-----
Negates the colors in the reference image. The Grayscale option means that only grayscale values within the image are negated.

You can also reduce the influence of a particular channel with a gamma value of 0.

`img:new_image(columns, rows, background)`
-----
Adds a blank image canvas of the specified size and background color to the wand.

`img:next()`
-----
Sets the next image in the wand as the current image.

It is typically used after reset_iterator(), after which its first use will set the first image as the current image (unless the wand is empty).

It will return False when no more images are left to be returned which happens when the wand is empty, or the current image is the last image.

When the above condition (end of image list) is reached, the iterator is automaticall set so that you can start using 
previous() to again iterate over the images in the reverse direction, starting with the last image (again). You can 
jump to this condition immeditally using set_last_iterator().

`img:normalize()`
-----
Enhances the contrast of a color image by adjusting the pixels color to span the entire range of colors available

You can also reduce the influence of a particular channel with a gamma value of 0.

`img:oil_paint(radius, sigma)`
-----
Applies a special effect filter that simulates an oil painting. Each pixel is replaced by the 
most frequent color occurring in a circular region defined by radius.

`img:opaque_paint(target, fill, fuzz, invert)`
-----
Changes any pixel that matches color with the color defined by fill.

`img:optimize_layers()`
-----
Compares each image the GIF disposed forms of the previous image in the sequence. From this it attempts to select the 
smallest cropped image to replace each frame, while preserving the results of the animation.

`img:optimize_transparency()`
-----
Takes a frame optimized GIF animation, and compares the overlayed pixels against the disposal image resulting from 
all the previous frames in the animation. Any pixel that does not change the disposal image (and thus does not effect the outcome of an overlay) is made transparent.

WARNING: This modifies the current images directly, rather than generate a new image sequence.
 
`img:ordered_dither(threshold_map)`
-----
Performs an ordered dither based on a number of pre-defined dithering threshold maps, but over multiple intensity levels, 
which can be different for different channels, according to the input arguments.

`img:ping(filename)`
-----
The same as read() except the only valid information returned is the image width, height, size, and format. 
It is designed to efficiently obtain this information from a file without reading the entire image sequence into memory.

`img:ping_blob(blob)`
-----
Pings an image or image sequence from a blob.

`img:ping_file(file)`
-----
Pings an image or image sequence from an open file descriptor.

`img:polaroid(drawing, caption, angle, method)`
-----
Simulates a Polaroid picture.

`img:posterize(levels, method)`
-----
Reduces the image to a limited number of color level.

`img:preview(preview)`
-----
Tiles 9 thumbnails of the specified image with an image processing operation applied at varying strengths. 
This helpful to quickly pin-point an appropriate parameter for an image processing operation.

`img:previous()`
-----
Sets the previous image in the wand as the current image.

It is typically used after set_last_iterator(), after which its first use will set the last image as the current image (unless the wand is empty).

It will return False when no more images are left to be returned which happens when the wand is empty, or the current 
image is the first image. At that point the iterator is than reset to again process images in the forward direction, 
again starting with the first image in list. Images added at this point are prepended.

Also at that point any images added to the wand using add() or read() will be prepended before the first image. 
In this sense the condition is not quite exactly the same as reset_iterator().

`img:quantize(num_corlors, colorspace, treedepth, method, measure_error)`
------
Analyzes the colors within a reference image and chooses a fixed number of colors to represent the image. The goal of 
the algorithm is to minimize the color difference between the input and output image while minimizing the processing time.

`img:quantize_multi(num_corlors, colorspace, treedepth, method, measure_error)`
----
Analyzes the colors within a sequence of images and chooses a fixed number of colors to represent the image. The goal of 
the algorithm is to minimize the color difference between the input and output image while minimizing the processing time.

`img:rotational_blur(angle)`
----
Rotational blurs an image.

`img:raise(w, h, x, y, raise)`
-----
Creates a simulated three-dimensional button-like effect by lightening and darkening the edges of the image. 
Members width and height of raise_info define the width of the vertical and horizontal edge of the effect.

`img:random_threshold(low, high)`
-----
Changes the value of individual pixels based on the intensity of each pixel compared to threshold. The result is a high-contrast, two color image.

`img:read(filename)`
-----
Reads an image or image sequence. The images are inserted just before the current image pointer position.

Use set_first_iterator(), to insert new images before all the current images in the wand, set_last_iterator() to append 
add to the end, set_iterator_index() to place images just after the given index.

`img:read_blob(blob)`
-----
Reads an image or image sequence from a blob. In all other respects it is like read().

`img:read_file(file)`
-----
Reads an image or image sequence from an already opened file descriptor. Otherwise it is like read().

`img:remap(remap_wand, method)`
-----
Replaces the colors of an image with the closest color from a reference image.

`img:remove()`
-----
Removes an image from the image list.

`img:resample(x_resolution, y_resolution, filter)`
-----
Resample image to desired resolution.

Bessel Blackman Box Catrom Cubic Gaussian Hanning Hermite Lanczos Mitchell Point Quandratic Sinc Triangle

Most of the filters are FIR (finite impulse response), however, Bessel, Gaussian, and Sinc are IIR (infinite impulse response). Bessel and Sinc are windowed (brought down to zero) with the Blackman filter.

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

