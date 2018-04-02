-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandData'
local _M = {}
_M._NAME = modulename

local enum = require("resty.imagick.enum").enum

local composite_operators = enum({
    [0] = "UndefinedCompositeOp",
    "NoCompositeOp",
    "ModulusAddCompositeOp",
    "AtopCompositeOp",
    "BlendCompositeOp",
    "BumpmapCompositeOp",
    "ChangeMaskCompositeOp",
    "ClearCompositeOp",
    "ColorBurnCompositeOp",
    "ColorDodgeCompositeOp",
    "ColorizeCompositeOp",
    "CopyBlackCompositeOp",
    "CopyBlueCompositeOp",
    "CopyCompositeOp",
    "CopyCyanCompositeOp",
    "CopyGreenCompositeOp",
    "CopyMagentaCompositeOp",
    "CopyOpacityCompositeOp",
    "CopyRedCompositeOp",
    "CopyYellowCompositeOp",
    "DarkenCompositeOp",
    "DstAtopCompositeOp",
    "DstCompositeOp",
    "DstInCompositeOp",
    "DstOutCompositeOp",
    "DstOverCompositeOp",
    "DifferenceCompositeOp",
    "DisplaceCompositeOp",
    "DissolveCompositeOp",
    "ExclusionCompositeOp",
    "HardLightCompositeOp",
    "HueCompositeOp",
    "InCompositeOp",
    "LightenCompositeOp",
    "LinearLightCompositeOp",
    "LuminizeCompositeOp",
    "MinusDstCompositeOp",
    "ModulateCompositeOp",
    "MultiplyCompositeOp",
    "OutCompositeOp",
    "OverCompositeOp",
    "OverlayCompositeOp",
    "PlusCompositeOp",
    "ReplaceCompositeOp",
    "SaturateCompositeOp",
    "ScreenCompositeOp",
    "SoftLightCompositeOp",
    "SrcAtopCompositeOp",
    "SrcCompositeOp",
    "SrcInCompositeOp",
    "SrcOutCompositeOp",
    "SrcOverCompositeOp",
    "ModulusSubtractCompositeOp",
    "ThresholdCompositeOp",
    "XorCompositeOp",
    "DivideDstCompositeOp",
    "DistortCompositeOp",
    "BlurCompositeOp",
    "PegtopLightCompositeOp",
    "VividLightCompositeOp",
    "PinLightCompositeOp",
    "LinearDodgeCompositeOp",
    "LinearBurnCompositeOp",
    "MathematicsCompositeOp",
    "DivideSrcCompositeOp",
    "MinusSrcCompositeOp",
    "DarkenIntensityCompositeOp",
    "LightenIntensityCompositeOp",
    "HardMixCompositeOp"
})
local gravity = enum({
    [0] = "ForgetGravity",
    "NorthWestGravity",
    "NorthGravity",
    "NorthEastGravity",
    "WestGravity",
    "CenterGravity",
    "EastGravity",
    "SouthWestGravity",
    "SouthGravity",
    "SouthEastGravity",
    "StaticGravity"
})
local orientation = enum({
    [0] = "UndefinedOrientation",
    "TopLeftOrientation",
    "TopRightOrientation",
    "BottomRightOrientation",
    "BottomLeftOrientation",
    "LeftTopOrientation",
    "RightTopOrientation",
    "RightBottomOrientation",
    "LeftBottomOrientation"
})
local interlace = enum({
    [0] = "UndefinedInterlace",
    "NoInterlace",
    "LineInterlace",
    "PlaneInterlace",
    "PartitionInterlace",
    "GIFInterlace",
    "JPEGInterlace",
    "PNGInterlace"
})
local filter_type = enum({
    [0] = "UndefinedFilter",
    "PointFilter",
    "BoxFilter",
    "TriangleFilter",
    "HermiteFilter",
    "HannFilter",
    "HammingFilter",
    "BlackmanFilter",
    "GaussianFilter",
    "QuadraticFilter",
    "CubicFilter",
    "CatromFilter",
    "MitchellFilter",
    "JincFilter",
    "SincFilter",
    "SincFastFilter",
    "KaiserFilter",
    "WelchFilter",
    "ParzenFilter",
    "BohmanFilter",
    "BartlettFilter",
    "LagrangeFilter",
    "LanczosFilter",
    "LanczosSharpFilter",
    "Lanczos2Filter",
    "Lanczos2SharpFilter",
    "RobidouxFilter",
    "RobidouxSharpFilter",
    "CosineFilter",
    "SplineFilter",
    "LanczosRadiusFilter",
    "CubicSplineFilter",
    "SentinelFilter"
})

local storage_type = enum({
    [0] = "UndefinedPixel",
    "CharPixel",
    "DoublePixel",
    "FloatPixel",
    "LongPixel",
    "LongLongPixel",
    "QuantumPixel",
    "ShortPixel"
})

local distort_method = enum({
    [0] = "UndefinedDistortion",
    "AffineDistortion",
    "AffineProjectionDistortion",
    "ScaleRotateTranslateDistortion",
    "PerspectiveDistortion",
    "PerspectiveProjectionDistortion",
    "BilinearForwardDistortion",
    --    BilinearDistortion = BilinearForwardDistortion,
    "BilinearReverseDistortion",
    "PolynomialDistortion",
    "ArcDistortion",
    "PolarDistortion",
    "DePolarDistortion",
    "Cylinder2PlaneDistortion",
    "Plane2CylinderDistortion",
    "BarrelDistortion",
    "BarrelInverseDistortion",
    "ShepardsDistortion",
    "ResizeDistortion",
    "SentinelDistortion"
})

local evaluate_operator = enum({
    [0] = "UndefinedEvaluateOperator",
    "AbsEvaluateOperator",
    "AddEvaluateOperator",
    "AddModulusEvaluateOperator",
    "AndEvaluateOperator",
    "CosineEvaluateOperator",
    "DivideEvaluateOperator",
    "ExponentialEvaluateOperator",
    "GaussianNoiseEvaluateOperator",
    "ImpulseNoiseEvaluateOperator",
    "LaplacianNoiseEvaluateOperator",
    "LeftShiftEvaluateOperator",
    "LogEvaluateOperator",
    "MaxEvaluateOperator",
    "MeanEvaluateOperator",
    "MedianEvaluateOperator",
    "MinEvaluateOperator",
    "MultiplicativeNoiseEvaluateOperator",
    "MultiplyEvaluateOperator",
    "OrEvaluateOperator",
    "PoissonNoiseEvaluateOperator",
    "PowEvaluateOperator",
    "RightShiftEvaluateOperator",
    "RootMeanSquareEvaluateOperator",
    "SetEvaluateOperator",
    "SineEvaluateOperator",
    "SubtractEvaluateOperator",
    "SumEvaluateOperator",
    "ThresholdBlackEvaluateOperator",
    "ThresholdEvaluateOperator",
    "ThresholdWhiteEvaluateOperator",
    "UniformNoiseEvaluateOperator",
    "XorEvaluateOperator"
})

local functions = enum({
    [0] = "UndefinedFunction",
    "ArcsinFunction",
    "ArctanFunction",
    "PolynomialFunction",
    "SinusoidFunction"
})

local colorspace_type = enum({
    [0] = "UndefinedColorspace",
    "RGBColorspace",
    "GRAYColorspace",
    "TransparentColorspace",
    "OHTAColorspace",
    "LabColorspace",
    "XYZColorspace",
    "YCbCrColorspace",
    "YCCColorspace",
    "YIQColorspace",
    "YPbPrColorspace",
    "YUVColorspace",
    "CMYKColorspace",
    "sRGBColorspace",
    "HSBColorspace",
    "HSLColorspace",
    "HWBColorspace",
    "Rec601LumaColorspace",
    "Rec601YCbCrColorspace",
    "Rec709LumaColorspace",
    "Rec709YCbCrColorspace",
    "LogColorspace",
    "CMYColorspace",
    "LuvColorspace",
    "HCLColorspace",
    "LCHColorspace",
    "LMSColorspace",
    "LCHabColorspace",
    "LCHuvColorspace",
    "scRGBColorspace",
    "HSIColorspace",
    "HSVColorspace",
    "HCLpColorspace",
    "YDbDrColorspace"
})

local compression_type = enum({
    [0] = "UndefinedCompression",
    "B44ACompression",
    "B44Compression",
    "BZipCompression",
    "DXT1Compression",
    "DXT3Compression",
    "DXT5Compression",
    "FaxCompression",
    "Group4Compression",
    "JBIG1Compression",
    "JBIG2Compression",
    "JPEG2000Compression",
    "JPEGCompression",
    "LosslessJPEGCompression",
    "LZMACompression",
    "LZWCompression",
    "NoCompression",
    "PizCompression",
    "Pxr24Compression",
    "RLECompression",
    "ZipCompression",
    "ZipSCompression"
})

_M.composite_operators = composite_operators

_M.gravity = gravity

_M.orientation = orientation

_M.interlace = interlace

_M.filter_type = filter_type

_M.storage_type = storage_type

_M.distort_method = distort_method

_M.evaluate_operator = evaluate_operator

_M.functions = functions

_M.colorspace_type = colorspace_type

_M.compression_type = compression_type

return _M
