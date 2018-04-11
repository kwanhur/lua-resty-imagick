-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickThumb'
local _M = {}
_M._NAME = modulename

local tonumber = tonumber
local tostring = tostring
local type = type
local assert = assert

_M.parse_size_str = function(str, src_w, src_h)
    local w, h, rest = str:match("^(%d*%%?)x(%d*%%?)(.*)$")
    if not w then
        return nil, "failed to parse string (" .. tostring(str) .. ")"
    end

    local p = w:match("(%d+)%%")
    if p then
        w = tonumber(p) / 100 * src_w
    else
        w = tonumber(w)
    end

    p = h:match("(%d+)%%")
    if p then
        h = tonumber(p) / 100 * src_h
    else
        h = tonumber(h)
    end

    local center_crop = rest:match("#") and true
    local crop_x, crop_y = rest:match("%+(%d+)%+(%d+)")
    if crop_x then
        crop_x = tonumber(crop_x)
        crop_y = tonumber(crop_y)
    else
        if w and h and not center_crop then
            if not (rest:match("!")) then
                if src_w / src_h > w / h then
                    h = nil
                else
                    w = nil
                end
            end
        end
    end

    return {
        w = w,
        h = h,
        crop_x = crop_x,
        crop_y = crop_y,
        center_crop = center_crop
    }
end

_M.make_thumb = function(load_image)
    local thumb = function(img, size_str, output)
        if type(img) == "string" then
            img = assert(load_image(img))
        end
        img:thumb(size_str)
        local ret
        if output then
            ret = img:write(output)
        else
            ret = img:get_blob()
        end
        return ret
    end
    return thumb
end

return _M
