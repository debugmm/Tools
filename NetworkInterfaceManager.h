//
//  NetworkInterfaceManager.h
//  IPAddressDemo
//
//  Created by worktree on 06/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInterfaceManager : NSObject

/**
 singleton instance

 @return shared instance
 */
+(instancetype)sharedManager;

#pragma mark -

/**
 Get interface ethernet0 ipaddress of ipv4

 @return ipv4 ipaddress of interface ethernet 0
 */
-(NSString *)getEn0InterfaceIpV4IpAddress;

@end
