//
//  NetworkInterfaceManager.h
//
//  Created by worktree on 02/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInterfaceManager : NSObject

+(instancetype _Nonnull)sharedManager;

#pragma mark -
-(nullable NSArray *)getAddressDictionarys;

@end
