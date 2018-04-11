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

ffi.cdef([[
  struct _IO_FILE;
  typedef struct _IO_FILE FILE;

  typedef void MagickWand;
  typedef void PixelWand;
  typedef void DrawingWand;
  typedef void KernelInfo;
  typedef void RectangeInfo;

  typedef int MagickBooleanType;
  typedef long long MagickOffsetType;
  typedef unsigned long long MagickSizeType;
  typedef int ExceptionType;
  typedef int ssize_t;
  typedef int CompositeOperator;
  typedef int EvaluateOperator;
  typedef int GravityType;
  typedef int OrientationType;
  typedef int InterlaceType;
  typedef int FilterType;
  typedef int StorageType;
  typedef int ColorspaceType;
  typedef int CompressionType;
  typedef int DisposeType;
  typedef int EndianType;
  typedef int ImageType;
  typedef int ResolutionType;
  typedef int MetricType;
  typedef int PreviewType;
  typedef int ChannelType;
  typedef int StatisticType;
  typedef int DistortMethod;
  typedef int DitherMethod;
  typedef int PixelInterpolateMethod;
  typedef int MorphologyMethod;
  typedef int LayerMethod;
  typedef int VirtualPixelMethod;
  typedef int SparseColorMethod;
  typedef int MagickEvaluateOperator;
  typedef int MagickFunction;
  typedef int MontageMode;
  typedef int RenderingIntent;
  typedef int AlphaChannelOption;

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
  MagickBooleanType MagickAdaptiveThresholdImage(MagickWand *wand,const size_t width,const size_t height,
    const double bias);

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

  MagickBooleanType MagickBlackThresholdImage(MagickWand *wand,const PixelWand *threshold);

  MagickBooleanType MagickBlueShiftImage(MagickWand *wand, const double factor);

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

  MagickBooleanType MagickClutImage(MagickWand *wand,
    const MagickWand *clut_wand,const PixelInterpolateMethod method);

  MagickBooleanType MagickColorDecisionListImage(MagickWand *wand,
    const char *color_correction_collection);

  MagickBooleanType MagickColorizeImage(MagickWand *wand,
     const PixelWand *colorize,const PixelWand *blend);

  MagickBooleanType MagickColorMatrixImage(MagickWand *wand,const KernelInfo *color_matrix);

  MagickWand *MagickCombineImages(MagickWand *wand,const ColorspaceType colorspace);

  MagickBooleanType MagickCommentImage(MagickWand *wand,const char *comment);

  MagickWand *MagickCompareImagesLayers(MagickWand *wand,const LayerMethod method);

  MagickWand *MagickCompareImages(MagickWand *wand,
    const MagickWand *reference,const MetricType metric,
    double *distortion);

  MagickBooleanType MagickCompositeImageGravity(MagickWand *wand,
    const MagickWand *source_wand,const CompositeOperator compose,
    const GravityType gravity);

  MagickBooleanType MagickCompositeLayers(MagickWand *wand,
    const MagickWand *source_wand, const CompositeOperator compose,
    const ssize_t x,const ssize_t y);

  MagickBooleanType MagickContrastImage(MagickWand *wand,const MagickBooleanType sharpen);

  MagickBooleanType MagickContrastStretchImage(MagickWand *wand,
    const double black_point,const double white_point);

  MagickBooleanType MagickConvolveImage(MagickWand *wand,const KernelInfo *kernel);

  MagickBooleanType MagickCycleColormapImage(MagickWand *wand,const ssize_t displace);

  MagickBooleanType MagickConstituteImage(MagickWand *wand,
    const size_t columns,const size_t rows,const char *map,
    const StorageType storage,void *pixels);

  MagickBooleanType MagickDecipherImage(MagickWand *wand,const char *passphrase);

  MagickWand *MagickDeconstructImages(MagickWand *wand);

  MagickBooleanType MagickDeskewImage(MagickWand *wand,const double threshold);

  MagickBooleanType MagickDespeckleImage(MagickWand *wand);

  MagickBooleanType MagickDisplayImage(MagickWand *wand,const char *server_name);

  MagickBooleanType MagickDisplayImages(MagickWand *wand,const char *server_name);

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
  MagickBooleanType MagickInverseFourierTransformImage(
    MagickWand *magnitude_wand,MagickWand *phase_wand,const MagickBooleanType magnitude);

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

  MagickBooleanType MagickGetImageBorderColor(MagickWand *wand,PixelWand *border_color);

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

  PixelWand **MagickGetImageHistogram(MagickWand *wand,size_t *number_colors);

  PixelInterpolateMethod MagickGetImageInterpolateMethod(MagickWand *wand);

  size_t MagickGetImageIterations(MagickWand *wand);

  MagickBooleanType MagickGetImageMatteColor(MagickWand *wand,PixelWand *matte_color);

  MagickBooleanType MagickGetImagePage(MagickWand *wand,
    size_t *width,size_t *height,ssize_t *x,ssize_t *y);

  MagickBooleanType MagickGetImagePixelColor(MagickWand *wand,
    const ssize_t x,const ssize_t y,PixelWand *color);

  MagickWand *MagickGetImageRegion(MagickWand *wand,
    const size_t width,const size_t height,const ssize_t x,const ssize_t y);

  RenderingIntent MagickGetImageRenderingIntent(MagickWand *wand);

  MagickBooleanType MagickGetImageResolution(MagickWand *wand,double *x,double *y);

  size_t MagickGetImageScene(MagickWand *wand);

  char *MagickGetImageSignature(MagickWand *wand);

  size_t MagickGetImageTicksPerSecond(MagickWand *wand);

  ImageType MagickGetImageType(MagickWand *wand);

  ResolutionType MagickGetImageUnits(MagickWand *wand);

  VirtualPixelMethod MagickGetImageVirtualPixelMethod(MagickWand *wand);

  MagickBooleanType MagickGetImageWhitePoint(MagickWand *wand,double *x,
    double *y,double *z);

  size_t MagickGetNumberImages(MagickWand *wand);

  double MagickGetImageTotalInkDensity(MagickWand *wand);

  MagickBooleanType MagickHaldClutImage(MagickWand *wand,const MagickWand *hald_wand);

  MagickBooleanType MagickHasNextImage(MagickWand *wand);
  MagickBooleanType MagickHasPreviousImage(MagickWand *wand);

  const char *MagickIdentifyImage(MagickWand *wand);
  ImageType MagickIdentifyImageType(MagickWand *wand);

  MagickBooleanType MagickImplodeImage(MagickWand *wand,
    const double radius,const PixelInterpolateMethod method);

  MagickBooleanType MagickImportImagePixels(MagickWand *wand,
    const ssize_t x,const ssize_t y,const size_t columns,
    const size_t rows,const char *map,const StorageType storage,
    const void *pixels);

  MagickBooleanType MagickInterpolativeResizeImage(MagickWand *wand, const size_t columns,
    const size_t rows, const PixelInterpolateMethod method);

  MagickBooleanType MagickLabelImage(MagickWand *wand,const char *label);

  MagickBooleanType MagickLevelImage(MagickWand *wand,
    const double black_point,const double gamma,const double white_point);

  MagickBooleanType MagickLinearStretchImage(MagickWand *wand,
    const double black_point,const double white_point);

  MagickBooleanType MagickLiquidRescaleImage(MagickWand *wand, const size_t columns,
    const size_t rows, const double delta_x,const double rigidity);

  MagickBooleanType MagickLocalContrastImage(MagickWand *wand, const double radius,
    const double strength);

  MagickBooleanType MagickMagnifyImage(MagickWand *wand);
  MagickBooleanType MagickMinifyImage(MagickWand *wand);

  MagickWand *MagickMergeImageLayers(MagickWand *wand,const LayerMethod method);

  MagickWand *MagickMontageImage(MagickWand *wand,
    const DrawingWand drawing_wand,const char *tile_geometry,
    const char *thumbnail_geometry,const MontageMode mode,
    const char *frame);

  MagickWand *MagickMorphImages(MagickWand *wand,const size_t number_frames);

  MagickBooleanType MagickMorphologyImage(MagickWand *wand,
  MorphologyMethod method,const ssize_t iterations,KernelInfo *kernel);

  MagickBooleanType MagickMotionBlurImage(MagickWand *wand,
    const double radius,const double sigma,const double angle);

  MagickBooleanType MagickNegateImage(MagickWand *wand,
    const MagickBooleanType gray);

  MagickBooleanType MagickNewImage(MagickWand *wand,
    const size_t columns,const size_t rows,
    const PixelWand *background);

  MagickBooleanType MagickNextImage(MagickWand *wand);

  MagickBooleanType MagickNormalizeImage(MagickWand *wand);

  MagickBooleanType MagickOilPaintImage(MagickWand *wand,
    const double radius,const double sigma);

  MagickBooleanType MagickOpaquePaintImage(MagickWand *wand,
    const PixelWand *target,const PixelWand *fill,const double fuzz,
    const MagickBooleanType invert);

  MagickWand *MagickOptimizeImageLayers(MagickWand *wand);

  MagickBooleanType MagickOptimizeImageTransparency(MagickWand *wand);

  MagickBooleanType MagickOrderedDitherImage(MagickWand *wand,
    const char *threshold_map);

  MagickBooleanType MagickPingImage(MagickWand *wand,const char *filename);
  MagickBooleanType MagickPingImageBlob(MagickWand *wand,
    const void *blob,const size_t length);

  MagickBooleanType MagickPingImageFile(MagickWand *wand,FILE *file);

  MagickBooleanType MagickPolaroidImage(MagickWand *wand,
    const DrawingWand *drawing_wand,const char *caption,const double angle,
    const PixelInterpolateMethod method);

  MagickBooleanType MagickPosterizeImage(MagickWand *wand,
    const size_t levels,const DitherMethod method);

  MagickWand *MagickPreviewImages(MagickWand *wand,
    const PreviewType preview);

  MagickBooleanType MagickPreviousImage(MagickWand *wand);

  MagickBooleanType MagickQuantizeImage(MagickWand *wand,
    const size_t number_colors,const ColorspaceType colorspace,
    const size_t treedepth,const DitherMethod dither_method,
    const MagickBooleanType measure_error);

  MagickBooleanType MagickQuantizeImages(MagickWand *wand,
    const size_t number_colors,const ColorspaceType colorspace,
    const size_t treedepth,const DitherMethod dither_method,
    const MagickBooleanType measure_error);

  MagickBooleanType MagickRotationalBlurImage(MagickWand *wand,
    const double angle);

  MagickBooleanType MagickRaiseImage(MagickWand *wand,
    const size_t width,const size_t height,const ssize_t x,
    const ssize_t y,const MagickBooleanType raise);

  MagickBooleanType MagickRandomThresholdImage(MagickWand *wand,
    const double low,const double high);

  MagickBooleanType MagickReadImage(MagickWand *wand,const char *filename);

  MagickBooleanType MagickReadImageBlob(MagickWand *wand,
    const void *blob,const size_t length);

  MagickBooleanType MagickReadImageFile(MagickWand *wand,FILE *file);

  MagickBooleanType MagickRemapImage(MagickWand *wand,
    const MagickWand *remap_wand,const DitherMethod method);

  MagickBooleanType MagickRemoveImage(MagickWand *wand);

  MagickBooleanType MagickResampleImage(MagickWand *wand,
    const double x_resolution,const double y_resolution,
    const FilterType filter);

  MagickBooleanType MagickRollImage(MagickWand *wand,const ssize_t x,
    const size_t y);

  MagickBooleanType MagickSampleImage(MagickWand *wand,
    const size_t columns,const size_t rows);

  MagickBooleanType MagickSegmentImage(MagickWand *wand,
    const ColorspaceType colorspace,const MagickBooleanType verbose,
    const double cluster_threshold,const double smooth_threshold);

  MagickBooleanType MagickSelectiveBlurImage(MagickWand *wand,
    const double radius,const double sigma,const double threshold);

  MagickBooleanType MagickSeparateImage(MagickWand *wand,
     const ChannelType channel);

  MagickBooleanType MagickSepiaToneImage(MagickWand *wand,
    const double threshold);

  MagickBooleanType MagickSetImage(MagickWand *wand,
    const MagickWand *set_wand);

  MagickBooleanType MagickSetImageAlphaChannel(MagickWand *wand,
    const AlphaChannelOption alpha_type);

  MagickBooleanType MagickSetImageBackgroundColor(MagickWand *wand,
    const PixelWand *background);

  MagickBooleanType MagickSetImageBluePrimary(MagickWand *wand,
    const double x,const double y,const double z);
  MagickBooleanType MagickSetImageGreenPrimary(MagickWand *wand,
    const double x,const double y,const double z);
  MagickBooleanType MagickSetImageRedPrimary(MagickWand *wand,
    const double x,const double y,const double z);

  MagickBooleanType MagickSetImageBorderColor(MagickWand *wand,
    const PixelWand *border);

  ChannelType MagickSetImageChannelMask(MagickWand *wand,
    const ChannelType channel_mask);

  MagickBooleanType MagickSetImageMask(MagickWand *wand,
    const PixelMask type,const MagickWand *clip_mask);

  MagickBooleanType MagickSetImageColor(MagickWand *wand,
    const PixelWand *color);

  MagickBooleanType MagickSetImageColormapColor(MagickWand *wand,
    const size_t index,const PixelWand *color);

  MagickBooleanType MagickSetImageColorspace(MagickWand *wand,
    const ColorspaceType colorspace);

  MagickBooleanType MagickSetImageCompose(MagickWand *wand,
    const CompositeOperator compose);

  MagickBooleanType MagickSetImageCompression(MagickWand *wand,
    const CompressionType compression);

  MagickBooleanType MagickSetImageDelay(MagickWand *wand,
    const size_t delay);

  MagickBooleanType MagickSetImageDispose(MagickWand *wand,
    const DisposeType dispose);

  MagickBooleanType MagickSetImageEndian(MagickWand *wand,
    const EndianType endian);

  MagickBooleanType MagickSetImageExtent(MagickWand *wand,
    const size_t columns,const unsigned rows);

  MagickBooleanType MagickSetImageFilename(MagickWand *wand,
    const char *filename);

  MagickBooleanType MagickSetImageFuzz(MagickWand *wand,
    const double fuzz);

  MagickBooleanType MagickSetImageGamma(MagickWand *wand,
    const double gamma);

  MagickBooleanType MagickSetImageInterpolateMethod(MagickWand *wand,
    const PixelInterpolateMethod method);

  MagickBooleanType MagickSetImageIterations(MagickWand *wand,
    const size_t iterations);

  MagickBooleanType MagickSetImageMatte(MagickWand *wand,
    const MagickBooleanType *matte);

  MagickBooleanType MagickSetImageMatteColor(MagickWand *wand,
    const PixelWand *matte);

  MagickBooleanType MagickSetImagePage(MagickWand *wand,const size_t width,
    const size_t height,const ssize_t x,const ssize_t y);

  MagickProgressMonitor MagickSetImageProgressMonitor(MagickWand *wand
    const MagickProgressMonitor progress_monitor,void *client_data);
  MagickBooleanType MagickProgressMonitor(const char *text,
    const MagickOffsetType offset,const MagickSizeType span,void *client_data);

  MagickBooleanType MagickSetImageRenderingIntent(MagickWand *wand,
    const RenderingIntent rendering_intent);

  MagickBooleanType MagickSetImageResolution(MagickWand *wand,
    const double x_resolution,const double y_resolution);

  MagickBooleanType MagickSetImageScene(MagickWand *wand,
    const size_t scene);

  MagickBooleanType MagickSetImageTicksPerSecond(MagickWand *wand,
    const ssize_t ticks_per_second);

  MagickBooleanType MagickSetImageType(MagickWand *wand,
    const ImageType image_type);

  MagickBooleanType MagickSetImageUnits(MagickWand *wand,
    const ResolutionType units);

  VirtualPixelMethod MagickSetImageVirtualPixelMethod(MagickWand *wand,
    const VirtualPixelMethod method);

  MagickBooleanType MagickSetImageWhitePoint(MagickWand *wand,
    const double x,const double y,const double z);

  MagickBooleanType MagickShadeImage(MagickWand *wand,
    const MagickBooleanType gray,const double azimuth,
    const double elevation);

  MagickBooleanType MagickShadowImage(MagickWand *wand,const double alpha,
    const double sigma,const ssize_t x,const ssize_t y);

  MagickBooleanType MagickShaveImage(MagickWand *wand,
    const size_t columns,const size_t rows);

  MagickBooleanType MagickShearImage(MagickWand *wand,
    const PixelWand *background,const double x_shear,const double y_shear);

  MagickBooleanType MagickSigmoidalContrastImage(MagickWand *wand,
    const MagickBooleanType sharpen,const double alpha,const double beta);

  MagickWand *MagickSimilarityImage(MagickWand *wand,
    const MagickWand *reference,const MetricType metric,
    const double similarity_threshold,RectangeInfo *offset,
    double *similarity);

  MagickBooleanType MagickSketchImage(MagickWand *wand,
    const double radius,const double sigma,const double angle);

  MagickWand *MagickSmushImages(MagickWand *wand,
    const MagickBooleanType stack,const ssize_t offset);

  MagickBooleanType MagickSolarizeImage(MagickWand *wand,
    const double threshold);

  MagickBooleanType MagickSparseColorImage(MagickWand *wand,
    const SparseColorMethod method,const size_t number_arguments,
    const double *arguments);

  MagickBooleanType MagickSpliceImage(MagickWand *wand,
    const size_t width,const size_t height,const ssize_t x,
    const ssize_t y);

  MagickBooleanType MagickSpreadImage(MagickWand *wand,
    const PixelInterpolateMethod method,const double radius);

  MagickBooleanType MagickStatisticImage(MagickWand *wand,
    const StatisticType type,const double width,const size_t height);

  MagickWand *MagickSteganoImage(MagickWand *wand,
    const MagickWand *watermark_wand,const ssize_t offset);

  MagickWand *MagickStereoImage(MagickWand *wand, const MagickWand *offset_wand);

  MagickBooleanType MagickSwirlImage(MagickWand *wand,const double degrees,
    const PixelInterpolateMethod method);

  MagickWand *MagickTextureImage(MagickWand *wand,const MagickWand *texture_wand);

  MagickBooleanType MagickThresholdImage(MagickWand *wand,const double threshold);
  MagickBooleanType MagickThresholdImageChannel(MagickWand *wand,
    const ChannelType channel,const double threshold);
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
