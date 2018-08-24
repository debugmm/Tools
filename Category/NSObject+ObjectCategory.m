//
//  NSObject+ObjectCategory.m
//
//  Created by worktree on 09/07/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "NSObject+ObjectCategory.h"

#import <JavaScriptCore/JavaScriptCore.h>

//define
#define WebViewDidCreatedJSContextNoti (@"com.example.didCreateContextNotification")

@implementation NSObject (MTObjectCategory)

//- (void)webView:(WebView *)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(WebFrame *)frame{
//    [[NSNotificationCenter defaultCenter] postNotificationName:WebViewDidCreatedJSContextNoti object:context];
//}

- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame{

    [[NSNotificationCenter defaultCenter] postNotificationName:WebViewDidCreatedJSContextNoti object:ctx];
}

#pragma mark - Test
//-(void)viewControllerViewDidLoad{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreatedJSContext:) name:WebViewDidCreatedJSContextNoti object:nil];
//}

#pragma mark -
//-(void)didCreatedJSContext:(NSNotification *)noti{
//
//    NSString *indentifier = [NSString stringWithFormat:@"indentifier%lud", (unsigned long)self.h5WebView.hash];
//    NSString *indentifierJS = [NSString stringWithFormat:@"var %@ = '%@'", indentifier, indentifier];
//    [self.h5WebView stringByEvaluatingJavaScriptFromString:indentifierJS];
//    JSContext *context = noti.object;
//
//    //判断这个context是否属于当前这个webView
//    if (![context[indentifier].toString isEqualToString:indentifier]){
//        return;
//    }
//
//    //如果属于这个webView
//    context[@"InjectOsUser"] = self;
//}

@end
