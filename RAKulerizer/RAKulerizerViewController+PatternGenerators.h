//
//  RAKulerizerViewController+PatternGenerators.h
//  RAKulerizer
//
//  Created by Roger Adams on 5/23/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerizerViewController.h"

@interface RAKulerizerViewController (PatternGenerators)

- (UIImage *)generateCirclesFromKuler:(RAKulerObject *)kuler
                        withImageSize:(CGSize)imageSize
                      numberOfCircles:(int)circleCount;

- (UIImage *)generateHorizontalLinesFromKuler:(RAKulerObject *)kuler
                                withImageSize:(CGSize)imageSize;

- (UIImage *)generateVerticalLinesFromKuler:(RAKulerObject *)kuler
                              withImageSize:(CGSize)imageSize;

- (UIImage *)generateGridPatternFromKuler:(RAKulerObject *)kuler
                                 withSize:(CGSize)imageSize
                                 cellSize:(CGSize)size;


@end
