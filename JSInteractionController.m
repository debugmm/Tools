//
//  JSInteractionController.m
//
//  Created by worktree on 10/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "JSInteractionController.h"

#import <UIKit/UIKit.h>


@interface JSInteractionController() <CustomJSExport>

@end

@implementation JSInteractionController

+(instancetype)sharedManager{
    
    static JSInteractionController *sharedM=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedM=[[JSInteractionController alloc] init];
    });
    
    return sharedM;
}

-(instancetype)init{
    self=[super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreatedJSContext:) name:WebViewDidCreatedJSContextNoti object:nil];
    }
    
    return self;
}

#pragma mark -
-(void)didCreatedJSContext:(NSNotification *)noti{
    
    if(![noti.name isEqualToString:WebViewDidCreatedJSContextNoti]){
        return;
    }
    
    JSContext *context = noti.object;
    context[@"xxoo"] = self;
}

#pragma mark - CustomJSExport Protocol


@end
