//
//  ConvertDataTool.m
//  IPAddressDemo
//
//  Created by worktree on 07/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import "ConvertDataTool.h"

///////////////
#pragma mark -
@interface ConvertDataTool()

@end

@implementation ConvertDataTool

#pragma mark -
+(NSData *)formatTCPData:(NSData *)rawData{
    
    //formatted data model
    NSMutableData *formattedData=[NSMutableData data];
    
    //calculate total data length
    NSUInteger length=rawData.length+2;
    
    //convert length-value to data.little end??
    unsigned char valChar[2];
    valChar[0]=0xff & length;
    valChar[1]=(0xff00 & length) >> 8;
    
    NSData *lengthData=[[NSData alloc] initWithBytes:valChar length:2];
    
    //add length-value data to formattedData model
    [formattedData appendData:lengthData];
    
    //add rawData to formattedData model
    [formattedData appendData:rawData];
    
    return formattedData;
}

+(uint16_t)readFormattedDataLength:(NSData *)formattedData{
    
    uint16_t length=[ConvertDataTool readFormattedDataHead:formattedData];
    
    return length;
}

+(uint16_t)readFormattedDataHeadData:(NSData *)formattedData{
    
    char valChar[TCPFormattedDataLength];
    
    [formattedData getBytes:valChar range:NSMakeRange(TCPFormattedDataHeadThirdByte, TCPFormattedDataLength)];
    
    uint16_t dstVal=(uint16_t)(((valChar[1] & 0xff) << 8) | ((valChar[0] & 0xff) << 0));
    
    return dstVal;
}

#pragma mark - convert date
+(nonnull NSString *)convertDateToYMDString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nonnull NSString *)convertDateToYMDHMSString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nonnull NSString *)convertDateToFullString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

@end