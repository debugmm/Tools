//
//  GJWKWebViewController.m
//
//  Created by worktree on 18/10/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "GJWKWebViewController.h"

#import "NSString+CateString.h"
#import "MTAppConst.h"

#import "ErrorPromptView.h"

#import <WebKit/WebKit.h>
#import <Masonry.h>

typedef NS_ENUM(NSInteger,MTSubViewsType) {
    
    NoneViewType=0,
    ErrorViewType=1,
    ProgressViewType=2,
    WebViewType=3,
};

//define
#define EstimatedProgressKeyPath (@"estimatedProgress")

@interface GJWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,ErrorPromptViewDelegate>

@property(nonatomic,strong,nullable)WKWebView *webView;
@property(nonatomic,strong,nullable)UIProgressView *progressView;
@property(nonatomic,strong,nullable)ErrorPromptView *errorPromptView;

@end

@implementation GJWKWebViewController

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

-(void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:EstimatedProgressKeyPath];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initConfigNavigation];
}

#pragma mark - init configs
-(void)initConfigs{
    
    //init config views
    //usually we do views auto layout init configs in initConfigViews
    __weak typeof(self) weakSelf=self;
    [self.webView addObserver:weakSelf forKeyPath:EstimatedProgressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [self initConfigViews];
    
    [self initConfigDatas];
}

#pragma mark - init config views
-(void)initConfigViews{
    // invoke all views init config method
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initConfigNavigation];
    
    [self initConfigErrorPromptView];
    [self initConfigWebView];
    
    [self initConfigProgressView];
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName{}
-(void)initConfigNavigation{
    
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.translucent=NO;
}

-(void)initConfigErrorPromptView{
    
    __weak typeof(self) weakSelf=self;
    self.errorPromptView.hidden=YES;
    self.errorPromptView.delegate=self;
    self.errorPromptView.backgroundColor=[UIColor whiteColor];
    
    [self.errorPromptView initConfig];
    [self.errorPromptView config];
    
    [self.view addSubview:self.errorPromptView];
    
    [self.errorPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).offset(0);
        }
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.equalTo(weakSelf.mas_bottomLayoutGuideTop).offset(0);
        }
    }];
}

-(void)initConfigProgressView{
    
    self.progressView.trackTintColor=[UIColor clearColor];
    
    UIColor *cc=ColorFromRGB(82, 178, 239, 1);
    self.progressView.progressTintColor=cc;
    self.progressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
    self.progressView.layer.cornerRadius=2.5;
    self.progressView.clipsToBounds=YES;
    self.progressView.progress=0.0;
    
    [self.view addSubview:self.progressView];
    
    __weak typeof(self) weakSelf=self;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop).offset(-3);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).offset(-3);
        }
        
        make.height.mas_equalTo(10);
    }];
}

-(void)initConfigWebView{
    
    self.webView.backgroundColor=[UIColor whiteColor];
    self.webView.navigationDelegate=self;
    self.webView.UIDelegate=self;
    
    [self.view addSubview:self.webView];
    
    __weak typeof(self) weakSelf=self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(weakSelf.mas_topLayoutGuideBottom).offset(0);
        }
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.equalTo(weakSelf.mas_bottomLayoutGuideTop).offset(0);
        }
    }];
}

#pragma mark -
-(WKWebViewConfiguration *)generateWebViewConfig{
    
    WKWebViewConfiguration *cfg=[[WKWebViewConfiguration alloc] init];
    
    return cfg;
}

#pragma mark - init config datas
-(void)initConfigDatas{
    
    //in this method,usually we do request data from internet.
    self.title=[NSString stringByTrimmingBothEndWhiteSpace:self.pageTitle];
    
    [self webViewLoadRequest];
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName+Data{}
-(nonnull NSURLRequest *)generateRequestWithURLString:(nonnull NSString *)urlString{
    
    NSURL *url=[NSURL URLWithString:[NSString stringByTrimmingBothEndWhiteSpace:urlString]];
    NSTimeInterval timeOut=15;
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    return request;
}

-(void)webViewLoadRequest{
    
    [self.webView loadRequest:[self generateRequestWithURLString:self.urlString]];
}

#pragma mark - configs
-(void)configs{
    
    //in this mehod,usually we do views config on basis of data or some status after initConfig views
}

#pragma mark -
// all sub config method at here.
//example: config+ViewClassName{}

#pragma mark - WKNavigationDelegate
//Reacting to Errors
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"didFailNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [self showSubViewlogic:ErrorViewType];
}

//Tracking Load Progress
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{

    NSLog(@"Tracking Load Progress");
}

#pragma mark - ErrorPromptViewDelegate
-(void)refreshAction:(id _Nullable)passedValue{
    
    [self showSubViewlogic:ProgressViewType];
    
    [self webViewLoadRequest];
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if([keyPath isEqualToString:EstimatedProgressKeyPath]){
        
        NSNumber *new=[change objectForKey:NSKeyValueChangeNewKey];
        if(new &&
           [new isKindOfClass:[NSNumber class]]){
            
            [self updateProgressValue:new.floatValue];
        }
    }
}

#pragma mark -
-(void)updateProgressValue:(CGFloat)progress{
    
//    UIColor *cc=self.progressView.progressTintColor;
//    if(progress<=1.0 && progress>0){
//        cc=[cc colorWithAlphaComponent:progress];
//    }
//
//    self.progressView.progressTintColor=cc;
    self.progressView.progress=progress;
    
    if(progress>=1.0){
        [self hiddenProgressView];
    }
}

#pragma mark -
-(void)showSubViewlogic:(MTSubViewsType)viewType{
    
    if(viewType==ProgressViewType){
        
        [self showWebView];
        [self hiddenErrorPromptView];
        [self showProgressView];
    }
    else if(viewType==WebViewType){
        
        [self showWebView];
        [self hiddenErrorPromptView];
        [self hiddenProgressView];
    }
    else if(viewType==ErrorViewType){
        
        [self showErrorPromptView];
        [self hiddenWebView];
        [self hiddenProgressView];
    }
}

-(void)showProgressView{
    
    __weak typeof(self) weakSelf=self;
    
    [weakSelf.view bringSubviewToFront:self.progressView];
    weakSelf.progressView.hidden=NO;
}

-(void)hiddenProgressView{
    
    __weak typeof(self) weakSelf=self;
    weakSelf.progressView.hidden=YES;
}

-(void)showErrorPromptView{
    
    __weak typeof(self) weakSelf=self;
    [weakSelf.view bringSubviewToFront:weakSelf.errorPromptView];
    weakSelf.errorPromptView.hidden=NO;
}

-(void)hiddenErrorPromptView{
    
    __weak typeof(self) weakSelf=self;
    weakSelf.errorPromptView.hidden=YES;
}

-(void)showWebView{
    
    __weak typeof(self) weakSelf=self;
    [weakSelf.view bringSubviewToFront:weakSelf.webView];
    weakSelf.webView.hidden=NO;
}

-(void)hiddenWebView{
    
    __weak typeof(self) weakSelf=self;
    weakSelf.webView.hidden=YES;
}

#pragma mark - property
-(ErrorPromptView *)errorPromptView{
    if(!_errorPromptView){
        _errorPromptView=[ErrorPromptView new];
    }
    
    return _errorPromptView;
}

-(UIProgressView *)progressView{
    if(!_progressView){
        _progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    }
    
    return _progressView;
}

-(WKWebView *)webView{
    if(!_webView){
        _webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) configuration:[self generateWebViewConfig]];
    }
    
    return _webView;
}

@end
