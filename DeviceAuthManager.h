//
//  DeviceAuthManager.h
//
//  Created by worktree on 26/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
@class UIViewController;

typedef void (^AlertCancelBlock)( NSDictionary * _Nullable param);
typedef void (^AlertOkBlock)( NSDictionary * _Nullable param);

#pragma mark -
@interface DeviceAuthManager : NSObject

+(instancetype _Nullable )shareManager;

#pragma mark - Jump to sys-app Setting
+(void)jumpToAppSystemSettingViewForVideoRecord;

+(void)jumpToAppSystemSettingViewForSavePhotoToAlbum;

#pragma mark - device authorization
-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                                 currentView:(UIView * _Nonnull)currentView;

-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                       currentViewController:(UIViewController * _Nonnull)currentViewController;


#pragma mark -
+(BOOL)canUsePhotoAlbum;

+(BOOL)canUseCamera;

+(BOOL)canUseMicrophone;

@end
