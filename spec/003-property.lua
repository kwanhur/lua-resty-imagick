-- Copyright (C) by Kwanhur Huang


describe("ImageProperty", function()
    local info = debug.getinfo(1, "S")
    local path = info.source
    path = string.sub(path, 2, -1)
    image_dir = string.match(path, "^.*/")
    image_filename = image_dir .. "test_image.png"
    
    local imagick = require("resty.imagick")
    
    local img, msg, code = imagick.load_image(image_filename )
    assert.is_true(img ~= nil)

    it("dateCreate", function()
        local date = img:get_property("date:modify")
        assert.is_true(date == "2017-09-20T10:05:22+08:00")

        img:set_property("date:modify", "2018-04-12T15:32:05+08:00")
        date = img:get_property("date:modify")
        assert.is_true(date == "2018-04-12T15:32:05+08:00")
    end)

    it("pngIHDR", function()
        local wh = img:get_property("png:IHDR.width,height")
        assert.is_true(wh == "64, 64")
    end)
end)
