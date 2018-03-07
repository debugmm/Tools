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

+(uint16_t)readFormattedDataHead:(NSData *)formattedData{
    
    //read first 2 bytes.it is the whole formattedData length.
    uint16_t val0=0;
    uint16_t val1=0;
    [formattedData getBytes:&val0 range:NSMakeRange(0, 1)];
    [formattedData getBytes:&val1 range:NSMakeRange(1, 1)];
    
    uint16_t dstVal=(val0 & 0xff) + ((val1 << 8) & 0xff00);
    
    return dstVal;
}

@end
