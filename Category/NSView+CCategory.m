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
    
    NSRect dframe=self.frame;
    
    NSView *superV=nil;
    NSView *subV=nil;
    
    subV=self.superview;
    superV=subV.superview;
    BOOL isContinue=YES;
    
    //这个循环的作用，用来将当前的View.frame，一直转换到window.contentView rect
    //最后，在把从contentView转换的rect，转换成screen上的rect
    
    //经过试验：中间view层级特别多，直接转换会有问题
    //因此，一级一级的转换rect
    do {
        
        if(superV!=nil && subV!=nil){
            
            dframe=[subV convertRect:dframe toView:superV];
            
            subV=superV;
            superV=subV.superview;
            
            continue;
        }
        
        isContinue=NO;
        
    } while (isContinue);
    
    dframe=[self.window convertRectToScreen:dframe];
    
    return dframe;
}

@end
