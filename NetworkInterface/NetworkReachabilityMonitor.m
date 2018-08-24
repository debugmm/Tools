//
//  NetworkReachabilityMonitor.m
//
//  Created by worktree on 02/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "NetworkReachabilityMonitor.h"

//AFNetwork
#import <AFNetworking.h>

#import "NetworkInterfaceManager.h"

//shared manager
static NetworkReachabilityMonitor *_sharedManager=nil;

@interface NetworkReachabilityMonitor()

@end

@implementation NetworkReachabilityMonitor

+(instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedManager=[[NetworkReachabilityMonitor alloc] init];
    });
    
    return _sharedManager;
}

-(void)dealloc{
    
    [self stopMonitorNetwork];
    
    NSNotificationCenter *c=[NSNotificationCenter defaultCenter];
    [c removeObserver:self];
}

#pragma mark -
-(void)listenNetworkReachability{
    
    [self addNetworkReachabilityObserver];
    [self startMonitorNetwork];
}

-(void)stopMonitorNetwork{
    
    AFNetworkReachabilityManager *m=[AFNetworkReachabilityManager sharedManager];
    
    [m stopMonitoring];
}

#pragma mark -
-(void)startMonitorNetwork{
    
    AFNetworkReachabilityManager *m=[AFNetworkReachabilityManager sharedManager];
    
    [m startMonitoring];
}

-(void)addNetworkReachabilityObserver{
    
    NSNotificationCenter *c=[NSNotificationCenter defaultCenter];
    
    [c addObserver:self selector:@selector(networkStatusChangedNoti:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark - Network Changed Noti
-(void)networkStatusChangedNoti:(NSNotification *)noti{
    /*
     * AFNetworkReachabilityStatusUnknown          = -1,
     * AFNetworkReachabilityStatusNotReachable     = 0,
     * AFNetworkReachabilityStatusReachableViaWWAN = 1,
     * AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */
    AFNetworkReachabilityStatus status=[[noti.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    
    if(status != AFNetworkReachabilityStatusReachableViaWiFi){
        //wifi unusable
        NSLog(@"wifi unusable");
        
    }else{
        //wifi usable
        NSLog(@"wifi usable");
        
        NSArray *ms=[[MTNetworkInterfaceManager sharedManager] getAddressDictionarys];
        
        NSLog(@"%@",ms);
    }
}

@end
