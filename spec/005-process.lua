-- Copyright (C) by Kwanhur Huang


describe("ImageProcess", function()
    local info = debug.getinfo(1, "S")
    local path = info.source
    path = string.sub(path, 2, -1)
    image_dir = string.match(path, "^.*/")
    image_filename = image_dir .. "test_image.png"
    
    local imagick = require("resty.imagick")
    
    local img, msg, code = imagick.load_image(image_filename )
    assert.is_true(img ~= nil)

    it("comment", function()
        local ok, msg, code = img:comment("kwanhur")
        assert.is_true(ok)
        local comment = img:get_property("comment")
        assert.is_true(comment == "kwanhur")
    end)
end)
