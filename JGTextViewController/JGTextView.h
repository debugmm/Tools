//
//  JGTextView.h
//
//  Created by worktree on 24/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGTextView : UITextView

#pragma mark - cursor position
-(CGPoint)getCursorPositionInView;

-(CGPoint)getCursorPositionInWindow;

@end
