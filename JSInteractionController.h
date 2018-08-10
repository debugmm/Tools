//
//  JSInteractionController.h
//
//  Created by worktree on 10/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol CustomJSExport <JSExport>

@optional

@end

@interface JSInteractionController : NSObject

+(instancetype)sharedManager;

@end
