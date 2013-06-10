/*
 Copyright (c) 2012 Inline Studios
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 
 Rog note: I got this from https://github.com/narpas/iOS-color-wheel
 
 */

#import <UIKit/UIKit.h>

@class ISColorWheel;

@protocol ISColorWheelDelegate <NSObject>
@required
- (void)colorWheelDidChangeColor:(ISColorWheel*)colorWhee;
@end


@interface ISColorWheel : UIView
{
    UIImage* _radialImage;
    float _radius;
    float _cursorRadius;
    CGPoint _touchPoint;
    float _brightness;
    bool _continuous;
    id <ISColorWheelDelegate> _delegate;
    
}
@property(nonatomic, assign)float radius;
@property(nonatomic, assign)float cursorRadius;
@property(nonatomic, assign)float brightness;
@property(nonatomic, assign)bool continuous;
@property(nonatomic, assign)id <ISColorWheelDelegate> delegate;

- (void)updateImage;
- (UIColor*)currentColor;
- (void)setCurrentColor:(UIColor*)color;

- (void)setTouchPoint:(CGPoint)point;

@end
