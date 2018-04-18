-- Copyright (C) by Kwanhur Huang


describe("ImageColor", function()
    local info = debug.getinfo(1, "S")
    local path = info.source
    path = string.sub(path, 2, -1)
    image_dir = string.match(path, "^.*/")
    image_filename = image_dir .. "test_image.png"
    
    local imagick = require("resty.imagick")
    
    local img, msg, code = imagick.load_image(image_filename )
    assert.is_true(img ~= nil)

    it("colorDecision", function()
        local dec, msg, code = img:color_decision_list(1024)
        assert.is_true(dec == '')
    end)
end)
