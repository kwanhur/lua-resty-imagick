-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandBase'
local _M = {}
local mt = { __index = _M }
_M._NAME = modulename
_M.__name = "Image"

local ffi = require('ffi')
local thumb = require("resty.imagick.thumb")
local wand_lib = require("resty.imagick.wand.lib")
local wand_data = require("resty.imagick.wand.data")

local lib = wand_lib.lib
local can_resize = wand_lib.can_resize
local gravity = wand_data.gravity
local filtertype = wand_data.filtertype
local composite_operators = wand_data.composite_operators
local orientation = wand_data.orientation
local interlace = wand_data.interlace

local setmetatable = setmetatable
local tonumber = tonumber
local tostring = tostring
local assert = assert
local unpack = unpack
local type = type
local error = error

local get_exception = function(wand)
    local etype = ffi.new("ExceptionType[1]", 0)
    local msg = ffi.string(ffi.gc(lib.MagickGetException(wand, etype), lib.MagickRelinquishMemory))
    return etype[0], msg
end

local handle_result = function(img_or_wand, status)
    local wand = img_or_wand.wand or img_or_wand
    if status == 0 then
        local code, msg = get_exception(wand)
        return nil, msg, code
    else
        return true
    end
end

_M.new = function(self, wand, path)
    self.wand = wand
    self.path = path
    return setmetatable(self, mt)
end

_M.get_width = function(self)
    return lib.MagickGetImageWidth(self.wand)
end

_M.get_height = function(self)
    return lib.MagickGetImageHeight(self.wand)
end

_M.get_format = function(self)
    local format = lib.MagickGetImageFormat(self.wand)
    do
        local _with_0 = ffi.string(format):lower()
        lib.MagickRelinquishMemory(format)
        return _with_0
    end
end

_M.set_format = function(self, format)
    return handle_result(self, lib.MagickSetImageFormat(self.wand, format))
end

_M.get_depth = function(self)
    return tonumber(lib.MagickGetImageDepth(self.wand))
end

_M.set_depth = function(self, d)
    return handle_result(self, lib.MagickSetImageDepth(self.wand, d))
end

_M.get_quality = function(self)
    return lib.MagickGetImageCompressionQuality(self.wand)
end

_M.set_quality = function(self, quality)
    return handle_result(self, lib.MagickSetImageCompressionQuality(self.wand, quality))
end

_M.get_option = function(self, magick, key)
    local format = magick .. ":" .. key
    local option_str = lib.MagickGetOption(self.wand, format)
    do
        local _with_0 = ffi.string(option_str)
        lib.MagickRelinquishMemory(option_str)
        return _with_0
    end
end

_M.set_option = function(self, magick, key, value)
    local format = magick .. ":" .. key
    return handle_result(self, lib.MagickSetOption(self.wand, format, value))
end

_M.get_gravity = function(self)
    return gravity:to_str(lib.MagickGetImageGravity(self.wand))
end

_M.set_gravity = function(self, gtype)
    gtype = assert(gravity:to_int(gtype), "invalid gravity type")
    return lib.MagickSetImageGravity(self.wand, gtype)
end

_M.strip = function(self)
    return lib.MagickStripImage(self.wand)
end

_M.clone = function(self)
    local wand = ffi.gc(lib.CloneMagickWand(self.wand), lib.DestroyMagickWand)
    return _M:new(wand, self.path)
end

_M.coalesce = function(self)
    self.wand = ffi.gc(lib.MagickCoalesceImages(self.wand), ffi.DestroyMagickWand)
    return true
end

_M.resize = function(self, w, h, f, blur)
    if f == nil then
        f = "Lanczos2"
    end
    if blur == nil then
        blur = 1.0
    end
    if not (can_resize) then
        error("Failed to load filter list, can't resize")
    end
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickResizeImage(self.wand, w, h, filtertype:to_int(f .. 'Filter'), blur))
end

_M.adaptive_resize = function(self, w, h)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickAdaptiveResizeImage(self.wand, w, h))
end

_M.scale = function(self, w, h)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickScaleImage(self.wand, w, h))
end

_M.crop = function(self, w, h, x, y)
    if x == nil then
        x = 0
    end
    if y == nil then
        y = 0
    end
    return handle_result(self, lib.MagickCropImage(self.wand, w, h, x, y))
end

_M.blur = function(self, sigma, radius)
    if radius == nil then
        radius = 0
    end
    return handle_result(self, lib.MagickBlurImage(self.wand, radius, sigma))
end

_M.modulate = function(self, brightness, saturation, hue)
    if brightness == nil then
        brightness = 100
    end
    if saturation == nil then
        saturation = 100
    end
    if hue == nil then
        hue = 100
    end
    return handle_result(self, lib.MagickModulateImage(self.wand, brightness, saturation, hue))
end

_M.sharpen = function(self, sigma, radius)
    if radius == nil then
        radius = 0
    end
    return handle_result(self, lib.MagickSharpenImage(self.wand, radius, sigma))
end

_M.rotate = function(self, degrees, r, g, b)
    if r == nil then
        r = 0
    end
    if g == nil then
        g = 0
    end
    if b == nil then
        b = 0
    end
    local pixel = ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
    lib.PixelSetRed(pixel, r)
    lib.PixelSetGreen(pixel, g)
    lib.PixelSetBlue(pixel, b)
    local res = {
        handle_result(self, lib.MagickRotateImage(self.wand, pixel, degrees))
    }
    return unpack(res)
end

_M.composite = function(self, blob, x, y, op)
    if op == nil then
        op = "OverCompositeOp"
    end
    if type(blob) == "table" and blob.__name == "Image" then
        blob = blob.wand
    end
    op = assert(composite_operators:to_int(op), "invalid operator type")
    return handle_result(self, lib.MagickCompositeImage(self.wand, blob, op, x, y))
end

_M.get_blob = function(self)
    local len = ffi.new("size_t[1]", 0)
    local blob = ffi.gc(lib.MagickGetImageBlob(self.wand, len), lib.MagickRelinquishMemory)
    return ffi.string(blob, len[0])
end

_M.write = function(self, fname)
    return handle_result(self, lib.MagickWriteImage(self.wand, fname))
end

_M.destroy = function(self)
    if self.wand then
        lib.DestroyMagickWand(ffi.gc(self.wand, nil))
        self.wand = nil
    end
    if self.pixel_wand then
        lib.DestroyPixelWand(ffi.gc(self.pixel_wand, nil))
        self.pixel_wand = nil
    end
end

_M.get_pixel = function(self, x, y)
    self.pixel_wand = self.pixel_wand or ffi.gc(lib.NewPixelWand(), lib.DestroyPixelWand)
    assert(lib.MagickGetImagePixelColor(self.wand, x, y, self.pixel_wand), "failed to get pixel")

    return lib.PixelGetRed(self.pixel_wand), lib.PixelGetGreen(self.pixel_wand),
    lib.PixelGetBlue(self.pixel_wand), lib.PixelGetAlpha(self.pixel_wand)
end

_M.transpose = function(self)
    return handle_result(self, lib.MagickTransposeImage(self.wand))
end

_M.transverse = function(self)
    return handle_result(self, lib.MagickTransverseImage(self.wand))
end

_M.flip = function(self)
    return handle_result(self, lib.MagickFlipImage(self.wand))
end

_M.flop = function(self)
    return handle_result(self, lib.MagickFlopImage(self.wand))
end

_M.get_property = function(self, property)
    local res = lib.MagickGetImageProperty(self.wand, property)
    if nil ~= res then
        do
            local _with_0 = ffi.string(res)
            lib.MagickRelinquishMemory(res)
            return _with_0
        end
    else
        local code, msg = get_exception(self.wand)
        return nil, msg, code
    end
end

_M.set_property = function(self, property, value)
    return handle_result(self, lib.MagickSetImageProperty(self.wand, property, value))
end

_M.get_orientation = function(self)
    return orientation:to_str(lib.MagickGetImageOrientation(self.wand))
end

_M.set_orientation = function(self, otype)
    otype = assert(orientation:to_int(otype), "invalid orientation type")
    return lib.MagickSetImageOrientation(self.wand, otype)
end

_M.get_interlace_scheme = function(self)
    return interlace:to_str(lib.MagickGetImageInterlaceScheme(self.wand))
end

_M.set_interlace_scheme = function(self, itype)
    itype = assert(interlace:to_int(itype), "invalid interlace type")
    return lib.MagickSetImageInterlaceScheme(self.wand, itype)
end

_M.get_profile = function(self, profile)
    local len = ffi.new("size_t[1]", 0)
    local blob = ffi.gc(lib.MagickGetImageProfile(self.wand, profile, len), lib.MagickRelinquishMemory)
    return ffi.string(blob, len[0])
end

_M.set_profile = function(self, profile, value)
    return handle_result(self, lib.MagickSetImageProfile(self.wand, profile, value, #value))
end

_M.auto_orient = function(self)
    return handle_result(self, lib.MagickAutoOrientImage(self.wand))
end

_M.reset_page = function(self)
    return handle_result(self, lib.MagickResetImagePage(self.wand, nil))
end

_M.__tostring = function(self)
    return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
end

_M._keep_aspect = function(self, w, h)
    if not w and h then
        return self:get_width() / self:get_height() * h, h
    elseif w and not h then
        return w, self:get_height() / self:get_width() * w
    else
        return w, h
    end
end

_M.resize_and_crop = function(self, w, h)
    local src_w, src_h = self:get_width(), self:get_height()
    local ar_src = src_w / src_h
    local ar_dest = w / h
    if ar_dest == ar_src then
        return self:resize(w, h)
    elseif ar_dest > ar_src then
        local new_height = w / ar_src
        self:resize(w, new_height)
        return self:crop(w, h, 0, (new_height - h) / 2)
    else
        local new_width = h * ar_src
        self:resize(new_width, h)
        return self:crop(w, h, (new_width - w) / 2, 0)
    end
end

_M.scale_and_crop = function(self, w, h)
    local src_w, src_h = self:get_width(), self:get_height()
    local ar_src = src_w / src_h
    local ar_dest = w / h
    if ar_dest > ar_src then
        local new_height = w / ar_src
        self:resize(w, new_height)
        return self:scale(w, h)
    else
        local new_width = h * ar_src
        self:resize(new_width, h)
        return self:scale(w, h)
    end
end

_M.thumb = function(self, size_str)
    local src_w, src_h = self:get_width(), self:get_height()
    local opts = assert(thumb.parse_size_str(size_str, src_w, src_h))
    if opts.center_crop then
        self:resize_and_crop(opts.w, opts.h)
    elseif opts.crop_x then
        self:crop(opts.w, opts.h, opts.crop_x, opts.crop_y)
    else
        self:resize(opts.w, opts.h)
    end
    return true
end

return _M