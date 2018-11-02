//
//  GJHTTPRequestParameter.h
//
//  Created by worktree on 2018/11/2.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJHTTPRequestParameter : NSObject

/**
 * a request sender which send requests
 */
@property(nonatomic,weak,nullable)id sender;

/**
 * @description: a request parameter instance unique tag(identifier)
 */
@property(nonatomic,assign)unsigned long long requestParameterTag;

/**
 * @description: a request task unique tag(a request task identifier)
 * @discussion: maybe it is an dataModel instance
 */
@property(nonatomic,copy,nullable)NSString *requestTaskTag;

/**
 * @description: request parameters
 */
@property(nonatomic,strong,nullable)id parameters;

/**
 * @description: http method
 */
@property(nonatomic,copy,nonnull)NSString *httpRequestMethod;

/**
 * @description: http request url string
 */
@property(nonatomic,copy,nonnull)NSString *urlString;

/**
 * @description: data model class
 */
@property(nonatomic,strong)Class _Nullable dataModelClass;

@end

NS_ASSUME_NONNULL_END
