//
//  GJRequestDelegate.h
//
//  Created by worktree on 2018/11/2.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GJHTTPResponse;

@protocol GJRequestDelegate <NSObject>

@optional
-(void)requestFinished:(nonnull GJHTTPResponse *)response;

@end

NS_ASSUME_NONNULL_END
