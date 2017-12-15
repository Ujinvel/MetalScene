/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

#import "SMGlyphDescriptor.h"
#import "SMTextRenderingConstants.h"

@implementation SMGlyphDescriptor

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  
    if ((self = [super init])) {
      _glyphIndex            = [aDecoder decodeIntForKey:cGlyphIndexKey];
      _topLeftTexCoord.x     = [aDecoder decodeFloatForKey:cLeftTexCoordKey];
      _topLeftTexCoord.y     = [aDecoder decodeFloatForKey:cTopTexCoordKey];
      _bottomRightTexCoord.x = [aDecoder decodeFloatForKey:cRightTexCoordKey];
      _bottomRightTexCoord.y = [aDecoder decodeFloatForKey:cBottomTexCoordKey];
    }
  
    return self;
}
//-----------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.glyphIndex forKey:cGlyphIndexKey];
    [aCoder encodeFloat:self.topLeftTexCoord.x forKey:cLeftTexCoordKey];
    [aCoder encodeFloat:self.topLeftTexCoord.y forKey:cTopTexCoordKey];
    [aCoder encodeFloat:self.bottomRightTexCoord.x forKey:cRightTexCoordKey];
    [aCoder encodeFloat:self.bottomRightTexCoord.y forKey:cBottomTexCoordKey];
}
//-----------------------------------------------------------------------------------

+ (BOOL)supportsSecureCoding {
    return YES;
}
//-----------------------------------------------------------------------------------

@end
