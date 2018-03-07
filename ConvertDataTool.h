//
//  ConvertDataTool.h
//  IPAddressDemo
//
//  Created by worktree on 07/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertDataTool : NSObject

#pragma mark -
/////////
/**
 * about tcp-package bind handling
 * base On head/body format definition
 *         head-two bytes,define the whole package length,include the head two bytes.
 *         body,the truly data.
 *         end,no definition.
 */
/////////

/**
 format the tcp transfer data

 @param rawData transfer data
 @return formatted data
 @discussion the definition format:head/body
             head,first two bytes.it's the whole data length,including the first two bytes.
             body,the needed transfer data.
 */
+(NSData *)formatTCPData:(NSData *)rawData;

+(uint16_t)readFormattedDataHead:(NSData *)formattedData;

@end
