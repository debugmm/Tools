//
//  SLComposeViewController+Method.m
//
//  Created by wjg on 2018/10/8.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "SLComposeViewController+Method.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "RuntimeDump.h"

@implementation SLComposeViewController (Method)

- (BOOL)addVideoURL:(NSURL *)url {
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithItem:url typeIdentifier:(NSString *)kUTTypeQuickTimeMovie];    
    NSExtensionItem *extensionItem = [NSExtensionItem new];
    extensionItem.attachments = [NSArray arrayWithObject:itemProvider];
    
    //    [RuntimeDump ivarWithObject:self];
//    [RuntimeDump getMethodsWithObject:self];
    
    return [self performSelector:@selector(addExtensionItem:) withObject:extensionItem];
}

@end
