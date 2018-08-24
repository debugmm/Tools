//
//  NetworkInterfaceManager.m
//
//  Created by worktree on 02/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "NetworkInterfaceManager.h"

//SystemConfiguration
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "NSString+CateString.h"

//define
#define IOS_CELLULAR        (@"pdp_ip0")
#define IOS_WIFI_Prefix     (@"en")
#define IOS_VPN             (@"utun0")
#define IP_ADDR_IPv4        (@"ipv4")
#define IP_ADDR_IPv6        (@"ipv6")

#define AddrTypeKey (@"addrType")
#define AddressKey (@"addr")
#define PortKey (@"port")
#define InterfaceNameKey (@"interfaceName")

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
-(void)fetchWifiInfo{
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

-(nullable NSArray *)getAddressDictionarys{
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = -1;
    NSMutableArray *ipaddressDicts=[NSMutableArray arrayWithCapacity:1];
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if(success!=0){
        return ipaddressDicts;
    }
    
    temp_addr = interfaces;
    
    // Loop through linked list of interfaces
    while(temp_addr != NULL) {
        
        NSMutableDictionary *ipaddressDict=[NSMutableDictionary dictionaryWithCapacity:1];
        //get address
        NSString *address = @"";
        if(temp_addr->ifa_addr->sa_family == AF_INET){
            //ipv4 ipaddress
            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            address=[NSString stringByTrimmingBothEndWhiteSpace:address];
            if(![NSString isEmptyString:address]){
                [ipaddressDict setObject:IP_ADDR_IPv4 forKey:AddrTypeKey];
            }
        }
        else if(temp_addr->ifa_addr->sa_family==AF_INET6){
            //ipv6 ipaddress
            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            address=[NSString stringByTrimmingBothEndWhiteSpace:address];
            if(![NSString isEmptyString:address]){
                [ipaddressDict setObject:IP_ADDR_IPv6 forKey:AddrTypeKey];
            }
        }
        
        if(![NSString isEmptyString:address]){
            
            //set address
            [ipaddressDict setObject:address forKey:AddressKey];
            
            //set interface name
            NSString *iname=[NSString stringWithUTF8String:temp_addr->ifa_name];
            iname=[NSString stringByTrimmingBothEndWhiteSpace:iname];
            
            [ipaddressDict setObject:iname forKey:InterfaceNameKey];
        }
        
        //add ipaddress dicts to array
        if(ipaddressDict.count>0){
            [ipaddressDicts addObject:ipaddressDict];
        }
        
        //next ifa
        temp_addr = temp_addr->ifa_next;
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return ipaddressDicts;
}

#pragma mark -
-(void)checkNetworkflow{
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1)
    {
        return;
    }
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    struct IF_DATA_TIMEVAL time ;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        // Not a loopback device.
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
            time = if_data->ifi_lastchange;
        }
        
        //wifi flow
        if (!strcmp(ifa->ifa_name, "en0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
            time = if_data->ifi_lastchange;//[NSDate dateWithTimeIntervalSince1970:time.tv_sec];ip租约过期时间？
        }
        
        //3G and gprs flow
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
}

@end
