//
//  JGTextInputPromptController.m
//
//  Created by worktree on 29/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "JGTextInputPromptController.h"

#import <Masonry.h>

#import "NSString+CateString.h"

@interface JGTextInputPromptController ()

@property(nonatomic,strong,nullable)UILabel *promptLabel;

@end

@implementation JGTextInputPromptController

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
    [self initConfigPromptLabel];
}

#pragma mark -
// all subviews init config method at here.
//example: initConfig+ViewClassName{}
-(void)initConfigPromptLabel{
    
    __weak typeof(self) weakSelf=self;
    self.promptLabel.numberOfLines=1;
    self.promptLabel.font=[UIFont systemFontOfSize:14];
    self.promptLabel.textColor=[UIColor lightGrayColor];
    self.promptLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:self.promptLabel];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
    }];
}

#pragma mark - configs
-(void)configs{
    
    //in this mehod,usually we do views config on basis of data or some status after initConfig views
    if([NSString isEmptyString:self.promptContent]){
        self.promptLabel.text=@"不支持输入表情";
    }
    else{
        self.promptLabel.text=self.promptContent;
    }
}

#pragma mark -
// all sub config method at here.
//example: config+ViewClassName{}

#pragma mark - init config datas
-(void)initConfigDatas{
    
    //in this method,usually we do request data from internet.
}

#pragma mark -

#pragma mark - property
-(UILabel *)promptLabel{
    if(!_promptLabel){
        _promptLabel=[UILabel new];
    }
    
    return _promptLabel;
}

@end
