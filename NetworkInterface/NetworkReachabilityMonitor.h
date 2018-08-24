//
//  NetworkReachabilityMonitor.h
//
//  Created by worktree on 02/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkReachabilityMonitor : NSObject

+(instancetype _Nonnull)sharedManager;

#pragma mark -
-(void)listenNetworkReachability;

-(void)stopMonitorNetwork;


@end
