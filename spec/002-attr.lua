-- Copyright (C) by Kwanhur Huang


describe("ImageAttr", function()
    local info = debug.getinfo(1, "S")
    local path = info.source
    path = string.sub(path, 2, -1)
    image_dir = string.match(path, "^.*/")
    
    local imagick = require("resty.imagick")
    
    local img, msg, code = imagick.load_image(image_dir .. "/test_image.png")
    assert.is_true(img ~= nil)
    it("getWidthHeight", function()
        local w = img:get_width()
        local h = img:get_height()

        assert.is_true(w == 64 and h == 64)
    end)

    it("getSetFormat", function()
        local format = img:get_format()
        assert.is_true(format == "png")

        local ok, msg, code = img:set_format('jpeg')
        assert.truthy(ok)
        format = img:get_format()
        assert.is_true(format == "jpeg")
    end)

    it("getSetQuality", function()
        local quality = img:get_quality()
        assert.truthy(quality == 0)
        img:set_quality(75)
        quality = img:get_quality()
        assert.truthy(quality == 75)
    end)
    
    it("getDepth", function()
        local depth = img:get_depth()
        assert.truthy(depth == 8)
    end)

    it("getUnits", function()
        local unit = img:get_units()
        assert.truthy(unit == "PixelsPerCentimeterResolution")
    end)

    it("getSetGravity", function()
        local gravity = img:get_gravity()
        assert.truthy(gravity == "ForgetGravity")

        img:set_gravity("SouthGravity")
        gravity = img:get_gravity()
        assert.truthy(gravity == "SouthGravity")
    end)

    it("getSetColorspace", function()
        local cs = img:get_colorspace()
        assert.is_true(cs == "LuvColorspace")
        
        img:set_colorspace("RGB")
        cs = img:get_colorspace()
        assert.truthy(cs == "RGBColorspace")
    end)

    it("getSetImageType", function()
        local it = img:get_type()
        assert.is_true(it == "TrueColorAlphaType")

        img:set_type("Bilevel")
        it = img:get_type()
        assert.is_true(it == "BilevelType")
    end)

    it("getSetEndian", function()
        local ed = img:get_endian()
        assert.is_true(ed == "UndefinedEndian")

        img:set_endian("LSB")
        ed = img:get_endian()
        assert.is_true(ed == "LSBEndian")
    end)

    it("getSetRendering", function()
        local re = img:get_rendering_intent()
        assert.is_true(re == "PerceptualIntent")

        img:set_rendering_intent("Relative")
        re = img:get_rendering_intent()
        assert.is_true(re == "RelativeIntent")
    end)

    it("getSetGamma", function()
        local ga = img:get_gamma()
        assert.is_true(ga < 0.45455 and ga > 0.45)

        img:set_gamma(0.4)
        ga = img:get_gamma()
        assert.is_true(0.4 == ga)
    end)

    it("getSetInterlaceScheme", function()
        local int = img:get_interlace_scheme()
        assert.is_true( int == "NoInterlace")

        img:set_interlace_scheme("PNG")
        int = img:get_interlace_scheme()
        assert.is_true(int == "PNGInterlace")
    end)

    it("getSetCompose", function()
        local com = img:get_compose()
        assert.is_true(com == "XorCompositeOp")

        img:set_compose("In")
        com = img:get_compose()
        assert.is_true(com == "InCompositeOp")
    end)

    it("getSetCompression", function()
        local com = img:get_compression()
        assert.is_true("ZipCompression" == com)

        img:set_compression("LZW")
        com = img:get_compression()
        assert.is_true("LZWCompression" == com)
    end)
end)
