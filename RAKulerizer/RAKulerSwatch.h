//
//  RAKulerSwatch.h
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAKulerSwatch : NSObject {
    
}

@property (nonatomic) NSString *swatchHexColor;
@property (nonatomic) NSString *swatchColorMode;
@property (nonatomic) float     swatchChannel1;
@property (nonatomic) float     swatchChannel2;
@property (nonatomic) float     swatchChannel3;
@property (nonatomic) float     swatchChannel4;
@property (nonatomic) int       swatchIndex;

- (UIColor *)colorRGBFromHex;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
- (id)initWithKulerSwatch:(RAKulerSwatch *)kulerSwatch;
- (id)initWithColor:(UIColor *)color forIndex:(int)index;
- (id)initWithWhiteColor:(UIColor *)color forIndex:(int)index;
- (id)initRGBAWithIndex:(int)   swatchIndex
               channel1:(float) swatchRed
               channel2:(float) swatchGreen
               channel3:(float) swatchBlue
               channel4:(float) swatchAlpha;

@end
