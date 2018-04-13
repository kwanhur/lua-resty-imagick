-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandData'
local _M = {}
local mt = {__index = _M}
_M._NAME = modulename

local enummer = require("resty.imagick.enum")
local enum = function(t)
    local e =  enummer:new(t)
    return e
end

local CompositeOperators = {
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
}

local gravity = {
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
}
local orientation = {
    [0] = "UndefinedOrientation",
    "TopLeftOrientation",
    "TopRightOrientation",
    "BottomRightOrientation",
    "BottomLeftOrientation",
    "LeftTopOrientation",
    "RightTopOrientation",
    "RightBottomOrientation",
    "LeftBottomOrientation"
}

local interlace = {
    [0] = "UndefinedInterlace",
    "NoInterlace",
    "LineInterlace",
    "PlaneInterlace",
    "PartitionInterlace",
    "GIFInterlace",
    "JPEGInterlace",
    "PNGInterlace"
}

local FilterType = {
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
}

local StorageType = {
    [0] = "UndefinedPixel",
    "CharPixel",
    "DoublePixel",
    "FloatPixel",
    "LongPixel",
    "LongLongPixel",
    "QuantumPixel",
    "ShortPixel"
}

local PreivewType = {
    [0] = "UndefinedPreview",
    "RotatePreview",
    "ShearPreview",
    "RollPreview",
    "HuePreview",
    "SaturationPreview",
    "BrightnessPreview",
    "GammaPreview",
    "SpiffPreview",
    "DullPreview",
    "GrayscalePreview",
    "QuantizePreview",
    "DespecklePreview",
    "ReduceNoisePreview",
    "AddNoisePreview",
    "SharpenPreview",
    "BlurPreview",
    "ThresholdPreview",
    "EdgeDetectPreview",
    "SpreadPreview",
    "SolarizePreview",
    "ShadePreview",
    "RaisePreview",
    "SegmentPreview",
    "SwirlPreview",
    "ImplodePreview",
    "WavePreview",
    "OilPaintPreview",
    "CharcoalDrawingPreview",
    "JPEGPreview"
}

local DistortMethod = {
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
}

local VirtualPixelMethod = {
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
}

local LayerMethod = {
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
}

local EvaluateOperator = {
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
}

local functions = {
    [0] = "UndefinedFunction",
    "ArcsinFunction",
    "ArctanFunction",
    "PolynomialFunction",
    "SinusoidFunction"
}

local ColorspaceType = {
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
}

local CompressionType = {
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
}

local DisposeType = {
    [-1] = "UnrecognizedDispose",
    [0] = "UndefinedDispose",
    [1] = "NoneDispose",
    [2] = "BackgroundDispose",
    [3] = "PreviousDispose"
}

local EndianType = {
    [0] = "UndefinedEndian",
    "LSBEndian",
    "MSBEndian"
}

local ImageType = {
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
}

local ResolutionType = {
    [0] = "UndefinedResolution",
    "PixelsPerInchResolution",
    "PixelsPerCentimeterResolution"
}

local MetricType = {
    [0] = "UndefinedErrorMetric",
    "AbsoluteErrorMetric",
    "FuzzErrorMetric",
    "MeanAbsoluteErrorMetric",
    "MeanErrorPerPixelErrorMetric",
    "MeanSquaredErrorMetric",
    "NormalizedCrossCorrelationErrorMetric",
    "PeakAbsoluteErrorMetric",
    "PeakSignalToNoiseRatioErrorMetric",
    "PerceptualHashErrorMetric",
    "RootMeanSquaredErrorMetric",
    "StructuralSimilarityErrorMetric",
    "StructuralDissimilarityErrorMetric"
}

local GravityType = {
    [-1] = "UndefinedGravity",
    [0] = "ForgetGravity",
    [1] = "NorthWestGravity",
    [2] = "NorthGravity",
    [3] = "NorthEastGravity",
    [4] = "WestGravity",
    [5] = "CenterGravity",
    [6] = "EastGravity",
    [7] = "SouthWestGravity",
    [8] = "SouthGravity",
    [9] = "SouthEastGravity"
}

local StatisticType = {
    [0] = "UndefinedStatistic",
    "GradientStatistic",
    "MaximumStatistic",
    "MeanStatistic",
    "MedianStatistic",
    "MinimumStatistic",
    "ModeStatistic",
    "NonpeakStatistic",
    "RootMeanSquareStatistic",
    "StandardDeviationStatistic"
}

local PixelInterpolateMethod = {
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
}

local RenderingIntent = {
    [0] = "UndefinedIntent",
    "SaturationIntent",
    "PerceptualIntent",
    "AbsoluteIntent",
    "RelativeIntent"
}

local MontageMode = {
    [0] = "UndefinedMode",
    "FrameMode",
    "UnframeMode",
    "ConcatenateMode"
}

local MorphologyMethod = {
    [0] = "UndefinedMorphology",
    --/* Convolve / Correlate weighted sums */
    "ConvolveMorphology",
    "CorrelateMorphology",
    --/* Low-level Morphology methods */
    "ErodeMorphology",
    "DilateMorphology",
    "ErodeIntensityMorphology",
    "DilateIntensityMorphology",
    "IterativeDistanceMorphology",
    --/* Second-level Morphology methods */
    "OpenMorphology",
    "CloseMorphology",
    "OpenIntensityMorphology",
    "CloseIntensityMorphology",
    "SmoothMorphology",
    --/* Difference Morphology methods */
    "EdgeInMorphology",
    "EdgeOutMorphology",
    "EdgeMorphology",
    "TopHatMorphology",
    "BottomHatMorphology",
    --/* Recursive Morphology methods */
    "HitAndMissMorphology",
    "ThinningMorphology",
    "ThickenMorphology",
    --/* Directly Applied Morphology methods */
    "DistanceMorphology",
    "VoronoiMorphology"
}

local DitherMethod = {
    [0] = "UndefinedDitherMethod",
    "NoDitherMethod",
    "RiemersmaDitherMethod",
    "FloydSteinbergDitherMethod"
}

local AlphaChannelOption = {
    [0] = "UndefinedAlphaChannel",
    "ActivateAlphaChannel",
    "AssociateAlphaChannel",
    "BackgroundAlphaChannel",
    "CopyAlphaChannel",
    "DeactivateAlphaChannel",
    "DiscreteAlphaChannel",
    "DisassociateAlphaChannel",
    "ExtractAlphaChannel",
    "OffAlphaChannel",
    "OnAlphaChannel",
    "OpaqueAlphaChannel",
    "RemoveAlphaChannel",
    "SetAlphaChannel",
    "ShapeAlphaChannel",
    "TransparentAlphaChannel"
} 

local SparseColorMethod = {
    [0] = "UndefinedColorInterpolate",
    [1] = "BarycentricColorInterpolate",
    [8] = "BilinearColorInterpolate",
    [9] = "PolynomialColorInterpolate",
    [17] = "ShepardsColorInterpolate",
    [19] = "VoronoiColorInterpolate",
    [20] = "InverseColorInterpolate",
    [21] = "ManhattanColorInterpolate"
}

_M.composite_operators = function()
    return enum(CompositeOperators)
end

_M.gravity_type = function()
    return enum(GravityType)
end

_M.orientation = function()
    return enum(orientation)
end

_M.interlace = function()
    return enum(interlace)
end

_M.filter_type = function()
    return enum(FilterType)
end

_M.statistic_type = function()
    return enum(StatisticType)
end

_M.storage_type = function()
    return enum(StorageType)
end

_M.distort_method = function()
    return enum(DistortMethod)
end

_M.virtual_pixel_method = function()
    return enum(VirtualPixelMethod)
end

_M.layer_method = function()
    return enum(LayerMethod)
end

_M.sparse_color_method = function()
    return enum(SparseColorMethod)
end

_M.evaluate_operator = function()
    return enum(EvaluateOperator)
end

_M.functions = function()
    return enum(functions)
end

_M.colorspace_type = function()
    return enum(ColorspaceType)
end

_M.compression_type = function()
    return enum(CompressionType)
end

_M.dispose_type = function()
    return enum(DisposeType)
end

_M.endian_type = function()
    return enum(EndianType)
end

_M.image_type = function()
    return enum(ImageType)
end

_M.resolution_type = function()
    return enum(ResolutionType)
end

_M.metric_type = function()
    return enum(MetricType)
end

_M.preview_type = function()
    return enum(PreivewType)
end

_M.pixel_interpolate_method = function()
    return enum(PixelInterpolateMethod)
end

_M.morphology_method = function()
    return enum(MorphologyMethod)
end

_M.dither_method = function()
    return enum(DitherMethod)
end

_M.rendering_intent = function()
    return enum(RenderingIntent)
end

_M.montage_mode = function()
    return enum(MontageMode)
end

_M.alpha_channel_option = function()
    return enum(AlphaChannelOption)
end

return _M
