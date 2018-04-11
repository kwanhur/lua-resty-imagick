-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandImage'
local _M = {}
_M._NAME = modulename

local ffi = require("ffi")
local wand_lib = require("resty.imagick.wand.lib")
local wand_base = require("resty.imagick.wand.base")

local lib = wand_lib.lib

local get_exception = function(wand)
    local etype = ffi.new("ExceptionType[1]", 0)
    local msg = ffi.string(ffi.gc(lib.MagickGetException(wand, etype),
      lib.MagickRelinquishMemory))
    return etype[0], msg
end

_M.load = function(path)
    local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
    if 0 == lib.MagickReadImage(wand, path) then
        local code, msg = get_exception(wand)
        return nil, msg, code
    end
    return wand_base:new(wand, path)
end

_M.load_from_blob = function(blob)
    local wand = ffi.gc(lib.NewMagickWand(), lib.DestroyMagickWand)
    if 0 == lib.MagickReadImageBlob(wand, blob, #blob) then
        local code, msg = get_exception(wand)
        return nil, msg, code
    end
    return wand_base:new(wand, "<from_blob>")
end

return _M
