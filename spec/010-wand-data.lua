-- Copyright (C) by Kwanhur Huang


describe("wandData", function()
    it("resolution", function()
        local w_data = require("resty.imagick.wand.data")
        local res = w_data.montage_mode()
        assert.is_true(res:to_int("UnframeMode") == 2)
        assert.is_true(res:to_str(0) == "UndefinedMode")

        res = w_data.resolution_type()
        assert.is_true(res:to_str(2) == "PixelsPerCentimeterResolution")
    end) 
end)
