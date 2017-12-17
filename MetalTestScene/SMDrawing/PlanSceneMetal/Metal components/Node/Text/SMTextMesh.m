/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

@import CoreText;

#import "SMTextMesh.h"
#import "SMGlyphDescriptor.h"

typedef void (^MBEGlyphPositionEnumerationBlock)(CGGlyph glyph,
                                                 NSInteger glyphIndex,
                                                 CGRect glyphBounds);

@implementation SMTextMesh

#pragma mark - Constructor

- (instancetype)initWithString:(NSString *)string
                        inRect:(CGRect)rect
                 withFontAtlas:(SMFontAtlas *)fontAtlas
                        atSize:(CGFloat)fontSize
                  drawingFrame:(CGRect)frame {
    if ((self = [super init])) {
        _vertexArr    = [NSMutableArray array];
        _drawingFrame = frame;
      
        [self buildMeshWithString:string inRect:rect withFont:fontAtlas atSize:fontSize];
    }
  
    return self;
}
//-----------------------------------------------------------------------------------

#pragma mark - Processing

- (void)buildMeshWithString:(NSString *)string
                     inRect:(CGRect)rect
                   withFont:(SMFontAtlas *)fontAtlas
                     atSize:(CGFloat)fontSize {
    UIFont *font                   = [fontAtlas.parentFont fontWithSize:fontSize];
    NSDictionary *attributes       = @{ NSFontAttributeName: font };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    CFRange stringRange            = CFRangeMake(0, attrString.length);
    CGPathRef rectPath             = CGPathCreateWithRect(rect, NULL);
    CTFramesetterRef framesetter   = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CTFrameRef frame               = CTFramesetterCreateFrame(framesetter, stringRange, rectPath, NULL);

    __block CFIndex frameGlyphCount = 0;
    NSArray *lines                  = (__bridge id)CTFrameGetLines(frame);
  
    [lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
        frameGlyphCount += CTLineGetGlyphCount((__bridge CTLineRef)lineObject);
    }];
  
    [self enumerateGlyphsInFrame:frame block:^(CGGlyph glyph, NSInteger glyphIndex, CGRect glyphBounds) {
        if (glyph >= fontAtlas.glyphDescriptors.count) return;
      
        SMGlyphDescriptor *glyphInfo = fontAtlas.glyphDescriptors[glyph];
      
        float minX = CGRectGetMinX(glyphBounds);
        float maxX = CGRectGetMaxX(glyphBounds);
        float minY = CGRectGetMinY(glyphBounds);
        float maxY = CGRectGetMaxY(glyphBounds);
        float minS = glyphInfo.topLeftTexCoord.x;
        float maxS = glyphInfo.bottomRightTexCoord.x;
        float minT = glyphInfo.topLeftTexCoord.y;
        float maxT = glyphInfo.bottomRightTexCoord.y;
      
        // 0
        SMVectorTextMesh *mesh0 = [[SMVectorTextMesh alloc] init];
        mesh0.positionX         = minX;
        mesh0.positionY         = maxY;
        mesh0.textX             = minS;
        mesh0.textY             = maxT;
        mesh0.positionZ         = 0;
        // 1
        SMVectorTextMesh *mesh1 = [[SMVectorTextMesh alloc] init];
        mesh1.positionX         = minX;
        mesh1.positionY         = minY;
        mesh1.textX             = minS;
        mesh1.textY             = minT;
        mesh1.positionZ         = 0;
        // 2
        SMVectorTextMesh *mesh2 = [[SMVectorTextMesh alloc] init];
        mesh2.positionX         = maxX;
        mesh2.positionY         = minY;
        mesh2.textX             = maxS;
        mesh2.textY             = minT;
        mesh2.positionZ         = 0;
        // 2
        SMVectorTextMesh *mesh2_ = [[SMVectorTextMesh alloc] init];
        mesh2_.positionX         = maxX;
        mesh2_.positionY         = minY;
        mesh2_.textX             = maxS;
        mesh2_.textY             = minT;
        mesh2_.positionZ         = 0;
        // 3
        SMVectorTextMesh *mesh3 = [[SMVectorTextMesh alloc] init];
        mesh3.positionX         = maxX;
        mesh3.positionY         = maxY;
        mesh3.textX             = maxS;
        mesh3.textY             = maxT;
        mesh3.positionZ         = 0;
        // 0
        SMVectorTextMesh *mesh0_ = [[SMVectorTextMesh alloc] init];
        mesh0_.positionX         = minX;
        mesh0_.positionY         = maxY;
        mesh0_.textX             = minS;
        mesh0_.textY             = maxT;
        mesh0_.positionZ         = 0;
      
        [_vertexArr addObject:mesh0];
        [_vertexArr addObject:mesh1];
        [_vertexArr addObject:mesh2];
        [_vertexArr addObject:mesh2_];
        [_vertexArr addObject:mesh3];
        [_vertexArr addObject:mesh0_];
    }];

    CFRelease(frame);
    CFRelease(framesetter);
    CFRelease(rectPath);
}
//-----------------------------------------------------------------------------------

- (void)enumerateGlyphsInFrame:(CTFrameRef)frame
                         block:(MBEGlyphPositionEnumerationBlock)block {
    if (!block) return;

    CFRange entire           = CFRangeMake(0, 0);
    CGPathRef framePath      = CTFrameGetPath(frame);
    CGRect frameBoundingRect = CGPathGetPathBoundingBox(framePath);

    NSArray *lines            = (__bridge id)CTFrameGetLines(frame);
    CGPoint *lineOriginBuffer = malloc(lines.count * sizeof(CGPoint));
  
    CTFrameGetLineOrigins(frame, entire, lineOriginBuffer);

    __block CFIndex glyphIndexInFrame = 0;

    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
  
    CGContextRef context = UIGraphicsGetCurrentContext();

    [lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
        CTLineRef line     = (__bridge CTLineRef)lineObject;
        CGPoint lineOrigin = lineOriginBuffer[lineIndex];

        NSArray *runs = (__bridge id)CTLineGetGlyphRuns(line);
        [runs enumerateObjectsUsingBlock:^(id runObject, NSUInteger rangeIndex, BOOL *stop) {
            CTRunRef run         = (__bridge CTRunRef)runObject;
            NSInteger glyphCount = CTRunGetGlyphCount(run);

            CGGlyph *glyphBuffer = malloc(glyphCount * sizeof(CGGlyph));
          
            CTRunGetGlyphs(run, entire, glyphBuffer);

            CGPoint *positionBuffer = malloc(glyphCount * sizeof(CGPoint));
          
            CTRunGetPositions(run, entire, positionBuffer);

            for (NSInteger glyphIndex = 0; glyphIndex < glyphCount; ++glyphIndex) {
                CGGlyph glyph        = glyphBuffer[glyphIndex];
                CGPoint glyphOrigin  = positionBuffer[glyphIndex];
                CGRect glyphRect     = CTRunGetImageBounds(run, context, CFRangeMake(glyphIndex, 1));
                CGFloat boundsTransX = frameBoundingRect.origin.x + lineOrigin.x;
                CGFloat boundsTransY = CGRectGetHeight(frameBoundingRect) + frameBoundingRect.origin.y - lineOrigin.y + glyphOrigin.y;
              
                CGAffineTransform pathTransform = CGAffineTransformMake(1, 0, 0, -1, boundsTransX, boundsTransY);
                glyphRect                       = CGRectApplyAffineTransform(glyphRect, pathTransform);
              
                block(glyph, glyphIndexInFrame, glyphRect);

                ++glyphIndexInFrame;
            }

            free(positionBuffer);
            free(glyphBuffer);
        }];
    }];
    
    UIGraphicsEndImageContext();
}
//-----------------------------------------------------------------------------------

@end
