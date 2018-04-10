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
local gravity_type = wand_data.gravity_type
local filter_type = wand_data.filter_type
local storage_type = wand_data.storage_type
local distort_method = wand_data.distort_method
local virtual_pixel_method = wand_data.virtual_pixel_method
local layer_method = wand_data.layer_method
local evaluate_operator = wand_data.evaluate_operator
local composite_operators = wand_data.composite_operators
local orientation = wand_data.orientation
local interlace = wand_data.interlace
local functions = wand_data.functions
local colorspace_type = wand_data.colorspace_type
local compression_type = wand_data.compression_type
local dispose_type = wand_data.dispose_type
local endian_type = wand_data.endian_type
local image_type = wand_data.image_type
local resolution_type = wand_data.resolution_type
local metric_type = wand_data.metric_type
local preview_type = wand_data.preview_type
local pixel_interpolate_method = wand_data.pixel_interpolate_method
local morphology_method = wand_data.morphology_method
local dither_method = wand_data.dither_method
local rendering_intent = wand_data.rendering_intent
local montage_mode = wand_data.montage_mode
local alpha_channel_option = wand_data.alpha_channel_option

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
    local fmat = ffi.string(format):lower()
    lib.MagickRelinquishMemory(format)
    return fmat
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
    return gravity_type:to_str(lib.MagickGetImageGravity(self.wand))
end

_M.set_gravity = function(self, gtype)
    gtype = assert(gravity_type:to_int(gtype), "invalid gravity type")
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
    return handle_result(self, lib.MagickResizeImage(self.wand, w, h, 
      filter_type:to_int(f .. 'Filter'), blur))
end

_M.adaptive_resize = function(self, w, h)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickAdaptiveResizeImage(self.wand, w, h))
end

_M.adaptive_blur = function(self, sigma, radius)
    if radius == nil then
        radius = 0
    end
    return handle_result(self, lib.MagickAdaptiveBlurImage(self.wand, radius, sigma))
end

_M.adaptive_sharpen = function(self, sigma, radius)
    if radius == nil then
        radius = 0
    end
    return handle_result(self, lib.MagickAdaptiveSharpenImage(self.wand, radius, sigma))
end

_M.adaptive_threshold = function(self, w, h, bias)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickAdaptiveThresholdImage(self.wand, w, h, bias))
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

_M.auto_gama = function(self)
    return handle_result(self, lib.MagickAutoGammaImage(self.wand))
end

_M.auto_level = function(self)
    return handle_result(self, lib.MagickAutoLevelImage(self.wand))
end


_M.reset_page = function(self)
    return handle_result(self, lib.MagickResetImagePage(self.wand, nil))
end

_M.__tostring = function(self)
    return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
end

_M.animate = function(self, server_name)
    return handle_result(self, lib.MagickAnimateImages(self.wand, server_name))
end

_M.black_threshold = function(self, threshold)
    return handle_result(self, lib.MagickBlackThresholdImage(self.wand, threshold))
end

_M.blue_shift = function(self, factor)
    return handle_result(self, lib.MagickBlueShiftImage(self.wand, factor))
end

_M.border = function(self, border_color, w, h, compose)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickBorderImage(self.wand, border_color, w, h, compose))
end

_M.charoal = function(self, sigma, radius)
    return handle_result(self, lib.MagickCharcoalImage(self.wand, radius, sigma))
end

_M.chop = function(self, w, h, x, y)
    w, h = self:_keep_aspect(w, h)
    return handle_result(self, lib.MagickChopImage(self.wand, w, h, x, y))
end

_M.clamp = function(self)
    return handle_result(self, lib.MagickClampImage(self.wand))
end

_M.chip = function(self)
    return handle_result(self, lib.MagickClipImage(self.wand))
end

_M.chip_path = function(self, path, inside)
    return handle_result(self, lib.MagickClipImagePath(self.wand, path, inside))
end

_M.clut = function(self, clut, method)
    return handle_result(self, lib.MagickClutImage(self.wand, clut, 
      pixel_interpolate_method:to_int(method .. "InterpolatePixel")))
end

_M.color_decision_list = function(self)
    local col = ffi.new("char *[?]")
    local ok, msg, code = lib.MagickColorDecisionListImage(self.wand, col)
    if ok then
        local co = ffi.string(col)
        lib.MagickRelinquishMemory(col)
        return co
    else
        return nil, msg, code
    end
end

_M.colorize = function(self, colorize, blend)
    return handle_result(self, lib.MagickColorizeImage(self.wand, colorize, blend))
end

_M.color_matrix = function(self, color_matrix)
    return handle_result(self, lib.MagickColorMatrixImage(self.wand, color_matrix))
end

_M.combine = function(self, colorspace)
    return lib.MagickCombineImages(self.wand, colorspace_type:to_int(colorspace .. "Colorspace"))
end

_M.comment = function(self, comment)
    return handle_result(self, lib.MagickCommentImage(self.wand, comment))
end

_M.compare_layers = function(self, method)
    return lib.MagickCompareImagesLayers(self.wand, layer_method:to_int(method .. "Layer"))
end

_M.compare = function(self, reference, metric, distortion)
    return lib.MagickCompareImages(self.wand, reference, metric_type:to_int(metric .. "ErrorMetric"), distortion)
end

_M.composite_gravity = function(self, source, compose, gravity)
    return handle_result(self, lib.MagickCompositeImageGravity(self.wand, source, 
      composite_operators:to_int(compose .. "CompositeOp"), gravity_type:to_int(gravity .. "Gravity")))
end

_M.composite_layers = function(self, source, compose, x, y)
    return handle_result(self, lib.MagickCompositeLayers(self.wand, source, 
      composite_operators:to_int(compose .. "CompositeOp"), x, y))
end

_M.contrast = function(self, sharpen)
    return handle_result(self, lib.MagickContrastImage(self.wand, sharpen))
end

_M.contrast_stretch = function(self, black, white)
    return handle_result(self, lib.MagickContrastStretchImage(self.wand, black, white))
end

_M.convolve = function(self, kernel)
    return handle_result(self, lib.MagickConvolveImage(self.wand, kernel))
end

_M.circle_colormap = function(self, displace)
    return handle_result(self, lib.MagickCycleColormapImage(self.wand, displace))
end

_M.consitute = function(self, columns, rows, map, storage, pixels)
    return handle_result(self, lib.MagickConstituteImage(self.wand, columns, rows, map,
        storage_type:to_int(storage .. 'Pixel'), pixels))
end

_M.decipher = function(self, passphrase)
    return handle_result(self, lib.MagickDecipherImage(self.wand, passphrase))
end

_M.deconstruct = function(self)
    return lib.MagickDeconstructImages(self.wand)
end

_M.deskew = function(self, threshold)
    return handle_result(self, lib.MagickDeskewImage(self.wand, threshold))
end

_M.despeckle = function(self)
    return handle_result(self, lib.MagickDespeckleImage(self.wand))
end

_M.display = function(self, server_name)
    return handle_result(self, lib.MagickDisplayImage(self.wand, server_name))
end

_M.display_multi = function(self, server_name)
    return handle_result(self, lib.MagickDisplayImages(self.wand, server_name))
end

_M.distort = function(self, method, num_args, args, bestfit)
    return handle_result(self, lib.MagickDistortImage(distort_method:to_int(method .. 'Distortion'), 
      num_args, args, bestfit))
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

_M.draw = function(self, draw)
    return handle_result(self, lib.MagickDrawImage(self.wand, draw))
end

_M.edge = function(self, radius)
    return handle_result(self, lib.MagickEdgeImage(self.wand, radius))
end

_M.emboss = function(self, radius, sigma)
    return handle_result(self, lib.MagickEmbossImage(self.wand, radius, sigma))
end

_M.encipher = function(self, passphrase)
    return handle_result(self, lib.MagickEncipherImage(self.wand, passphrase))
end

_M.enhance = function(self)
    return handle_result(self, lib.MagickEnhanceImage(self.wand))
end

_M.equalize = function(self)
    return handle_result(self, lib.MagickEqualizeImage(self.wand))
end

_M.evaluate = function(self, operator, value)
    return handle_result(self, lib.MagickEvaluateImage(self.wand, 
      evaluate_operator:to_int(operator .. "EvaluateOperator"), value))
end

_M.export_pixels = function(self, x, y, columns, rows, map, storage, pixels)
    return handle_result(self, lib.MagickExportImagePixels(self.wand, x, y, columns, rows, 
      map, storage_type:to_int(storage .. "Pixel"), pixels))
end

_M.extent = function(self, w, h, x, y)
    return handle_result(self, lib.MagickExtentImage(self.wand, w, h, x, y))
end

_M.flood_fill_paint = function(self, fill, fuzz, border_color, x, y, invert)
    return handle_result(self, lib.MagickFloodfillPaintImage(self.wand, fill, fuzz, 
      border_color, x, y, invert))
end

_M.forward_fourier_transform = function(self, magnitude)
    return handle_result(self, lib.MagickForwardFourierTransformImage(self.wand, magnitude))
end

_M.inverse_fourier_transform = function(self, phase_wand, magnitude)
    return handle_result(self, lib.MagickInverseFourierTransformImage(self.wand, 
      phase_wand, magnitude))
end

_M.frame = function(self, matte_color, w, h, inner_level, outer_level, compose)
    return handle_result(self, lib.MagickFrameImage(self.wand, matte_color, w, h, 
      inner_level, outer_level, composite_operators:to_int(compose .. "CompositeOp")))
end

_M.funtion = function(self, func, num_args, args)
    return handle_result(self, lib.MagickFunctionImage(self.wand, 
      functions:to_int(func .. "Function"), num_args, args))
end

_M.fx = function(self, expression)
    return lib.MagickFxImage(self.wand, expression)
end

_M.gamma = function(self, gamma)
    return handle_result(self, lib.MagickGammaImage(self.wand, gamma))
end

_M.gaussian_blur = function(self, radius, sigma)
    return handle_result(self, lib.MagickGaussianBlurImage(radius, sigma))
end

_M.get_image = function(self)
    return lib.MagickGetImage(self.wand)
end

_M.get_alpha_channel = function(self)
    return handle_result(self, lib.MagickGetImageAlphaChannel(self.wand))
end

_M.get_mask = function(self)
    return lib.MagickGetImageMask(self.wand)
end

_M.get_background_color = function(self, background_color)
    return handle_result(self, lib.MagickGetImageBackgroundColor(self.wand, background_color))
end

_M.get_blobs = function(self)
    local len = ffi.new("size_t[1]", 0)
    local blob = ffi.gc(lib.MagickGetImagesBlob(self.wand, len), lib.MagickRelinquishMemory)
    return ffi.string(blob, len[0])
end

_M.get_blue_primary = function(self, x, y, z)
    return handle_result(self, lib.MagickGetImageBluePrimary(self.wand, x, y, z))
end

_M.get_red_primary = function(self, x, y, z)
    return handle_result(self, lib.MagickGetImageRedPrimary(self.wand, x, y, z))
end

_M.get_border_color = function(self, border_color)
    return handle_result(self, lib.MagickGetImageBorderColor(self.wand, border_color))
end

_M.get_kurtosis = function(self, kurtosis, skewness)
    return handle_result(self, lib.MagickGetImageKurtosis(self.wand, kurtosis, skewness))
end

_M.get_mean = function(self, mean, standard_deviation)
    return handle_result(self, lib.MagickGetImageMean(self.wand, mean, standard_deviation))
end

_M.get_range = function(self, minima, maxima)
    return handle_result(self, lib.MagickGetImageRange(self.wand, minima, maxima))
end

_M.get_colormap_color = function(self, color)
    local index = ffi.new("size_t[1]", 0)
    local ok, msg, code handle_result(self, lib.MagickGetImageColormapColor(self.wand, index, color))
    if ok then
        return index
    else
        return nil, msg, code
    end
end

_M.get_colors = function(self)
    return lib.MagickGetImageColors(self.wand)
end

_M.get_colorspace = function(self)
    return colorspace_type:to_str(lib.MagickGetImageColorspace(self.wand))
end

_M.get_compose = function(self)
    return composite_operators:to_str(lib.MagickGetImageCompose(self.wand))
end

_M.get_compression = function(self)
    return compression_type:to_str(lib.MagickGetImageCompression(self.wand))
end

_M.get_delay = function(self)
    return lib.MagickGetImageDelay(self.wand)
end

_M.get_dispose = function(self)
    return dispose_type:to_str(lib.MagickGetImageDispose(self.wand))
end

_M.get_endian = function(self)
    return endian_type:to_str(lib.MagickGetImageEndian(self.wand))
end

_M.get_filename = function(self)
    local fname = lib.MagickGetImageFilename(self.wand)
    local filename = ffi.string(fname)
    lib.MagickRelinquishMemory(fname)
    return filename
end

_M.get_fuzz = function(self)
    return lib.MagickGetImageFuzz(self.wand)
end

_M.get_gamma = function(self)
    return lib.MagickGetImageGamma(self.wand)
end

_M.get_histogram = function(self, num_colors)
    local num = ffi.new("size_t[1]", num_colors)
    return lib.MagickGetImageHistogram(self.wand, num)
end

_M.get_interpolate_method = function(self)
    return pixel_interpolate_method:to_str(lib.MagickGetImageInterpolateMethod(self.wand))
end

_M.get_iterations = function(self)
    return lib.MagickGetImageIterations(self.wand)
end

_M.get_matte_color = function(self, matte_color)
    return handle_result(self, lib.MagickGetImageMatteColor(self.wand, matte_color))
end

_M.get_page = function(self)
    local w = ffi.new("size_t[1]", 0)
    local h = ffi.new("size_t[1]", 0)
    local x = ffi.new("ssize_t[1]", 0)
    local y = ffi.new("ssize_t[1]", 0)
    local ok, msg, code = handle_result(self, lib.MagickGetImagePage(self.wand, w, h, x, y))
    if ok then
        return w, h, x, y
    else
        return nil, msg, code
    end
end

_M.get_pixel_color = function(self, x, y, color)
    return handle_result(self, lib.MagickGetImagePixelColor(self.wand, x, y, color))
end

_M.get_region = function(self, w, h, x, y)
    return lib.MagickGetImageRegion(self.wand, w, h, x, y)
end

_M.get_rendering_intent = function(self)
    return rendering_intent:to_str(lib.MagickGetImageRenderingIntent(self.wand))
end

_M.get_resolution = function(self, x, y)
    return handle_result(self, lib.MagickGetImageResolution(self.wand, x, y))
end

_M.get_scene = function(self)
    return lib.MagickGetImageScene(self.wand)
end

_M.get_signature = function(self)
    local sig = lib.MagickGetImageSignature(self.wand)
    local signature = ffi.string(sig)
    lib.MagickRelinquishMemory(sig)
    return signature
end

_M.get_ticks_per_second = function(self)
    return lib.MagickGetImageTicksPerSecond(self.wand)
end

_M.get_image_type = function(self)
    return image_type:to_str(lib.MagickGetImageType(self.wand))
end

_M.get_units = function(self)
    return resolution_type:to_str(lib.MagickGetImageUnits(self.wand))
end

_M.get_virtual_pixel_method = function(self)
    return virtual_pixel_method:to_str(lib.MagickGetImageVirtualPixelMethod(self.wand))
end

_M.get_white_point = function(self, x, y, z)
    return handle_result(self, lib.MagickGetImageWhitePoint(self.wand, x, y, z))
end

_M.get_number = function(self)
    return lib.MagickGetNumberImages(self.wand)
end

_M.get_total_ink_density = function(self)
    return lib.MagickGetImageTotalInkDensity(self.wand)
end

_M.hald_clut = function(self, hald_wand)
    return handle_result(self, lib.MagickHaldClutImage(self.wand, hald_wand))
end

_M.has_next = function(self)
    return handle_result(self, lib.MagickHasNextImage(self.wand))
end

_M.has_previous = function(self)
    return handle_result(self, lib.MagickHasPreviousImage(self.wand))
end

_M.identify = function(self)
    local ide = lib.MagickIdentifyImage(self.wand)
    local iden = ffi.string(ide)
    lib.MagickRelinquishMemory(ide)
    return iden
end

_M.identify_type = function(self)
    return image_type:to_str(lib.MagickIdentifyImageType(self.wand))
end

_M.implode = function(self, radius, method)
    return handle_result(self, lib.MagickImplodeImage(self.wand, radius, 
      pixel_interpolate_method:to_int(method .. "InterpolatePixel")))
end

_M.import_pixels = function(self, x, y, columns, rows, map, storage, pixels)
    return handle_result(self, lib.MagickImportImagePixels(self.wand, x, y, 
      columns, rows, map, storage_type:to_int(storage .. "Pixel"), pixels))
end

_M.interpolative_resize = function(self, columns, rows, method)
    return handle_result(self, lib.MagickInterpolativeResizeImage(self.wand, 
      columns, rows, pixel_interpolate_method:to_int(method .. "InterpolatePixel")))
end

_M.label = function(self, label)
    return handle_result(self, lib.MagickLabelImage(self.wand, label))
end

_M.level = function(self, black_point, gamma, white_point)
    return handle_result(self, lib.MagickLevelImage(black_point, gamma, white_point))
end

_M.linear_stretch = function(self, black_point, white_point)
    return handle_result(self, lib.MagickLinearStretchImage(self.wand, 
      black_point, white_point))
end

_M.liquid_rescale = function(self, columns, rows, delta_x, rigidity)
    return handle_result(self, lib.MagickLiquidRescaleImage(columns, rows, 
      delta_x, rigidity))
end

_M.local_contrast = function(self, radius, strength)
    return handle_result(self, lib.MagickLocalContrastImage(self.wand, radius, 
      strength))
end

_M.magnify = function(self)
    return handle_result(self, lib.MagickMagnifyImage(self.wand))
end

_M.minify = function(self)
    return handle_result(self, lib.MagickMinifyImage(self.wand))
end

_M.merge_layers = function(self, method)
    return lib.MagickMergeImageLayers(self.wand, layer_method:to_int(method .. "Layer"))
end

_M.montage = function(self, drawing, tile_geometry, thumbnail_geometry, mode, frame)
    return lib.MagickMontageImage(self.wand, drawing, tile_geometry, thumbnail_geometry,
      montage_mode:to_int(mode .. "Mode"), frame)
end

_M.morph = function(self, num_frames)
    return lib.MagickMorphImages(self.wand, num_frames)
end

_M.morphology = function(self, method, iterations, kernel)
    return handle_result(self, lib.MagickMorphologyImage(self.wand, 
      morphology_method:to_int(method .. "Morphology"), iterations, kernel))
end

_M.motion_blur = function(self, radius, sigma, angle)
    return handle_result(self, lib.MagickMotionBlurImage(self.wand, radius, sigma, angle))
end

_M.negate = function(self, gray)
    return handle_result(self, lib.MagickNegateImage(self.wand, gray))
end

_M.new_image = function(self, columns, rows, background)
    return handle_result(self, lib.MagickNewImage(self.wand, columns, rows, background))
end

_M.next = function(self)
    return handle_result(self, lib.MagickNextImage(self.wand))
end

_M.normalize = function(self)
    return handle_result(self, lib.MagickNormalizeImage(self.wand))
end

_M.oil_paint = function(self, radius, sigma)
    return handle_result(self, lib.MagickOilPaintImage(radius, sigma))
end

_M.opaque_paint = function(self, target, fill, fuzz, invert)
    return handle_result(self, lib.MagickOpaquePaintImage(self.wand, target, 
      fill, fuzz, invert))
end

_M.optimize_layers = function(self)
    return lib.MagickOptimizeImageLayers(self.wand)
end

_M.optimize_transparency = function(self)
    return handle_result(self, lib.MagickOptimizeImageTransparency(self.wand))
end

_M.ordered_dither = function(self, threshold_map)
    return handle_result(self, lib.MagickOrderedDitherImage(self.wand, threshold_map))
end

_M.ping = function(self, filename)
    return handle_result(self, lib.MagickPingImage(self.wand, filename))
end

_M.ping_blob = function(self, blob)
    return handle_result(self, lib.MagickPingImageBlob(self.wand, blob, #blob))
end

_M.ping_file = function(self, file)
    return handle_result(self, lib.MagickPingImageFile(self.wand, file))
end

_M.polariod = function(self, drawing, caption, angle, method)
    return handle_result(self, lib.MagickPolaroidImage(self.wand, drawing, caption, 
      angle, pixel_interpolate_method:to_int(method .. "InterpolatePixel")))
end

_M.posterize = function(self, levels, method)
    return handle_result(self, lib.MagickPosterizeImage(self.wand, levels, 
      distort_method:to_int(method .. "DitherMethod")))
end

_M.preview = function(self, preview)
    return lib.MagickPreviewImages(self.wand, preview_type:to_int(preview .. "Preview"))
end

_M.previous = function(self)
    return lib.MagickPreviousImage(self.wand)
end

_M.quantize = function(self, num_corlors, colorspace, treedepth, method, measure_error)
    return handle_result(self, lib.MagickQuantizeImage(self.wand, num_corlors, 
      colorspace_type:to_int(colorspace .. "Colorspace"), treedepth, 
      distort_method:to_int(method .. "DitherMethod"), measure_error))
end

_M.quantize_multi = function(self, num_corlors, colorspace, treedepth, method, measure_error)
    return handle_result(self, lib.MagickQuantizeImages(self.wand, num_corlors, 
      colorspace_type:to_int(colorspace .. "Colorspace"), treedepth, 
      distort_method:to_int(method .. "DitherMethod"), measure_error))
end

_M.ratational_blur = function(self, angle)
    return handle_result(self, lib.MagickRotationalBlurImage(self.wand, angle))
end

_M.raise = function(self, w, h, x, y, raise)
    return handle_result(self, lib.MagickRaiseImage(self.wand, w, h, x, y, raise))
end

_M.random_threshold = function(self, low, high)
    return handle_result(self, lib.MagickRandomThresholdImage(self.wand, low, high))
end

_M.read = function(self, filename)
    return handle_result(self, lib.MagickReadImage(self.wand, filename))
end

_M.read_blob = function(self, blob)
    return handle_result(self, lib.MagickReadImageBlob(self.wand, blob, #blob))
end

_M.read_file = function(self, file)
    return handle_result(self, lib.MagickReadImageFile(self.wand, file))
end

_M.remap = function(self, remap_wand, method)
    return handle_result(self, lib.MagickRemapImage(self.wand, remap_wand, 
      dither_method:to_int(method .. "DitherMethod")))
end

_M.remove = function(self)
    return handle_result(self, lib.MagickRemoveImage(self.wand))
end

_M.resample = function(self, x_resolution, y_resolution, filter)
    return handle_result(self, lib.MagickResampleImage(self.wand, x_resolution, 
      y_resolution, filter_type:to_int(filter .. "Filter")))
end

_M.roll = function(self, x, y)
    return handle_result(self, lib.MagickRollImage(self.wand, x, y))
end

_M.sample = function(self, columns, rows)
    return handle_result(self, lib.MagickSampleImage(self.wand, columns, rows))
end

_M.segment = function(self, colorspace, verbose, cluster_threshold, smooth_threshold)
    return handle_result(self, lib.MagickSegmentImage(self.wand, 
      colorspace_type:to_int(colorspace .. "Colorspace"), verbose, 
      cluster_threshold, smooth_threshold))
end

_M.selective_blur = function(self, radius, sigma, threshold)
    return handle_result(self, lib.MagickSelectiveBlurImage(self.wand, radius, sigma, threshold))
end

_M.separate = function(self, channel)
    return handle_result(self, lib.MagickSeparateImage(self.wand, channel))
end

_M.sepia_tone = function(self, threshold)
    return handle_result(self, lib.MagickSepiaToneImage(self.wand, threshold))
end

_M.set = function(self, set_wand)
    return handle_result(self, lib.MagickSetImage(self.wand, set_wand))
end

_M.set_alpha_channel = function(self, alpha_type)
    return handle_result(self, lib.MagickSetImageAlphaChannel(self.wand, 
      alpha_channel_option:to_int(alpha_type .. "AlphaChannel")))
end

_M.set_background_color = function(self, background)
    return handle_result(self, lib.MagickSetImageBackgroundColor(self.wand, background))
end

_M.set_blue_primary = function(self, x, y, z)
    return handle_result(self, lib.MagickSetImageBluePrimary(self.wand, x, y, z))
end

_M.set_border_color = function(self, border)
    return handle_result(self, lib.MagickSetImageBorderColor(self.wand, border))
end

_M.set_channel_mask = function(self, channel_mask)
    return lib.MagickSetImageChannelMask(self.wand, channel_mask)
end

_M.set_mask = function(self, type, clip_mask)
    return handle_result(self, lib.MagickSetImageMask(self.wand, type, clip_mask))
end

_M.set_color = function(self, color)
    return handle_result(self, lib.MagickSetImageColor(self.wand, color))
end

_M.set_colormap_color = function(self, index, color)
    return handle_result(self, lib.MagickSetImageColormapColor(self.wand, index, color))
end

_M.set_colorspace = function(self, colorspace)
    return handle_result(self, lib.MagickSetImageColorspace(self.wand, 
      colorspace_type:to_int(colorspace .. "Colorspace")))
end

_M.set_compose = function(self, compose)
    return handle_result(self, lib.MagickSetImageCompose(self.wand, 
      composite_operators:to_int(compose .. "CompositeOp")))
end

_M.set_compression = function(self, compression)
    return handle_result(self, lib.MagickSetImageCompression(self.wand, 
      compression_type:to_int(compression .. "Compression")))
end

_M.set_delay = function(self, delay)
    return handle_result(self, lib.MagickSetImageDelay(self.wand, delay))
end

_M.set_dispose = function(self, dispose)
    return handle_result(self, lib.MagickSetImageDispose(self.wand, 
      dispose_type:to_int(dispose .. "Dispose")))
end

_M.set_endian = function(self, endian)
    return handle_result(self, lib.MagickSetImageEndian(self.wand, 
      endian_type:to_int(endian .. "Endian")))
end

_M.set_extent = function(self, columns, rows)
    return handle_result(self, lib.MagickSetImageExtent(self.wand, columns, rows))
end

_M.set_filename = function(self, filename)
    return handle_result(self, lib.MagickSetImageFilename(self.wand, filename))
end

_M.set_fuzz = function(self, fuzz)
    return handle_result(self, lib.MagickSetImageFuzz(self.wand, fuzz))
end

_M.set_gamma = function(self, gamma)
    return handle_result(self, lib.MagickSetImageGamma(self.wand, gamma))
end

_M.set_green_primary = function(self, x, y, z)
    return handle_result(self, lib.MagickSetImageGreenPrimary(self.wand, x, y, z))
end

_M.set_interpolate_method = function(self, method)
    return handle_result(self, lib.MagickSetImageInterpolateMethod(self.wand, 
      pixel_interpolate_method:to_int(method .. "InterpolatePixel")))
end

_M.set_iterations = function(self, iterations)
    return handle_result(self, lib.MagickSetImageIterations(self.wand, iterations))
end

_M.set_matte = function(self, matte)
    return handle_result(self, lib.MagickSetImageMatte(self.wand, matte))
end

_M.set_matte_color = function(self, matte)
    return handle_result(self, lib.MagickSetImageMatteColor(self.wand, matte))
end

_M.set_page = function(self, w, h, x, y)
    return handle_result(self, lib.MagickSetImagePage(self.wand, w, h, x, y))
end

_M.set_progress_monitor = function(self, progress_monitor, client_data)
    return lib.MagickSetImageProgressMonitor(self.wand, progress_monitor, client_data)
end

_M.progress_monitor = function(self, text, offset, span, client_data)
    return handle_result(self, lib.MagickProgressMonitor(text, offset, span, client_data))
end

_M.set_red_primary = function(self, x, y, z)
    return handle_result(self, lib.MagickSetImageRedPrimary(self.wand, x, y, z))
end

_M.set_rendering_intent = function(self, intent)
    return handle_result(self, lib.MagickSetImageRenderingIntent(rendering_intent:to_int(intent .. "Intent")))
end

_M.set_resolution = funtion(self, x_resolution, y_resolution)
    return handle_result(self, lib.MagickSetImageResolution(self.wand, x_resolution, y_resolution))
end

_M.set_scene = function(self, scene)
    return handle_result(self, lib.MagickSetImageScene(self.wand, scene))
end

_M.set_ticks_persecond = function(self, ticks)
    return handle_result(self, lib.MagickSetImageTicksPerSecond(self.wand, ticks))
end

_M.set_type = function(self, itype)
    return handle_result(self, lib.MagickSetImageType(image_type:to_int(itype .. "Type")))
end

return _M
