//
//  DeviceAuthManager.m
//
//  Created by worktree on 26/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "DeviceAuthManager.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CLLocationManager.h>//CoreLocation.CLLocationManager

#import <AVFoundation/AVFoundation.h>

//define
#define AlertCancelBtnIndex (0)
#define AlertSureBtnIndex (1)

#define PrefsScheme (@"xoxoxo")
#define PrivacyPS (@"root=Privacy")
#define PhotoPS (@"root=Photos")

//about file size
#define KB (1024ul)
#define MB (((KB) * (KB)))
#define GB (((MB) * (KB)))
#define TB (((GB) * (KB)))

static DeviceAuthManager *shareManager=nil;

#pragma mark -
@interface DeviceAuthManager()<UIAlertViewDelegate>

@property(nonatomic,copy)AlertOkBlock okBlock;
@property(nonatomic,copy)AlertCancelBlock cancelBlock;

@property(nonatomic,strong)UIViewController *presentViewController;

@end

@implementation DeviceAuthManager

+(instancetype)shareManager{
    
    static dispatch_once_t one;
    
    dispatch_once(&one, ^{
        
        shareManager=[[DeviceAuthManager alloc] init];
    });
    
    return shareManager;
}

#pragma mark - Jump to sys-app Setting
+(void)jumpToAppSystemSettingViewForVideoRecord{
    
    NSURL *url;
    
    if([UIDevice currentDevice].systemVersion.floatValue<8.0){
        
        NSString *s=[NSString stringWithFormat:@"%@:root=%@",@"prefs",AppBundleId];//@"%@:%@",PrefsScheme,PrivacyPS];
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
    
        NSString *s=[NSString stringWithFormat:@"%@:root=%@",@"prefs",AppBundleId];//@"%@:%@",PrefsScheme,PhotoPS];

        url=[NSURL URLWithString:s];
    }
    else{

        url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }

    [DeviceAuthManager jumpToAppSystemSettingViewWithURL:url];
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

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==AlertSureBtnIndex){
        
        self.okBlock(nil);
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

#pragma mark - Property
-(UIViewController *)presentViewController{
    
    if(!_presentViewController){
        
        _presentViewController=[[UIViewController alloc] init];
    }
    
    return _presentViewController;
}

@end
