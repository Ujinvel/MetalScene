/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

@import UIKit;
@import QuartzCore.CAMetalLayer;
@import CoreText;

@interface SMFontAtlas : NSObject <NSSecureCoding>

@property (nonatomic, readonly) UIFont *parentFont;
@property (nonatomic, readonly) CGFloat fontPointSize;
@property (nonatomic, readonly) CGFloat spread;
@property (nonatomic, readonly) NSInteger textureSize;
@property (nonatomic, readonly) NSArray *glyphDescriptors;
@property (nonatomic, readonly) NSData *textureData;

/// Create a signed-distance field based font atlas with the specified dimensions.
/// The supplied font will be resized to fit all available glyphs in the texture.
- (instancetype)initWithFont:(UIFont *)font textureSize:(NSInteger)textureSize;
- (CGFloat)estimatedLineWidthForFont:(UIFont *)font andString:(NSString *)string;

@end



