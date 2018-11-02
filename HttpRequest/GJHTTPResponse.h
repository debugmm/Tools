//
//  GJHTTPResponse.h
//
//  Created by worktree on 2018/11/2.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJHTTPResponse : NSObject

@property(nonatomic,assign)NSInteger stateCode;
@property(nonatomic,copy,nullable)NSString *stateMsg;
@property(nonatomic,strong,nullable)id data;
@property(nonatomic,copy,nullable)NSString *responseJsonString;

@end

NS_ASSUME_NONNULL_END
