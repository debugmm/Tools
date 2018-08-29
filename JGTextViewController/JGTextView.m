//
//  JGTextView.m
//
//  Created by worktree on 24/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "JGTextView.h"

#import "NSString+CateString.h"
#import "MTAppConst.h"

@implementation JGTextView

#pragma mark - overwrite
-(void)paste:(id)sender{
    
    //remove the last newline character
    NSString *pstr=[UIPasteboard generalPasteboard].string;

    if(![NSString isEmptyString:pstr]){
        pstr=[pstr stringByRemovingNewLines];
        [UIPasteboard generalPasteboard].string=pstr;
    }
    
    [self scrollRangeToVisible:NSMakeRange(0, 0)];//显示黏贴后的文字
    
    [super paste:sender];
}

#pragma mark - init configs
-(void)initConfigs{
    
    //init config views
    //usually we do views auto layout init configs in initConfigViews
    
    [self initConfigViews];
}

#pragma mark - init config views
-(void)initConfigViews{
    // invoke all views init config method
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName{}

#pragma mark - configs
-(void)configs{
    
    //in this mehod,usually we do views config on basis of data or some status after initConfig views
}

#pragma mark -
// all sub config method at here.
//example: config+ViewClassName{}

#pragma mark - cursor position
-(CGPoint)getCursorPositionInView{
    
    CGPoint cursorPosition=[self caretRectForPosition:self.selectedTextRange.start].origin;
    
    CGPoint point=[self convertPoint:cursorPosition toView:self];
    
    return point;
}

-(CGPoint)getCursorPositionInWindow{
    
    CGPoint cursorPosition=[self caretRectForPosition:self.selectedTextRange.end].origin;
    
    CGPoint point=[self convertPoint:cursorPosition toView:self.window];
    
    return point;
}

#pragma mark - property

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
