//
//  JGHTTPRequestManager.m
//
//  Created by worktree on 2018/11/2.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "JGHTTPRequestManager.h"

#import <AFNetworking.h>
//#import <MJExtension.h>
#import "MJExtension.h"

#import "GJHTTPRequestTask.h"
#import "GJHTTPRequestParameter.h"
#import "GJHTTPResponse.h"

#import "NSString+CateString.h"

//define
static NSString * const DictLockName = @"xo.treebug.lock";

#define HTTPGetMethod (@"GET")
#define HTTPPostMethod (@"POST")
#define HTTPPutMethod (@"PUT")

@interface JGHTTPRequestManager()

@property(nonatomic,strong,nullable)NSMutableDictionary *requestTaskDict;

@property(nonatomic,strong,nullable)NSMutableDictionary *canceledRequestParameterTagDict;

@property(nonatomic,strong,nullable)NSLock *lock;

@end

@implementation JGHTTPRequestManager

#pragma mark - init
+(instancetype)defaultManager{
    
    static JGHTTPRequestManager *_sharedManager=nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedManager=[[JGHTTPRequestManager alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init{
    self=[super init];
    if(self){
        
        _lock=[[NSLock alloc] init];
        _lock.name=DictLockName;
        _requestTaskDict=[NSMutableDictionary dictionaryWithCapacity:1];
        _canceledRequestParameterTagDict=[NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    return self;
}

#pragma mark -
-(void)sendRequest:(nonnull GJHTTPRequestParameter *)rparam{
    
    if(!rparam ||
       ![rparam isKindOfClass:[GJHTTPRequestParameter class]] ||
       [NSString isEmptyString:rparam.urlString]){
        return;
    }
    
    [self takeCareSameRequestTask:rparam];
    
    NSString *method=rparam.httpRequestMethod;
    if([method isEqualToString:HTTPGetMethod]){
        [self sendGetRequest:rparam];
    }
}

#pragma mark -
-(void)sendGetRequest:(nonnull GJHTTPRequestParameter *)rparam{
    
    NSURLSessionTask *task=[[AFHTTPSessionManager manager] GET:rparam.urlString
                                                    parameters:rparam.parameters
                                                      progress:^(NSProgress * _Nonnull downloadProgress) {
        
                                                          if([self isSameRequest:rparam.requestParameterTag]){
                                                              return;
                                                          }
                                                          
                                                          
                                                          
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([self isSameRequest:rparam.requestParameterTag]){
            return;
        }
        
        GJHTTPResponse *jrp=[[GJHTTPResponse alloc] init];
        jrp.responseJsonString=[responseObject mj_JSONString];
        
        //resolve responseObject
        
        //rparam.sender perform method(target:action)
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self removeCanceledRequest:rparam];
        
        //resolve responseObject
        
        //rparam.sender perform method(target:action)
    }];
    
    [self addRequestTask:task taskTag:rparam.requestTaskTag];
}

#pragma mark - request task
-(void)takeCareSameRequestTask:(nonnull GJHTTPRequestParameter *)rparam{
    
    NSString *taskTag=[NSString stringByTrimmingBothEndWhiteSpace:rparam.requestTaskTag];
    if(![self hasSameRequestTask:rparam.requestTaskTag]){
        return;
    }
    
    [self.lock lock];
    
    NSURLSessionTask *task=[self.requestTaskDict objectForKey:taskTag];
    [task cancel];
    [self.requestTaskDict removeObjectForKey:taskTag];
    
    NSString *requestTag=[self generatRequestTag:rparam.requestParameterTag];
    [self.canceledRequestParameterTagDict setObject:rparam forKey:requestTag];
    
    [self.lock unlock];
}

-(void)addRequestTask:(nonnull NSURLSessionTask *)task taskTag:(nonnull NSString *)taskTag{
    
    if(!task ||
       [NSString isEmptyString:taskTag]){
        return;
    }
    
    [self.lock lock];
    
    [self.requestTaskDict setObject:task forKey:taskTag];
    
    [self.lock unlock];
}

-(void)removeCanceledRequest:(nonnull GJHTTPRequestParameter *)rparam{
    
    [self.lock lock];
    
    [self.canceledRequestParameterTagDict removeObjectForKey:[self generatRequestTag:rparam.requestParameterTag]];
    
    [self.lock unlock];
}

-(void)removeAllCanceledRequest{
    
    [self.lock lock];
    
    [self.canceledRequestParameterTagDict removeAllObjects];
    
    [self.lock unlock];
}

#pragma mark -
-(BOOL)hasSameRequestTask:(nonnull NSString *)taskTag{
    
    BOOL hasSame=NO;
    if([NSString isEmptyString:taskTag]){
        return hasSame;
    }
    
    [self.lock lock];
    
    NSURLSessionTask *task=nil;
    task=[self.requestTaskDict objectForKey:taskTag];
    if(task){
        hasSame=YES;
    }
    
    [self.lock unlock];
    
    return hasSame;
}

-(BOOL)isSameRequest:(unsigned long long)requestParameterTag{
    
    BOOL isSame=NO;
    if(requestParameterTag==0){
        return isSame;
    }
    
    [self.lock lock];
    
    NSString *requestTag=[self generatRequestTag:requestParameterTag];
    GJHTTPRequestParameter *p=nil;
    p=[self.canceledRequestParameterTagDict objectForKey:requestTag];
    if(p){
        isSame=YES;
    }
    
    [self.lock unlock];
    
    return isSame;
}

-(nonnull NSString *)generatRequestTag:(unsigned long long)requestParameterTag{
    
    NSString *requestTag=[NSString stringWithFormat:@"%.0llu",requestParameterTag];
    
    return requestTag;
}

@end
