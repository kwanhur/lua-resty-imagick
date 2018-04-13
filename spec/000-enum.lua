-- Copyright (C) by Kwanhur Huang


describe("enum", function()
    local enummer = require("resty.imagick.enum")
    local enum = function(t)
        return enummer:new(t)
    end

    local c = enum({
        [0] = "cundefinedEnum",
        "cfirstEnum",
        "csecondEnum",
        "cthirdEnum",
        "dthirdEnum",
        "ethirdEnum"
        })

    local d = enum({
        [0] = "undefinedEnum",
        "firstEnum",
        "secondEnum",
        "thirdEnum"
        })

    it("to_int", function()
        local i = d:to_int("firstEnum")
        assert.is_true(i == 1)
        assert.is_false(i == 0)
    end)

    it("to_str", function()
        local str = d:to_str(2)
        assert.is_true(str == "secondEnum")
    end)

    it("resolution", function()
        local w_data = require("resty.imagick.wand.data")
        local res = w_data.resolution_type
        print(#res.t)
        print(res:to_str(0))
        -- assert.is_true(res:to_int("PixelsPerCentimeterResolution") == 2)
        assert.is_true(res:to_str(0) == "UndefinedResolution")
    end)
end)
