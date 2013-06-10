//
//  RAKulerizerViewController+PatternGenerators.m
//  RAKulerizer
//
//  This is just a bunch of methods experimenting with using
//  the color palettes to generate unique patterns.
//
//  Created by Roger Adams on 5/23/13.
//  Copyright (c) 2013 Simplicity Studios. All rights reserved.
//

#import "RAKulerizerViewController+PatternGenerators.h"

@implementation RAKulerizerViewController (PatternGenerators)

#pragma mark - Kuler Pattern Generators

- (UIImageView *)generateCircleFromKuler:(RAKulerObject *)kuler withDiameter:(CGFloat)diameter {
    
    UIGraphicsBeginImageContext(CGSizeMake(diameter, diameter));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int r = arc4random_uniform(5);
    CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
    CGContextSetFillColorWithColor(context, color);
    
    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
    CGContextFillEllipseInRect(context, circleRect);
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *circle = [[UIImageView alloc] initWithImage:circleImage];
    return circle;
}

- (UIImage *)generateCirclesFromKuler:(RAKulerObject *)kuler withImageSize:(CGSize)imageSize numberOfCircles:(int)circleCount {
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i < circleCount; i++) {
        int r = arc4random_uniform(5);
        CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
        CGContextSetFillColorWithColor(context, color);
        
        int square = arc4random_uniform(100);
        int x = arc4random_uniform(imageSize.width);
        int y = arc4random_uniform(imageSize.height);
        
        CGRect circleRect = CGRectMake(x, y, square, square);
        CGContextFillEllipseInRect(context, circleRect);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)generateHorizontalLinesFromKuler:(RAKulerObject *)kuler withImageSize:(CGSize)imageSize {
    
    float width = 10.0;
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i * width < imageSize.height; i++) {
        
        int r = arc4random_uniform(5);
        CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
        CGContextSetFillColorWithColor(context, color);
        
        CGRect gridXRect = CGRectMake(0, i * width, imageSize.width, width);
        CGContextFillRect(context, gridXRect);
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)generateVerticalLinesFromKuler:(RAKulerObject *)kuler withImageSize:(CGSize)imageSize {
    
    float width = 10.0;
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i * width < imageSize.width; i++) {
        
        int r = arc4random_uniform(5);
        CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
        CGContextSetFillColorWithColor(context, color);
        
        CGRect gridXRect = CGRectMake(i * width, 0, width, imageSize.height);
        CGContextFillRect(context, gridXRect);
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)generateGridPatternFromKuler:(RAKulerObject *)kuler withSize:(CGSize)imageSize cellSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int totalCellsX, totalCellsY;
    totalCellsX = roundf(imageSize.width / size.width);
    totalCellsY = roundf(imageSize.height / size.height);
    if (((roundf(imageSize.width / size.width) - totalCellsX)) > 0) totalCellsX++;
    if (((roundf(imageSize.height / size.height) - totalCellsY)) > 0) totalCellsY++;
    
    CGFloat gridX = 0;
    CGFloat gridY = 0;
    for (int y=0; y<totalCellsY; y++) {
        gridX = 0;
        for (int x=0; x<totalCellsX; x++) {
            int r = arc4random_uniform(5);
            CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
            CGContextSetFillColorWithColor(context, color);
            CGContextFillRect(context, CGRectMake(gridX, gridY, size.width, size.height));
            gridX = gridX + size.width;
        }
        int r = arc4random_uniform(5);
        CGColorRef color = [[kuler getSwatchAtIndex:r] colorRGBFromHex].CGColor;
        CGContextSetFillColorWithColor(context, color);
        CGContextFillRect(context, CGRectMake(gridX, gridY, size.width, size.height));
        
        gridY = gridY + size.height;
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
