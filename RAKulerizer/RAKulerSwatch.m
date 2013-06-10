//
//  RAKulerSwatch.m
//  RAKulerizer
//
//  Created by Roger Adams on 4/7/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerSwatch.h"

@implementation RAKulerSwatch

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithKulerSwatch:(RAKulerSwatch *)kulerSwatch {
    self = [super init];
    if (self) {
        self.swatchHexColor =  kulerSwatch.swatchHexColor;
        self.swatchColorMode = kulerSwatch.swatchColorMode;
        self.swatchChannel1 =  kulerSwatch.swatchChannel1;
        self.swatchChannel2 =  kulerSwatch.swatchChannel2;
        self.swatchChannel3 =  kulerSwatch.swatchChannel3;
        self.swatchChannel4 =  kulerSwatch.swatchChannel4;
        self.swatchIndex =     kulerSwatch.swatchIndex;
    }
    
    return self;
}

- (id)initWithColor:(UIColor *)color forIndex:(int)index {
    self = [super init];
    if (self) {
        CGFloat red, green, blue;
        [color getRed:&red green:&green blue:&blue alpha:nil];
        
        self.swatchHexColor = [self hexFromRed:red Green:green Blue:blue];
        self.swatchColorMode = @"rgb";
        self.swatchChannel1 = red;
        self.swatchChannel2 = green;
        self.swatchChannel3 = blue;
        self.swatchChannel4 = 1.0;
        self.swatchIndex = index;
    }
    return self;
}

- (id)initWithWhiteColor:(UIColor *)color forIndex:(int)index {
    self = [super init];
    if (self) {
        CGFloat white;
        [color getWhite:&white alpha:nil];
        
        self.swatchHexColor = [self hexFromRed:white Green:white Blue:white];
        self.swatchColorMode = @"rgb";
        self.swatchChannel1 = white;
        self.swatchChannel2 = white;
        self.swatchChannel3 = white;
        self.swatchChannel4 = 1.0;
        self.swatchIndex = index;
    }
    return self;
}

- (id)initRGBAWithIndex:(int)   swatchIndex
               channel1:(float) swatchRed
               channel2:(float) swatchGreen
               channel3:(float) swatchBlue
               channel4:(float) swatchAlpha {
    
    self = [super init];
    if (self) {

        self.swatchHexColor =  [NSString stringWithFormat:@"%02X%02X%02X",
                                [NSNumber numberWithFloat:swatchRed*255].unsignedIntValue,
                                [NSNumber numberWithFloat:swatchGreen*255].unsignedIntValue,
                                [NSNumber numberWithFloat:swatchBlue*255].unsignedIntValue];
        self.swatchColorMode = @"rgb";
        self.swatchChannel1 =  swatchRed;
        self.swatchChannel2 =  swatchGreen;
        self.swatchChannel3 =  swatchBlue;
        self.swatchChannel4 =  swatchAlpha;
        self.swatchIndex =     swatchIndex;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.swatchHexColor  = [coder decodeObjectForKey:@"swatchHexColor"];
        self.swatchColorMode = [coder decodeObjectForKey:@"swatchColorMode"];
        self.swatchChannel1  = [coder decodeFloatForKey:@"swatchChannel1"];
        self.swatchChannel2  = [coder decodeFloatForKey:@"swatchChannel2"];
        self.swatchChannel3  = [coder decodeFloatForKey:@"swatchChannel3"];
        self.swatchChannel4  = [coder decodeFloatForKey:@"swatchChannel4"];
        self.swatchIndex     = [coder decodeIntForKey:@"swatchIndex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.swatchHexColor  forKey:@"swatchHexColor"];
    [coder encodeObject:self.swatchColorMode forKey:@"swatchColorMode"];
    [coder encodeFloat: self.swatchChannel1  forKey:@"swatchChannel1"];
    [coder encodeFloat: self.swatchChannel2  forKey:@"swatchChannel2"];
    [coder encodeFloat: self.swatchChannel3  forKey:@"swatchChannel3"];
    [coder encodeFloat: self.swatchChannel4  forKey:@"swatchChannel4"];
    [coder encodeInt:   self.swatchIndex     forKey:@"swatchIndex"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Swatch %i: (#%@) %@(%f, %f, %f, %f)", self.swatchIndex, self.swatchHexColor, self.swatchColorMode, self.swatchChannel1, self.swatchChannel2, self.swatchChannel3, self.swatchChannel4];
}

- (UIColor *)colorRGBFromHex {
    
    // return RGB UIColor from swatch's hex code
    NSUInteger red, green, blue;
    sscanf([self.swatchHexColor UTF8String], "%02X%02X%02X", &red, &green, &blue);
    
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    return color;
}

- (NSString *)hexFromRed:(float)red Green:(float)green Blue:(float)blue {
    NSString *hex = [NSString stringWithFormat:@"%02X%02X%02X",
                     [NSNumber numberWithFloat:red*255].unsignedIntValue,
                     [NSNumber numberWithFloat:green*255].unsignedIntValue,
                     [NSNumber numberWithFloat:blue*255].unsignedIntValue];
    return hex;
}

@end
