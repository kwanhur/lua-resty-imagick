-- Copyright (C) by Kwanhur Huang


local modulename = "restyImagickWand"
local _M = {}
_M._VERSION = '0.0.1'
_M._NAME = modulename

local lib = require("resty.imagick.wand.lib").lib
lib.MagickWandGenesis()

local image = require("resty.imagick.wand.image")
local make_thumb = require("resty.imagick.thumb").make_thumb
local pixel = require("resty.imagick.wand.pixel")

_M.mode = "image_magick"

_M.Image = image

_M.load_image = image.load

_M.thumb = make_thumb(image.load)

_M.load_image_from_blob = image.load_from_blob

_M.Pixel = pixel.new

return _M