//
//  FMDBManager.h
//
//  Created by worktree on 09/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
@interface FMDBManager : NSObject

+(instancetype)sharedManager;

#pragma mark - create DB
-(void)initConfigDBWithUId:(nonnull NSString *)uid;

-(void)closeDBQueue;

#pragma mark - about user default
/**
 get user id from userdefualts system.

 @return user id
 */
-(NSString *)getAutoLoginUserUId;


/**
 save user id to userdefaults system.

 @param uid user id
 */
-(void)saveUIdToPlist:(nonnull NSString *)uid;

#pragma mark - about user table


@end
