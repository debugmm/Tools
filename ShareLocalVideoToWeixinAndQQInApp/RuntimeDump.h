//
//  RuntimeDump.h
//
//  Created by wjg on 2018/10/8.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeDump : NSObject
+ (void)ivarWithObject:(id)object;

+(void)getMethodsWithObject:(id)object;

@end
