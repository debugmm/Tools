//
//  ToolManager.m
//
//  Created by wjg on 26/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "ToolManager.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CLLocationManager.h>//CoreLocation.CLLocationManager

#import <AVFoundation/AVFoundation.h>

#import <UIKit/UIKit.h>

#import "MTAppConst.h"
#import "NSString+CateString.h"

//define
#define AlertCancelBtnIndex (0)
#define AlertSureBtnIndex (1)

#define PrefsScheme (@"motouappprivateSettingScheme")
#define PrivacyPS (@"root=Privacy")
#define PhotoPS (@"root=Photos")

#define Nanoseconds (1000000000)

static ToolManager *shareManager=nil;
static unsigned long long basicRandomInt=0;

#pragma mark -
@interface ToolManager()<UIAlertViewDelegate>

@property(nonatomic,copy)AlertOkBlock okBlock;
@property(nonatomic,copy)AlertCancelBlock cancelBlock;

@property(nonatomic,strong)UIViewController *presentViewController;

@end

@implementation ToolManager

+(instancetype)shareManager{
    
    static dispatch_once_t one;
    
    dispatch_once(&one, ^{
        
        shareManager=[[ToolManager alloc] init];
        
        basicRandomInt = (unsigned long long)([NSDate date].timeIntervalSinceReferenceDate * (Nanoseconds));
    });
    
    return shareManager;
}

#pragma mark - Generate random int
+(unsigned long long)generateSteppedIntFromDate{
    
    unsigned long long endInt = (unsigned long long)([NSDate date].timeIntervalSinceReferenceDate * (Nanoseconds));
    
    unsigned long long steppedInt=endInt-basicRandomInt;
    
    return steppedInt;
}

#pragma mark - Alert Password Change
-(void)alertChangePassword:(nonnull NSString *)title
                   message:(nullable NSString *)message
     currentViewController:(nonnull UIViewController *)currentViewController
               cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                   okBlock:(AlertOkBlock _Nullable)okBlock{
    
    NSString *okTitle=NSLocalizedString(@"alertPage_okButton_title", nil);
    NSString *cancelTitle=NSLocalizedString(@"alertPage_cancelButton_title", nil);
    
    [self alertChangePassword:title
                      message:message
                  cancelTitle:cancelTitle
                      okTitle:okTitle
        currentViewController:currentViewController
                  cancelBlock:cancelBlock
                      okBlock:okBlock];
}

-(void)alertChangePassword:(nonnull NSString *)title
                   message:(nullable NSString *)message
               cancelTitle:(nonnull NSString *)cancelTitle
                   okTitle:(nonnull NSString *)okTitle
     currentViewController:(nonnull UIViewController *)currentViewController
               cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                   okBlock:(AlertOkBlock _Nullable)okBlock{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
        
        alerView.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        
        //old password
        UITextField *tflogin=[alerView textFieldAtIndex:0];
        tflogin.placeholder=NSLocalizedString(@"alertPage_oldPasswordTextfield_placeholder_text", nil);
        tflogin.secureTextEntry=NO;
        tflogin.clearButtonMode=UITextFieldViewModeWhileEditing;
        
        //new password
        UITextField *tfpw=[alerView textFieldAtIndex:1];
        tfpw.placeholder=NSLocalizedString(@"alertPage_newPasswordTextfield_placeholder_text", nil);
        tfpw.secureTextEntry=NO;
        tfpw.clearButtonMode=UITextFieldViewModeWhileEditing;
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //text input
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            //old password
            textField.placeholder=NSLocalizedString(@"alertPage_oldPasswordTextfield_placeholder_text", nil);
            textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            //new password
            textField.placeholder=NSLocalizedString(@"alertPage_newPasswordTextfield_placeholder_text", nil);
            textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        }];
        
        //ok btn
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *oldpwd = (UITextField *)[alert.textFields firstObject];
            UITextField *newpwd=(UITextField *)[alert.textFields lastObject];
            
            NSString *oldp=oldpwd.text;
            NSString *newp=newpwd.text;
            
            if([NSString isEmptyString:oldp] ||
               [NSString isEmptyString:newp]){
                return;
            }
            
            NSDictionary *pd=@{OldPasswordKey:oldp,
                               NewPasswordKey:newp
                               };
            self.okBlock(pd);
        }];
        
        //cancel btn
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Alert TextInput
-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
  currentViewController:(nonnull UIViewController *)currentViewController
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock{
    
    NSString *okTitle=NSLocalizedString(@"alertPage_okButton_title", nil);
    NSString *cancelTitle=NSLocalizedString(@"alertPage_cancelButton_title", nil);
    
    [self alertAnTextInput:title
                   message:message
               cancelTitle:cancelTitle
                   okTitle:okTitle
     currentViewController:currentViewController
               cancelBlock:cancelBlock
                   okBlock:okBlock];
}

#pragma mark -
-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
            cancelTitle:(nonnull NSString *)cancelTitle
                okTitle:(nonnull NSString *)okTitle
  currentViewController:(nonnull UIViewController *)currentViewController
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
        
        alerView.alertViewStyle=UIAlertViewStylePlainTextInput;
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //text input
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            //
        }];
        
        //ok btn
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *tf = (UITextField *)[alert.textFields firstObject];
            NSString *inputStr=tf.text;
            if([NSString isEmptyString:inputStr]){
                return;
            }
            
            self.okBlock(@{InputTextFieldContentKey:inputStr});
        }];
        
        //cancel btn
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)alertAnTextInput:(nonnull NSString *)title
                message:(nullable NSString *)message
            cancelTitle:(nonnull NSString *)cancelTitle
                okTitle:(nonnull NSString *)okTitle
            currentView:(nonnull UIView *)currentView
            cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                okBlock:(AlertOkBlock _Nullable)okBlock{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //text input
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            //
        }];
        
        //ok btn
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *tf = (UITextField *)[alert.textFields firstObject];
            NSString *inputStr=tf.text;
            if([NSString isEmptyString:inputStr]){
                return;
            }
            self.okBlock(@{InputTextFieldContentKey:inputStr});
        }];
        
        //cancel btn
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        //show alert controller on current view
        UIImage *image=[self snapshotView:currentView];
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.frame=self.presentViewController.view.bounds;
        imageView.image=image;
        
        [self.presentViewController.view addSubview:imageView];
        
        [currentView addSubview:self.presentViewController.view];
        
        [self.presentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Jump to sys-app Setting
+(void)jumpToAppSystemSettingViewForVideoRecord{
    
    NSURL *url;
    
    if([UIDevice currentDevice].systemVersion.floatValue<8.0){
        
        NSString *s=[NSString stringWithFormat:@"%@:%@",PrefsScheme,PrivacyPS];
        url=[NSURL URLWithString:s];
    }
    else{
        
        url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    
    [ToolManager jumpToAppSystemSettingViewWithURL:url];
}

+(void)jumpToAppSystemSettingViewForSavePhotoToAlbum{
    
    NSURL *url;
    
    if([UIDevice currentDevice].systemVersion.floatValue<8.0){
    
        NSString *s=[NSString stringWithFormat:@"%@:%@",PrefsScheme,PhotoPS];

        url=[NSURL URLWithString:s];
    }
    else{

        url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }

    [ToolManager jumpToAppSystemSettingViewWithURL:url];
}

+(void)jumpToAppSystemSettingViewWithURL:(NSURL * _Nonnull)url{
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        
        if([UIDevice currentDevice].systemVersion.floatValue<10.0){
            
            [[UIApplication sharedApplication] openURL:url];
        }
        else{
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url
                                                   options:@{}
                                         completionHandler:^(BOOL success) {
                                             
                                         }];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

#pragma mark - device authorization
-(void)alertVideoRecordAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                      cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                            currentViewController:(UIViewController * _Nonnull)currentViewController{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    //config alert view
    NSString *title=NSLocalizedString(@"alertPage_videoRecordAuth_title", nil);
    NSString *msg=@"";
    
    NSString *cancelBtnText=NSLocalizedString(@"alertPage_cameraAuth_cancelBtn_text", nil);
    NSString *sureBtnText=NSLocalizedString(@"alertPage_cameraAuth_settingBtn_text", nil);
    
    if(![ToolManager canUseCamera]){
        //how to gracefully alert view
        NSString *mt=NSLocalizedString(@"alertPage_videoRecordAuth_camera_text", nil);
        title=[NSString stringWithFormat:@"%@%@%@",AppDisplayName,title,mt];
        
        msg=NSLocalizedString(@"alertPage_cameraAuth_message_text", nil);
    }
    if(![ToolManager canUseMicrophone]){
        
        NSString *mt=NSLocalizedString(@"alertPage_videoRecordAuth_microphone_text", nil);
        title=[NSString stringWithFormat:@"%@%@",title,mt];
        
        NSString *mMsg=NSLocalizedString(@"alertPage_microphoneAuth_message_text", nil);
        msg=[NSString stringWithFormat:@"%@\n%@",msg,mMsg];
    }
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelBtnText otherButtonTitles:sureBtnText, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:sureBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.okBlock(nil);
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
-(void)alertPhotoAlbumAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                     cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                           currentViewController:(UIViewController * _Nonnull)currentViewController{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    //config alert view
    NSString *mt=NSLocalizedString(@"alertPage_photoAlbumAuth_title", nil);
    NSString *title=[NSString stringWithFormat:@"%@%@",AppDisplayName,mt];
    NSString *msg=NSLocalizedString(@"alertPage_photoAlbumAuth_message_text", nil);
    NSString *cancelBtnText=NSLocalizedString(@"alertPage_photoAlbumAuth_cancelBtn_text", nil);
    NSString *sureBtnText=NSLocalizedString(@"alertPage_photoAlbumAuth_settingBtn_text", nil);
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelBtnText otherButtonTitles:sureBtnText, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:sureBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.okBlock(nil);
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                                 currentView:(UIView * _Nonnull)currentView{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    //config alert view
    NSString *mt=NSLocalizedString(@"alertPage_cameraAuth_title", nil);
    NSString *title=[NSString stringWithFormat:@"%@%@",AppDisplayName,mt];
    NSString *msg=NSLocalizedString(@"alertPage_cameraAuth_message_text", nil);
    NSString *cancelBtnText=NSLocalizedString(@"alertPage_cameraAuth_cancelBtn_text", nil);
    NSString *sureBtnText=NSLocalizedString(@"alertPage_cameraAuth_settingBtn_text", nil);
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelBtnText otherButtonTitles:sureBtnText, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:sureBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.presentViewController.view removeFromSuperview];
            
            self.okBlock(nil);
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.presentViewController.view removeFromSuperview];
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        UIImage *image=[self snapshotView:currentView];
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.frame=self.presentViewController.view.bounds;
        imageView.image=image;
        
        [self.presentViewController.view addSubview:imageView];
        
        [currentView addSubview:self.presentViewController.view];
        
        [self.presentViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(void)alertCameraAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                 cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                       currentViewController:(UIViewController * _Nonnull)currentViewController{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    //config alert view
    NSString *mt=NSLocalizedString(@"alertPage_cameraAuth_title", nil);
    NSString *title=[NSString stringWithFormat:@"%@%@",AppDisplayName,mt];
    NSString *msg=NSLocalizedString(@"alertPage_cameraAuth_message_text", nil);
    NSString *cancelBtnText=NSLocalizedString(@"alertPage_cameraAuth_cancelBtn_text", nil);
    NSString *sureBtnText=NSLocalizedString(@"alertPage_cameraAuth_settingBtn_text", nil);
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelBtnText otherButtonTitles:sureBtnText, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:sureBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.okBlock(nil);
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
-(void)alertMicrophoneAuthSettingViewWithOkBlock:(AlertOkBlock _Nullable)okBlock
                                     cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
                           currentViewController:(UIViewController * _Nonnull)currentViewController{
    
    //set block
    self.okBlock=okBlock;
    self.cancelBlock=cancelBlock;
    
    //config alert view
    NSString *mt=NSLocalizedString(@"alertPage_microphoneAuth_title", nil);
    NSString *title=[NSString stringWithFormat:@"%@%@",AppDisplayName,mt];
    NSString *msg=NSLocalizedString(@"alertPage_microphoneAuth_message_text", nil);
    NSString *cancelBtnText=NSLocalizedString(@"alertPage_microphoneAuth_cancelBtn_text", nil);
    NSString *sureBtnText=NSLocalizedString(@"alertPage_microphoneAuth_settingBtn_text", nil);
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        //use UIAlertView
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelBtnText otherButtonTitles:sureBtnText, nil];
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:sureBtnText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.okBlock(nil);
        }];
        
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtnText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            self.cancelBlock(nil);
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
+(BOOL)canUsePhotoAlbum{
    
    BOOL canUse=YES;
    
    if([UIDevice currentDevice].systemVersion.floatValue <= 8.0){
        
        ALAuthorizationStatus auth=[ALAssetsLibrary authorizationStatus];
        
        if(auth==kCLAuthorizationStatusRestricted ||
           auth==kCLAuthorizationStatusDenied){
            
            canUse=NO;//denied
        }
    }
    else{
        
        PHAuthorizationStatus auth=[PHPhotoLibrary authorizationStatus];
        
        if(auth==PHAuthorizationStatusDenied ||
           auth==PHAuthorizationStatusRestricted){
            
            canUse=NO;//denied
        }
    }
    
    return canUse;
}

+(BOOL)canUseCamera{
    
    BOOL canUse=YES;
    
    NSString *mediaType=AVMediaTypeVideo;
    
    AVAuthorizationStatus auth=[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(auth==AVAuthorizationStatusRestricted ||
       auth==AVAuthorizationStatusDenied){
        
        canUse=NO;
    }
    
    return canUse;
}

+(BOOL)canUseMicrophone{
    
    BOOL canUse=YES;
    
    NSString *mediaType=AVMediaTypeAudio;
    AVAuthorizationStatus auth=[AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(auth==AVAuthorizationStatusRestricted ||
       auth==AVAuthorizationStatusDenied){
        
        canUse=NO;
    }
    
    return canUse;
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSDictionary *pd=nil;
    if(alertView.alertViewStyle==UIAlertViewStyleLoginAndPasswordInput){
        
        //old password
        UITextField *old=[alertView textFieldAtIndex:0];
        NSString *oldp=old.text;
        
        //new password
        UITextField *new=[alertView textFieldAtIndex:1];
        NSString *newp=new.text;
        
        if([NSString isEmptyString:oldp] ||
           [NSString isEmptyString:newp]){
            return;
        }
        
        pd=@{OldPasswordKey:oldp,
             NewPasswordKey:newp
             };
    }
    else{
        
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString *content=tf.text;
        
        if([NSString isEmptyString:content]){
            return;
        }
        
        pd=@{InputTextFieldContentKey:content};
    }
    
    if(buttonIndex==AlertSureBtnIndex){
        
        self.okBlock(pd);
    }
    else{
        
        self.cancelBlock(nil);
    }
}

#pragma mark - snapshot current view
-(UIImage *)snapshotView:(UIView * _Nonnull)currentView{
    
    UIWindow *keyWindow=[UIApplication sharedApplication].keyWindow;
    
    CGSize size=keyWindow.bounds.size;//currentView.bounds.size;
    CGFloat scale=[UIScreen mainScreen].scale;

    //begin Image Context
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    
    [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();

    //end Image Context
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Property
-(UIViewController *)presentViewController{
    
    if(!_presentViewController){
        
        _presentViewController=[[UIViewController alloc] init];
    }
    
    return _presentViewController;
}

@end
