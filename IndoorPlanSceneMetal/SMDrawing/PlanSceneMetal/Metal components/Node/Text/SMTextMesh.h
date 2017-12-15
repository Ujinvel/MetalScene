/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

#import "SMFontAtlas.h"
#import "SMVectorTextMesh.h"
#import "SMMesh.h"

@interface SMTextMesh: SMMesh

@property (nonatomic) NSMutableArray<SMVectorTextMesh *> *vertexArr;
@property (nonatomic) CGRect drawingFrame;

- (instancetype)initWithString:(NSString *)string
                        inRect:(CGRect)rect
                 withFontAtlas:(SMFontAtlas *)fontAtlas
                        atSize:(CGFloat)fontSize
                  drawingFrame:(CGRect)frame;

@end
