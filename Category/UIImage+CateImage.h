//
//  UIImage+CateImage.h
//
//  Created by worktree on 15/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CateImage)

+(UIImage *)createImageWithColor:(UIColor *)color
                            rect:(CGRect)rect
                    cornerRadius:(CGFloat)cornerRadius;

+(UIImage *)createImageWithColor:(UIColor *)color
                            rect:(CGRect)rect;

-(nullable UIImage *)imageWithTintColor:(nonnull UIColor *)color;

-(nullable UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
