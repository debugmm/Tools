//
//  NSView+CCategory.m
//  ColorDemo
//
//  Created by wujungao on 2019/3/18.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSView+CCategory.h"

@implementation NSView (CCategory)

- (NSRect)getRectOfViewInScreen{
    
    NSRect dframe=[self convertRect:self.bounds toView:nil];
    dframe=[self.window convertRectToScreen:dframe];
    
    return dframe;
}

@end
