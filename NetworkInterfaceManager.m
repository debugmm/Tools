//
//  NetworkInterfaceManager.m
//  IPAddressDemo
//
//  Created by worktree on 06/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import "NetworkInterfaceManager.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

//define
static NetworkInterfaceManager *_sharedManager=nil;

@interface NetworkInterfaceManager()
@end

@implementation NetworkInterfaceManager

+(instancetype)sharedManager{
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        
        _sharedManager=[[NetworkInterfaceManager alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
-(NSString *)getEn0InterfaceIpV4IpAddress{
    
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - 
-(void)getWifiInfo{
    /*
     *{
     *   BSSID = "f4:83:cd:b8:f2:8b";
     *   SSID = MoTou;
     *   SSIDDATA = <4d6f546f 75>;
     *}
     */
    NSArray *infos = CFBridgingRelease(CNCopySupportedInterfaces());
    
    if(infos && infos.count>0){
        
        CFStringRef interface=(__bridge CFStringRef)([infos firstObject]);
        NSDictionary *info=CFBridgingRelease(CNCopyCurrentNetworkInfo(interface));
        
        NSLog(@"net interface info:%@",info);
    }
}

@end
