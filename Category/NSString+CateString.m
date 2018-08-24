//
//  NSString+CateString.m
//
//  Created by wjg on 22/09/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import "NSString+CateString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CateString)

#pragma mark - Base
+(BOOL)isEmptyString:(NSString *)string{

    if(string &&
       [string isKindOfClass:[NSString class]] &&
       string.length>0){

        return NO;

    }else{

        return YES;
    }
}

+(NSString *)stringByTrimmingBothEndWhiteSpace:(NSString *)string{

    if([NSString isEmptyString:string]){

        //do not using nil,it can give rise to bug.
        return [[NSString alloc] init];

    }else{

        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

#pragma mark - Extend
-(NSComparisonResultAlias)versionStringCompare:(NSString *)versionStringB{
    
    __block NSComparisonResultAlias result=NSComparisonOccurError;
    
    //check version string
    NSString *versionStringA=[NSString stringByTrimmingBothEndWhiteSpace:self];
    if([NSString isEmptyString:versionStringA]){
    
        return result;
    }
    versionStringB=[NSString stringByTrimmingBothEndWhiteSpace:versionStringB];
    if([NSString isEmptyString:versionStringB]){
    
        return result;
    }
    
    //convert version string to components array
    NSMutableArray *vsa=[[versionStringA componentsSeparatedByString:@"."] mutableCopy];
    NSMutableArray *vsb=[[versionStringB componentsSeparatedByString:@"."] mutableCopy];
    
    //format array
    NSInteger count=vsa.count-vsb.count;
    id midarray=nil;
    if(count>0){
        
        midarray=vsb;
        
    }else if(count<0){
        
        midarray=vsa;
    }
    
    if(midarray){
    
        count=labs(count);
        
        for(NSInteger i=1;i<=count;i++){
            
            [((NSMutableArray *)midarray) addObject:@"0"];
        }
    }
    
    //compare
    result=NSOrderedSameAlias;
    [vsa enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger objAInteger=((NSString *)obj).integerValue;
        NSInteger objBInteger= [[vsb objectAtIndex:idx] integerValue];
        
        if(objAInteger!=objBInteger){
        
            if(objAInteger>objBInteger){//Descending
            
                result=NSOrderedDescendingAlias;
                
            }else{
            
                result=NSOrderedAscendingAlias;
            }
            
            *stop=YES;
        }
    }];
    
    return result;
}

#pragma mark - about MD5
+(NSString *)generateStringMD5:(nonnull NSString *)string{
    
    if([NSString isEmptyString:string]){
        return @"";
    }
    
    const char *cStr=string.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);//generate string md5
    
    NSMutableString *md5Str=[[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++){
        
        [md5Str appendFormat:@"%02x",digest[i]];
    }
    
    return md5Str;
}

@end
