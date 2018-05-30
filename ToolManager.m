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

#import "MTAppConst.h"
#import "NSString+CateString.h"
#import <AFNetworking.h>

//define
#define AlertCancelBtnIndex (0)
#define AlertSureBtnIndex (1)

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

#pragma mark - action sheet
+(nonnull UIAlertController*)alertCameraPhotoAlbumActionSheetWithCurrentViewController:(nonnull UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)currentViewController{
    
    //config image picker
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=currentViewController;
    imagePicker.allowsEditing=YES;
    
    //config action sheet
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"选片图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(alert) weakAlert=alert;
    __weak typeof(currentViewController) weakCurController=currentViewController;
    
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        
        [weakCurController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *photoAlbumAction=[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        [weakCurController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:photoAlbumAction];
    [alert addAction:cancelAction];
    
    //show alert
    [currentViewController presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

#pragma mark - Alert An Prompt
-(void)alertPromptView:(nonnull NSString *)title
               message:(nullable NSString *)message
 currentViewController:(nonnull UIViewController *)currentViewController
           cancelBlock:(AlertCancelBlock _Nullable)cancelBlock
               okBlock:(AlertOkBlock _Nullable)okBlock{
    
    NSString *okTitle=NSLocalizedString(@"alertPage_okButton_title", nil);
    NSString *cancelTitle=NSLocalizedString(@"alertPage_cancelButton_title", nil);
    
    [self alertPromptView:title
                  message:message
              cancelTitle:cancelTitle
                  okTitle:okTitle
    currentViewController:currentViewController
              cancelBlock:cancelBlock okBlock:okBlock];
}

-(void)alertPromptView:(nonnull NSString *)title
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
        
        alerView.delegate=self;
        alerView.alertViewStyle=UIAlertViewStyleDefault;
        
        [alerView show];
    }
    else{
        //use UIAlertController
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
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
        alerView.delegate=self;
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
        alerView.delegate=self;
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
        alerView.delegate=self;
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
        
        NSString *s=[NSString stringWithFormat:@"%@:root=%@",@"prefs",AppBundleId];
        url=[NSURL URLWithString:s];
    }
    else{
        
        url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    
    [DeviceAuthManager jumpToAppSystemSettingViewWithURL:url];
}

+(void)jumpToAppSystemSettingViewForSavePhotoToAlbum{
    
    NSURL *url;
    
    if([UIDevice currentDevice].systemVersion.floatValue<8.0){
        
        NSString *s=[NSString stringWithFormat:@"%@:root=%@",@"prefs",AppBundleId];//PrefsScheme,PhotoPS
        
        url=[NSURL URLWithString:s];
    }
    else{
        
        url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    
    [DeviceAuthManager jumpToAppSystemSettingViewWithURL:url];
}

+(void)jumpToSettingPhotoAlbumAuth{
    
    [DeviceAuthManager jumpToAppSystemSettingViewForSavePhotoToAlbum];
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

#pragma mark - convert FileSize to TB-GB-MB-KB
+(nullable NSString *)convertLongFileSizeValueToTGMBString:(AliasFileSize)fileSize{
    
    NSString *xB=@"";
    
    if(fileSize<MB && fileSize>0){
        //convert To KB
        AliasFileSize kbb=fileSize/KB;
        xB=[NSString stringWithFormat:@"%lluKB",kbb];
    }
    else if(fileSize>MB && fileSize<GB){
        //convert To MB
        AliasFileSize kbb=fileSize/MB;
        xB=[NSString stringWithFormat:@"%lluMB",kbb];
    }
    else if(fileSize>GB && fileSize<TB){
        //convert To GB
        AliasFileSize kbb=fileSize/GB;
        xB=[NSString stringWithFormat:@"%lluGB",kbb];
    }
    else if(fileSize>TB){
        //convert To TB
        AliasFileSize kbb=fileSize/TB;
        xB=[NSString stringWithFormat:@"%lluTB",kbb];
    }
    
    return xB;
}

#pragma mark - compressImage to maxLength bytes
+(UIImage *)compressImage:(UIImage *)image toByte:(unsigned long long)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength){
        return image;
    }
    
    //try to keep image quality when it be compressed.
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        
        if (data.length < maxLength * 0.9) {
            min = compression;
        }
        else if (data.length > maxLength) {
            max = compression;
        }
        else {
            break;
        }
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength){
        return resultImage;
    }
    
    // Compress image to special size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        
        // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

+(UIImage *)compressImage:(UIImage *)image toSize:(CGSize)size{
    
    CGFloat scale=[UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+(NSData *)convertImageToData:(nonnull UIImage *)image{
    
    NSData *data;
    if(image &&
       [image isKindOfClass:[UIImage class]]){
        
        data=UIImageJPEGRepresentation(image, 1.0);
    }
    
    return data;
}

#pragma mark -
+(nullable UIImage *)addImageToImageCenter:(nonnull NSString *)imageNameA
                             withImageName:(nonnull NSString *)imageNameB{
    
    UIImage *image=[ToolManager addImageToImageCenter:imageNameA withImageName:imageNameB delat:0];
    
    return image;
}

+(nullable UIImage *)addImageToImageCenter:(nonnull NSString *)imageNameA
                             withImageName:(nonnull NSString *)imageNameB
                                     delat:(CGFloat)delat{
    //add imageB into imageA.
    //imageA.size >= imageB.size
    
    UIImage *imageA=[UIImage imageNamed:imageNameA];
    UIImage *imageB=[UIImage imageNamed:imageNameB];
    
    CGSize sA=imageA.size;
    CGSize sB=imageB.size;
    
    CGFloat scale=[UIScreen mainScreen].scale;
    
    //we asume that sA > sB.
    CGFloat x=(sA.width-sB.width-delat)/2.0;
    CGFloat y=(sA.height-sB.height-delat)/2.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(sA.width*scale, sA.height*scale));
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    [imageA drawInRect:CGRectMake(0, 0, sA.width, sA.height)];
    [imageB drawInRect:CGRectMake(x, y, sB.width+delat, sB.height+delat)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:resultImage.CGImage scale:scale orientation:UIImageOrientationUp];
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

#pragma mark - convert date
+(nonnull NSDateFormatter *)generateLocalDateFormatter{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    format.locale=[NSLocale currentLocale];
    format.timeZone=[NSTimeZone localTimeZone];
    
    return format;
}

+(nonnull NSString *)convertDateToYMDString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[ToolManager generateLocalDateFormatter];
    
    [format setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nonnull NSString *)convertDateToYMDHMSString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[ToolManager generateLocalDateFormatter];
    
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nonnull NSString *)convertDateToFullString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[ToolManager generateLocalDateFormatter];
    
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nullable NSDate *)convertDateStringToDate:(nonnull NSString *)dateString
                                 dateFormat:(nonnull NSString *)dateFormatString{
    
    NSDateFormatter *df=[ToolManager generateLocalDateFormatter];
    df.dateFormat=dateFormatString;
    
    NSDate *date=[df dateFromString:dateString];
    
    return date;
}

+(nullable NSDate *)convertYMDDateStringToDate:(nonnull NSString *)dateString{
    
    NSString *dateFormat=@"yyyy-MM-dd";
    
    NSDate *date=[ConvertDataTool convertDateStringToDate:dateString dateFormat:dateFormat];
    
    return date;
}

#pragma mark -
+(nonnull NSString *)getNowTimeIntervalStringSince1970{
    //get time interval
    NSTimeInterval ti=[NSDate date].timeIntervalSince1970;
    unsigned long long t=(unsigned long long)ti;
    NSString *timeStr=[NSString stringWithFormat:@"%llx",t];
    
    return timeStr;
}

+(nonnull NSString *)getNowTimeIntervalDecimalStringSince1970{
    //get time interval
    NSTimeInterval ti=[NSDate date].timeIntervalSince1970;
    unsigned long long t=(unsigned long long)ti;
    NSString *timeStr=[NSString stringWithFormat:@"%lld",t];
    
    return timeStr;
}

+(NSTimeInterval)getNowTimeIntervalSince1970{
    
    NSTimeInterval ti=[NSDate date].timeIntervalSince1970;
    
    return ti;
}

+(nullable NSString *)convertTimeIntervalToDecimalString:(NSTimeInterval)timeinterval{
    
    unsigned long long t=(unsigned long long)timeinterval;
    NSString *timeStr=[NSString stringWithFormat:@"%lld",t];
    
    return timeStr;
}

#pragma mark - NetworkReachability
-(void)listenNetworkReachability{
    
    [self addNetworkReachabilityObserver];
    [self startMonitorNetwork];
}

-(void)stopMonitorNetwork{
    
    AFNetworkReachabilityManager *m=[AFNetworkReachabilityManager sharedManager];
    
    [m stopMonitoring];
}

#pragma mark -
-(void)startMonitorNetwork{
    
    AFNetworkReachabilityManager *m=[AFNetworkReachabilityManager sharedManager];
    
    [m startMonitoring];
}

-(void)addNetworkReachabilityObserver{
    
    NSNotificationCenter *c=[NSNotificationCenter defaultCenter];
    
    [c addObserver:self selector:@selector(networkStatusChangedNoti:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark -
-(void)networkStatusChangedNoti:(NSNotification *)noti{
    /*
     * AFNetworkReachabilityStatusUnknown          = -1,
     * AFNetworkReachabilityStatusNotReachable     = 0,
     * AFNetworkReachabilityStatusReachableViaWWAN = 1,
     * AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */
    AFNetworkReachabilityStatus status=[[noti.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
    _currStatus  = status;
    if(status != AFNetworkReachabilityStatusReachableViaWiFi){
        //wifi unusable,stop listen udp Datagram
        NSLog(@"wifi unusable");
        
        //should close tcp socket
        [self closeSocket];
        
    }else{
        //wifi usable,
        NSLog(@"wifi usable");
    }
}

#pragma mark - Property
-(UIViewController *)presentViewController{
    
    if(!_presentViewController){
        
        _presentViewController=[[UIViewController alloc] init];
    }
    
    return _presentViewController;
}

@end
