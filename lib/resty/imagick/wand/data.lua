-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandData'
local _M = {}
_M._NAME = modulename

local enum = require("resty.imagick.enum").enum

local CompositeOperators = enum({
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
local FilterType = enum({
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

local StorageType = enum({
    [0] = "UndefinedPixel",
    "CharPixel",
    "DoublePixel",
    "FloatPixel",
    "LongPixel",
    "LongLongPixel",
    "QuantumPixel",
    "ShortPixel"
})

local DistortMethod = enum({
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

local VirtualPixelMethod = enum({
    [0] = "UndefinedVirtualPixelMethod",
    "BackgroundVirtualPixelMethod",
    "DitherVirtualPixelMethod",
    "EdgeVirtualPixelMethod",
    "MirrorVirtualPixelMethod",
    "RandomVirtualPixelMethod",
    "TileVirtualPixelMethod",
    "TransparentVirtualPixelMethod",
    "MaskVirtualPixelMethod",
    "BlackVirtualPixelMethod",
    "GrayVirtualPixelMethod",
    "WhiteVirtualPixelMethod",
    "HorizontalTileVirtualPixelMethod",
    "VerticalTileVirtualPixelMethod",
    "HorizontalTileEdgeVirtualPixelMethod",
    "VerticalTileEdgeVirtualPixelMethod",
    "CheckerTileVirtualPixelMethod"
})

local LayerMethod = enum({
    [0] = "UndefinedLayer",
    "CoalesceLayer",
    "CompareAnyLayer",
    "CompareClearLayer",
    "CompareOverlayLayer",
    "DisposeLayer",
    "OptimizeLayer",
    "OptimizeImageLayer",
    "OptimizePlusLayer",
    "OptimizeTransLayer",
    "RemoveDupsLayer",
    "RemoveZeroLayer",
    "CompositeLayer",
    "MergeLayer",
    "FlattenLayer",
    "MosaicLayer",
    "TrimBoundsLayer"
})

local EvaluateOperator = enum({
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

local ColorspaceType = enum({
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

local CompressionType = enum({
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

local DisposeType = enum({
    [-1] = "UnrecognizedDispose",
    [0] = "UndefinedDispose",
    [1] = "NoneDispose",
    [2] = "BackgroundDispose",
    [3] = "PreviousDispose"
})

local EndianType = enum({
    [0] = "UndefinedEndian",
    "LSBEndian",
    "MSBEndian"
})

local ImageType = enum({
    [0] = "UndefinedType",
    "BilevelType",
    "GrayscaleType",
    "GrayscaleAlphaType",
    "PaletteType",
    "PaletteAlphaType",
    "TrueColorType",
    "TrueColorAlphaType",
    "ColorSeparationType",
    "ColorSeparationAlphaType",
    "OptimizeType",
    "PaletteBilevelAlphaType"
})

local ResolutionType = enum({
    [0] = "UndefinedResolution",
    "PixelsPerInchResolution",
    "PixelsPerCentimeterResolution"
})

local PixelInterpolateMethod = enum({
    [0] = "UndefinedInterpolatePixel",
    "AverageInterpolatePixel",
    "Average9InterpolatePixel",
    "Average16InterpolatePixel",
    "BackgroundInterpolatePixel",
    "BilinearInterpolatePixel",
    "BlendInterpolatePixel",
    "CatromInterpolatePixel",
    "IntegerInterpolatePixel",
    "MeshInterpolatePixel",
    "NearestInterpolatePixel",
    "SplineInterpolatePixel"
})

local RenderingIntent = enum({
    [0] = "UndefinedIntent",
    "SaturationIntent",
    "PerceptualIntent",
    "AbsoluteIntent",
    "RelativeIntent"
})

local MontageMode = enum({
    [0] = "UndefinedMode",
    "FrameMode",
    "UnframeMode",
    "ConcatenateMode"
})

_M.composite_operators = CompositeOperators

_M.gravity = gravity

_M.orientation = orientation

_M.interlace = interlace

_M.filter_type = FilterType

_M.storage_type = StorageType

_M.distort_method = DistortMethod

_M.virtual_pixel_method = VirtualPixelMethod

_M.layer_method = LayerMethod

_M.evaluate_operator = EvaluateOperator

_M.functions = functions

_M.colorspace_type = ColorspaceType

_M.compression_type = CompressionType

_M.dispose_type = DisposeType

_M.endian_type = EndianType

_M.image_type = ImageType

_M.resolution_type = ResolutionType

_M.pixel_interpolate_method = PixelInterpolateMethod

_M.rendering_intent = RenderingIntent

_M.montage_mode = MontageMode

return _M
