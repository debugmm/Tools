//
//  JGTextField.m
//  JGTextField
//
//  Created by wjg on 26/09/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "JGTextField.h"

@interface JGTextField ()

@end

@implementation JGTextField

#pragma mark - view init

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
-(void)configTextField{
    
    [self addTarget:self action:@selector(handleTextfieldTextDidChangeEvent:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - event handle and btn actions
-(void)handleTextfieldTextDidChangeEvent:(UITextField *)sender{
    
    UITextRange *tr=sender.markedTextRange;
    
    if(!tr || tr==nil ||
       (tr && [tr isKindOfClass:[UITextRange class]] &&
        [tr isEmpty])){
        //there are some string waiting user to choose.
        //do something...
    }
    else{
        //user have finished choosing string.
        //do something...
    }
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
