//
//  UIImage+CateImage.m
//
//  Created by worktree on 15/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "UIImage+CateImage.h"

@implementation UIImage (CateImage)

+(UIImage *)createImageWithColor:(UIColor *)color
                            rect:(CGRect)rect
                    cornerRadius:(CGFloat)cornerRadius{
    
    UIGraphicsBeginImageContext(rect.size);

    [color setFill];
    UIBezierPath *bp=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    [bp fill];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)createImageWithColor:(UIColor *)color
                            rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    
    [color setFill];
    UIBezierPath *bp=[UIBezierPath bezierPathWithRect:rect];
    
    [bp fill];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(nullable UIImage *)imageWithTintColor:(nonnull UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [color setFill];
    
    CGRect bounds=CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //kCGBlendModeDestinationIn
//    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0];
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:0.5];
    
    UIImage *tintedImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    return tintedImage;
}

-(nullable UIImage *)imageWithCornerRadius:(CGFloat)radius{
    
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
