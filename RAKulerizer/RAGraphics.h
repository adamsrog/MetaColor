//
//  RAGraphics.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/8/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAGraphics : NSObject

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

@end