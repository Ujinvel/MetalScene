/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

#import "SMFontAtlasBuild.h"
#import "SMTextRenderingConstants.h"

@implementation SMFontAtlasBuild

+ (NSURL *)documentsURL {
    NSArray *candidates     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [candidates firstObject];
  
    return [NSURL fileURLWithPath:documentsPath isDirectory:YES];
}
//-----------------------------------------------------------------------------------

+ (SMFontAtlas *)getFontAtlasWhisFontName:(NSString *)fontName andSize:(CGFloat)size {
    NSString *name   = (fontName.length == 0) ? cDefFontName : fontName;
    CGFloat fontSize = (size <= 0) ? cDefFontSize : size;
    NSURL *fontURL   = [[self.documentsURL URLByAppendingPathComponent:name] URLByAppendingPathExtension:cFontExt];
  
  SMFontAtlas *fontAtlas;// = [NSKeyedUnarchiver unarchiveObjectWithFile:fontURL.path];
  
    // Cache miss: if we don't have a serialized version of the font atlas, build it now
    if (!fontAtlas) {
      UIFont *font = [UIFont fontWithName:name size:fontSize];
      
      if (!font) font = [UIFont fontWithName:cDefFontName size:fontSize];
      
      fontAtlas = [[SMFontAtlas alloc] initWithFont:font textureSize:cFontAtlasSize];
      
      [NSKeyedArchiver archiveRootObject:fontAtlas toFile:fontURL.path];
    }
  
    return fontAtlas;
}
//-----------------------------------------------------------------------------------


@end

