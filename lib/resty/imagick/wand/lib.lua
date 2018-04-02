-- Copyright (C) by Kwanhur Huang


local modulename = 'restyImagickWandLib'
local _M = {}
_M._NAME = modulename

local ffi = require("ffi")

local tostring = tostring
local open = io.popen
local type = type
local pcall = pcall
local error = error

ffi.cdef([[  typedef void MagickWand;
  typedef void PixelWand;
  typedef void DrawingWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int ssize_t;
  typedef int CompositeOperator;
  typedef int GravityType;
  typedef int OrientationType;
  typedef int InterlaceType;
  typedef int FilterType;
  typedef int StorageType;
  typedef int DistortMethod;
  typedef int MagickEvaluateOperator;
  typedef int MagickFunction;

  void MagickWandGenesis();
  MagickWand* NewMagickWand();
  MagickWand* CloneMagickWand(const MagickWand *wand);
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);

  MagickBooleanType MagickAddImage(MagickWand*, const MagickWand*);

  MagickBooleanType MagickAdaptiveBlurImage(MagickWand *wand,const double radius,const double sigma);
  MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);
  MagickBooleanType MagickAdaptiveSharpenImage(MagickWand *wand,const double radius,const double sigma);
  MagickBooleanType MagickAdaptiveThresholdImage(MagickWand *wand,const size_t width,const size_t height,const double bias);

  MagickBooleanType MagickWriteImage(MagickWand*, const char*);

  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);

  void* MagickRelinquishMemory(void*);

  MagickBooleanType MagickCropImage(MagickWand*,
    const size_t, const size_t, const ssize_t, const ssize_t);

  MagickBooleanType MagickBlurImage(MagickWand*, const double, const double);
  MagickBooleanType MagickModulateImage(MagickWand*, const double, const double, const double);
  MagickBooleanType MagickBrightnessContrastImage(MagickWand*, const double, const double);

  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);
  char* MagickGetImageFormat(MagickWand* wand);

  size_t MagickGetImageCompressionQuality(MagickWand * wand);
  MagickBooleanType MagickSetImageCompressionQuality(MagickWand *wand,
  const size_t quality);

  MagickBooleanType MagickSharpenImage(MagickWand *wand,
    const double radius,const double sigma);

  MagickBooleanType MagickScaleImage(MagickWand *wand,
    const size_t columns,const size_t rows);

  MagickBooleanType MagickRotateImage(MagickWand *wand,
  const PixelWand *background,const double degrees);

  MagickBooleanType MagickSetOption(MagickWand *,const char *,const char *);
  char* MagickGetOption(MagickWand *,const char *);

  MagickBooleanType MagickCompositeImage(MagickWand *wand,
    const MagickWand *source_wand,const CompositeOperator compose,
    const ssize_t x,const ssize_t y);

  GravityType MagickGetImageGravity(MagickWand *wand);
  MagickBooleanType MagickSetImageGravity(MagickWand *wand,
    const GravityType gravity);

  MagickBooleanType MagickStripImage(MagickWand *wand);

  MagickBooleanType MagickGetImagePixelColor(MagickWand *wand,
    const ssize_t x,const ssize_t y,PixelWand *color);

  MagickWand* MagickCoalesceImages(MagickWand*);

  PixelWand *NewPixelWand(void);
  PixelWand *DestroyPixelWand(PixelWand *);

  double PixelGetAlpha(const PixelWand *);
  double PixelGetRed(const PixelWand *);
  double PixelGetGreen(const PixelWand *);
  double PixelGetBlue(const PixelWand *);

  void PixelSetAlpha(PixelWand *wand, const double alpha);
  void PixelSetRed(PixelWand *wand, const double red);
  void PixelSetGreen(PixelWand *wand, const double green);
  void PixelSetBlue(PixelWand *wand, const double blue);

  MagickBooleanType MagickTransposeImage(MagickWand *wand);

  MagickBooleanType MagickTransverseImage(MagickWand *wand);

  MagickBooleanType MagickFlipImage(MagickWand *wand);

  MagickBooleanType MagickFlopImage(MagickWand *wand);

  char* MagickGetImageProperty(MagickWand *wand, const char *property);
  MagickBooleanType MagickSetImageProperty(MagickWand *wand,
    const char *property,const char *value);

  OrientationType MagickGetImageOrientation(MagickWand *wand);
  MagickBooleanType MagickSetImageOrientation(MagickWand *wand,
    const OrientationType orientation);

  InterlaceType MagickGetImageInterlaceScheme(MagickWand *wand);
  MagickBooleanType MagickSetImageInterlaceScheme(MagickWand *wand,
    const InterlaceType interlace_scheme);

  MagickBooleanType MagickAutoOrientImage(MagickWand *wand);
  MagickBooleanType MagickAutoGammaImage(MagickWand *wand);
  MagickBooleanType MagickAutoLevelImage(MagickWand *wand);

  MagickBooleanType MagickResetImagePage(MagickWand *wand, const char *page);

  MagickBooleanType MagickSetImageDepth(MagickWand *,const unsigned long);
  unsigned long MagickGetImageDepth(MagickWand *);

  unsigned char *MagickGetImageProfile(MagickWand *wand,const char *name,
  size_t *length);

  MagickBooleanType MagickSetImageProfile(MagickWand *wand,const char *name,
  const void *profile,const size_t length);

  MagickBooleanType MagickResizeImage(MagickWand*,const size_t, const size_t,
  const FilterType, const double);

  MagickBooleanType MagickAnimateImages(MagickWand *wand,const char *server_name);

  MagickBooleanType MagickBlackThresholdImage(MagickWand *wand,
  const PixelWand *threshold);

  MagickBooleanType MagickBlueShiftImage(MagickWand *wand,
  const double factor);

  MagickBooleanType MagickBorderImage(MagickWand *wand,
  const PixelWand *bordercolor,const size_t width,
  const size_t height,const CompositeOperator compose);

  MagickBooleanType MagickCharcoalImage(MagickWand *wand,
  const double radius,const double sigma);

  MagickBooleanType MagickChopImage(MagickWand *wand,
  const size_t width,const size_t height,const ssize_t x,
  const ssize_t y);

  MagickBooleanType MagickClampImage(MagickWand *wand);
  MagickBooleanType MagickClipImage(MagickWand *wand);
  MagickBooleanType MagickClipImagePath(MagickWand *wand,
  const char *pathname,const MagickBooleanType inside);

  MagickBooleanType MagickCommentImage(MagickWand *wand,
  const char *comment);

  MagickBooleanType MagickContrastImage(MagickWand *wand,
  const MagickBooleanType sharpen);

  MagickBooleanType MagickContrastStretchImage(MagickWand *wand,
  const double black_point,const double white_point);

  MagickBooleanType MagickCycleColormapImage(MagickWand *wand,
  const ssize_t displace);

  MagickBooleanType MagickConstituteImage(MagickWand *wand,
  const size_t columns,const size_t rows,const char *map,
  const StorageType storage,void *pixels);

  MagickBooleanType MagickDecipherImage(MagickWand *wand,
  const char *passphrase);

  MagickWand *MagickDeconstructImages(MagickWand *wand);

  MagickBooleanType MagickDeskewImage(MagickWand *wand,
  const double threshold);

  MagickBooleanType MagickDespeckleImage(MagickWand *wand);

  MagickBooleanType MagickDisplayImage(MagickWand *wand,
  const char *server_name);

  MagickBooleanType MagickDisplayImages(MagickWand *wand,
  const char *server_name);

  MagickBooleanType MagickDistortImage(MagickWand *wand,
  const DistortMethod method,const size_t number_arguments,
  const double *arguments,const MagickBooleanType bestfit);

  MagickBooleanType MagickDrawImage(MagickWand *wand,
  const DrawingWand *drawing_wand);

  MagickBooleanType MagickEdgeImage(MagickWand *wand,const double radius);

  MagickBooleanType MagickEmbossImage(MagickWand *wand,const double radius,
  const double sigma);

  MagickBooleanType MagickEncipherImage(MagickWand *wand,
  const char *passphrase);

  MagickBooleanType MagickEnhanceImage(MagickWand *wand);

  MagickBooleanType MagickEqualizeImage(MagickWand *wand);

  MagickBooleanType MagickEvaluateImage(MagickWand *wand,
  const MagickEvaluateOperator operator,const double value);

  MagickBooleanType MagickExportImagePixels(MagickWand *wand,
  const ssize_t x,const ssize_t y,const size_t columns,
  const size_t rows,const char *map,const StorageType storage,
  void *pixels);

  MagickBooleanType MagickExtentImage(MagickWand *wand,const size_t width,
  const size_t height,const ssize_t x,const ssize_t y);

  MagickBooleanType MagickFloodfillPaintImage(MagickWand *wand,
  const PixelWand *fill,const double fuzz,const PixelWand *bordercolor,
  const ssize_t x,const ssize_t y,const MagickBooleanType invert);

  MagickBooleanType MagickForwardFourierTransformImage(MagickWand *wand,
  const MagickBooleanType magnitude);

  MagickBooleanType MagickFrameImage(MagickWand *wand,
  const PixelWand *matte_color,const size_t width,
  const size_t height,const ssize_t inner_bevel,
  const ssize_t outer_bevel,const CompositeOperator compose);

  MagickBooleanType MagickFunctionImage(MagickWand *wand,
  const MagickFunction function,const size_t number_arguments,
  const double *arguments);

  MagickWand *MagickFxImage(MagickWand *wand,const char *expression);

  MagickBooleanType MagickGammaImage(MagickWand *wand,const double gamma);

  MagickBooleanType MagickGaussianBlurImage(MagickWand *wand,
  const double radius,const double sigma);

  MagickWand *MagickGetImage(MagickWand *wand);

  MagickBooleanType MagickGetImageAlphaChannel(MagickWand *wand);

  MagickWand *MagickGetImageMask(MagickWand *wand);

  MagickBooleanType MagickGetImageBackgroundColor(MagickWand *wand,
  PixelWand *background_color);

  unsigned char *MagickGetImagesBlob(MagickWand *wand,size_t *length);

  MagickBooleanType MagickGetImageBluePrimary(MagickWand *wand,double *x,
  double *y,double *z);
  MagickBooleanType MagickGetImageRedPrimary(MagickWand *wand,double *x,
  double *y, double *z);

  MagickBooleanType MagickGetImageBorderColor(MagickWand *wand,
  PixelWand *border_color);

  MagickBooleanType MagickGetImageKurtosis(MagickWand *wand,
  double *kurtosis,double *skewness);

  MagickBooleanType MagickGetImageMean(MagickWand *wand,double *mean,
  double *standard_deviation);

  MagickBooleanType MagickGetImageRange(MagickWand *wand,double *minima,
  double *maxima);

  MagickBooleanType MagickGetImageColormapColor(MagickWand *wand,
  const size_t index,PixelWand *color);

  size_t MagickGetImageColors(MagickWand *wand);

  ColorspaceType MagickGetImageColorspace(MagickWand *wand);

  CompositeOperator MagickGetImageCompose(MagickWand *wand);

  CompressionType MagickGetImageCompression(MagickWand *wand);

  size_t MagickGetImageDelay(MagickWand *wand);

  DisposeType MagickGetImageDispose(MagickWand *wand);

  EndianType MagickGetImageEndian(MagickWand *wand);

  char *MagickGetImageFilename(MagickWand *wand);

  double MagickGetImageFuzz(MagickWand *wand);

  double MagickGetImageGamma(MagickWand *wand);

  PixelWand **MagickGetImageHistogram(MagickWand *wand,
  size_t *number_colors);

  PixelInterpolateMethod MagickGetImageInterpolateMethod(MagickWand *wand);

  size_t MagickGetImageIterations(MagickWand *wand);

  MagickBooleanType MagickGetImageMatteColor(MagickWand *wand,
  PixelWand *matte_color);

  MagickBooleanType MagickGetImagePage(MagickWand *wand,
  size_t *width,size_t *height,ssize_t *x,ssize_t *y);

  MagickBooleanType MagickGetImagePixelColor(MagickWand *wand,
  const ssize_t x,const ssize_t y,PixelWand *color);

  MagickWand *MagickGetImageRegion(MagickWand *wand,
  const size_t width,const size_t height,const ssize_t x,
  const ssize_t y);
]])

local get_flags
get_flags = function()
    local proc = open("pkg-config --cflags --libs MagickWand", "r")
    local flags = proc:read("*a")
    get_flags = function()
        return flags
    end
    proc:close()
    return flags
end

local try_to_load = function(...)
    local out
    local args = {...}
    for i = 1, #args do
        local continue = false
        repeat
            local name = args[i]
            if "function" == type(name) then
                name = name()
                if not (name) then
                    continue = true
                    break
                end
            end
            if pcall(function()
                out = ffi.load(name)
            end) then
                return out
            end
            continue = true
        until true
        if not continue then
            break
        end
    end
    return error("Failed to load ImageMagick (" .. tostring(...) .. ")")
end

local lib = try_to_load("MagickWand", function()
    local lname = get_flags():match("-l(MagickWand[^%s]*)")
    local suffix
    if ffi.os == "OSX" then
        suffix = ".dylib"
    elseif ffi.os == "Windows" then
        suffix = ".dll"
    else
        suffix = ".so"
    end
    return lname and "lib" .. lname .. suffix
end)

_M.lib = lib

_M.can_resize = true

_M.get_filter = function(name)
    return lib[name .. "Filter"]
end

return _M
