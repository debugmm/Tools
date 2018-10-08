//
//  ShareLocalVideoToWeixinAndQQInAppExampleViewController.m
//
//  Created by wjg on 08/10/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "ShareLocalVideoToWeixinAndQQInAppExampleViewController.h"

#import "SLComposeViewController+Method.h"

@interface ShareLocalVideoToWeixinAndQQInAppExampleViewController ()

@end

@implementation ShareLocalVideoToWeixinAndQQInAppExampleViewController

#pragma mark - viewController init

#pragma mark - viewController lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfigs];
    
    [self configs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init configs
-(void)initConfigs{
    
    //init config views
    //usually we do views auto layout init configs in initConfigViews
    
    [self initConfigViews];
}

#pragma mark - init config views
-(void)initConfigViews{
    // invoke all views init config method
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName{}

#pragma mark - init config datas
-(void)initConfigDatas{
    
    //in this method,usually we do request data from internet.
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName+Data{}

#pragma mark - configs
-(void)configs{
    
    //in this mehod,usually we do views config on basis of data or some status after initConfig views
}

#pragma mark -
// all sub config method at here.
//example: config+ViewClassName{}
#pragma mark - share local video to weixin-qq in app
-(void)exampleActivityViewController{
    
    NSString *recordVideoOutputURLString=@"";//recommand mp4 format
    
    NSURL *recordVideoOutputFileURL=[NSURL fileURLWithPath:recordVideoOutputURLString];
    UIActivityViewController *vvc=[[UIActivityViewController alloc] initWithActivityItems:@[recordVideoOutputFileURL] applicationActivities:nil];
    vvc.excludedActivityTypes=@[UIActivityTypePostToFacebook,
                                UIActivityTypePostToTwitter,
                                UIActivityTypePostToWeibo,
                                UIActivityTypePrint,
                                UIActivityTypeCopyToPasteboard,
                                UIActivityTypePostToFlickr,
                                UIActivityTypePostToTencentWeibo,
                                UIActivityTypeAirDrop,
                                ];
    
    [self presentViewController:vvc animated:YES completion:nil];
}

-(void)exampleSLComposeViewController{
    
    NSString *recordVideoOutputURLString=@"";//recommand mp4 format
    NSURL *recordVideoOutputFileURL=[NSURL fileURLWithPath:recordVideoOutputURLString];
    
    NSString *test = @"com.tencent.xin.sharetimeline";
    // 2.创建分享的控制器
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:test];
    if (composeVc == nil){
        NSLog(@"没有安装微信");
        return;
        
    }
    //添加分享的文字
    //[composeVc setInitialText:shareTitle];
    
    //添加一个图片
    //[composeVc addImage:[UIImage imageNamed:@"图片名"]];
    
    //添加一个链接
    [composeVc addVideoURL:recordVideoOutputFileURL];
    
    //监听用户点击了取消还是发送 /* SLComposeViewControllerResultCancelled, SLComposeViewControllerResultDone */
    composeVc.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSLog(@"点击了取消");
        }
        else {
            NSLog(@"点击了发送");
        }
    };
    
    //弹出分享控制器（以Modal形式弹出）
    [self presentViewController:composeVc animated:YES completion:nil];
}

-(void)exampleWexinQQSDK{
    //use weixin sdk share local record video.
    //it can not complement like weixin-app,just use the sdk's fileData message
}

#pragma mark - property
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
