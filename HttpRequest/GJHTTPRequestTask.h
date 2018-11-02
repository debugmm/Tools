//
//  GJHTTPRequestTask.h
//
//  Created by worktree on 2018/11/2.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GJHTTPRequestParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface GJHTTPRequestTask : NSObject

/**
 * @description: request Task is NSURLSessionDataTask subclass instance.
 *               represent request task
 */
@property(nonatomic,strong,nullable)id requestTask;

/**
 * @description: a request task unique tag(a request task identifier)
 * @discussion: maybe it is an dataModel instance
 */
@property(nonatomic,copy,nullable)NSString *requestTaskTag;

/**
 * @description: a request parameter instance unique tag(identifier)
 */
@property(nonatomic,assign)unsigned long long requestParameterTag;

@property(nonatomic,strong,nullable)GJHTTPRequestParameter *requestParameter;

@end

NS_ASSUME_NONNULL_END
