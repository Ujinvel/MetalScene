/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

#import "SMTextRenderingConstants.h"

// This is the size at which the font atlas will be generated, ideally a large power of two. Even though
// we later downscale the distance field, it's better to render it at as high a resolution as possible in
// order to capture all of the fine details.
NSInteger cFontAtlasSizeMax = 4096;
NSInteger cFontAtlasSize    = 2048;
CGFloat cDefFontSize        = 32;
size_t cBitsPerComponent    = 8;

NSString *const cDefFontName   = @"HoeflerText-Regular";
NSString *const cFontExt       = @"sdff";
NSString *const cExampleString = @"{ǺOJMQYZa@jmqyw";
NSString *const cStroke        = @"!";

NSString *const cGlyphIndexKey       = @"glyphIndex";
NSString *const cLeftTexCoordKey     = @"leftTexCoord";
NSString *const cRightTexCoordKey    = @"rightTexCoord";
NSString *const cTopTexCoordKey      = @"topTexCoord";
NSString *const cBottomTexCoordKey   = @"bottomTexCoord";
NSString *const cFontNameKey         = @"fontName";
NSString *const cFontSizeKey         = @"fontSize";
NSString *const cFontSpreadKey       = @"spread";
NSString *const cTextureDataKey      = @"textureData";
NSString *const cTextureWidthKey     = @"textureWidth";
NSString *const cTextureHeightKey    = @"textureHeight";
NSString *const cGlyphDescriptorsKey = @"glyphDescriptors";
