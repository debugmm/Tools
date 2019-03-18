//
//  NSView+CCategory.h
//  ColorDemo
//
//  Created by wujungao on 2019/3/18.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (CCategory)

/**
 @brief 获取View在屏幕上的位置
 
 @return view在屏幕上的位置
 @discussion 这个位置的作用，可以用来设置基于这个view位置，显示另外一个窗口
 比如在这个位置底部，显示另外一个窗口，此时这个Rect非常有用
 */
- (NSRect)getRectOfViewInScreen;

@end

NS_ASSUME_NONNULL_END
