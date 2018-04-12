-- Copyright (C) by Kwanhur Huang


describe("LoadImage", function()
    local path = require('path')
    local image_path = path.new('/')
    local image_dir = image_path.join(path.currentdir(), "spec")

    local imagick = require("resty.imagick")
    
    it("loadPNGImage", function()
        local img, msg, code = imagick.load_image(image_dir .. "/test_image.png")
        assert.is_true(img ~= nil)
    end)

    it("loadJPGImage", function()
        local img, msg, code = imagick.load_image(image_dir .. "/test_image.jpg")
        assert.is_true(img ~= nil)
    end)
end)
