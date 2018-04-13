-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickEnum'
local _M = {}
local _mt = { __index = _M }
_M._NAME = modulename

local setmetatable = setmetatable
local ipairs = ipairs
local type = type

_M.new = function(self, t)
    local keys
    local key = { }
    local index = 1
    for i in ipairs(t) do
        key[index] = i
        index = index + 1
    end
    keys = key

    for j = 1, #keys do
        local key = keys[j]
        t[t[key]] = key
    end

    self.t = t
    return setmetatable(self, mt)
end

_M.to_str = function(self, val)
    if type(val) == "string" then
        return val
    end
    return self.t[val]
end

_M.to_int = function(self, val)
    if type(val) == "number" then
        return val
    end
    return self.t[val]
end

return _M
