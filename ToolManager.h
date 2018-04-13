//
//  ToolManager.h
//
//  Created by wjg on 26/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

//define
#define InputTextFieldContentKey (@"content")

#define NewPasswordKey (@"newpwd")
#define OldPasswordKey (@"oldpwd")

@class UIView;
@class UIViewController;

typedef void (^AlertCancelBlock)( NSDictionary * _Nullable param);
typedef void (^AlertOkBlock)( NSDictionary * _Nullable param);

#pragma mark -
@interface ToolManager : NSObject

+(instancetype _Nullable )shareManager;

#pragma mark - Generate random int
+(unsigned long long)generateSteppedIntFromDate;

#pragma mark - Alert Password Change
-(void)alertChangePassword:(nonnull NSString *)title
                   message:(nullable NSString *)message
     currentViewController:(nonnull UIViewController *)currentViewController
               cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                   okBlock:(AlertOkBlock _Nullable)okBlock;

#pragma mark - Alert TextInput
-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
  currentViewController:(nonnull UIViewController *)currentViewController
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock;

#pragma mark -
-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
            cancelTitle:(nonnull NSString *)cancelTitle
                okTitle:(nonnull NSString *)okTitle
  currentViewController:(nonnull UIViewController *)currentViewController
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock;

-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
            cancelTitle:(nonnull NSString *)cancelTitle
                okTitle:(nonnull NSString *)okTitle
            currentView:(nonnull UIView *)currentView
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock;

#pragma mark - Jump to sys-app Setting
+(void)jumpToAppSystemSettingViewForVideoRecord;

+(void)jumpToAppSystemSettingViewForSavePhotoToAlbum;

#pragma mark - device authorization
-(void)alertVideoRecordAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                      cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                            currentViewController:(UIViewController * _Nonnull)currentViewController;

#pragma mark -
-(void)alertPhotoAlbumAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                     cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                           currentViewController:(UIViewController * _Nonnull)currentViewController;

#pragma mark -
-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                                 currentView:(UIView * _Nonnull)currentView;

-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                       currentViewController:(UIViewController * _Nonnull)currentViewController;

#pragma mark -
-(void)alertMicrophoneAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                     cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                           currentViewController:(UIViewController * _Nonnull)currentViewController;

#pragma mark -
+(BOOL)canUsePhotoAlbum;

+(BOOL)canUseCamera;

+(BOOL)canUseMicrophone;

@end
