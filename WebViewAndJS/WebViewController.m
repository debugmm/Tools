//
//  WebViewController.m
//  WebViewController
//
//  Created by worktree on 03/04/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self clearNavigationControllerPopGestureRecognizerDelegate];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initConfigNavigation];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self clearNavigationControllerPopGestureRecognizerDelegate];
}

#pragma mark -
-(void)initConfigNavigation{
    
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController setNavigationBarHidden:self.shouldHiddenNavigationBar animated:YES];
    
    //if anyone h5 use a webViewController presenting,we should custom the gesture.delegate
    //else we should not do this.because the effect is very bad.
    //so blow code just placehold.
    
    //discussion: if we custom the gesture.delegate,when anyone webviewcontroller disappeared
    //               we must set the gesture.delegate=nil.if so others can use pop gesture recognizer.
    //    if(self.navigationController){
    //
    //        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    //    }
}

-(void)clearNavigationControllerPopGestureRecognizerDelegate{
    
    if(self.navigationController){
        
        self.navigationController.interactivePopGestureRecognizer.delegate=nil;
    }
}

#pragma mark -
-(void)initConfig{
    
    [self initConfigWebView];
}

-(void)initConfigWebView{
    
    self.webView.frame=self.view.bounds;
    [self.view addSubview:self.webView];
}

#pragma mark -
-(BOOL)webViewCanGoBack{
    
    BOOL can=NO;
    if(_webView){
        
        can=_webView.canGoBack;
    }
    
    return can;
}

-(void)webViewGoBack{
    
    [_webView goBack];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
//    BOOL shoulded=NO;
//
//    if([self webViewCanGoBack]){
//        [self webViewGoBack];
//    }
//    else{
//        shoulded=YES;
//    }
    
    return YES;
}

#pragma mark - Property
-(UIWebView *)webView{
    
    if(!_webView){
        
        _webView=[[UIWebView alloc] init];
    }
    
    return _webView;
}

@end
