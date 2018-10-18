//
//  ErrorPromptView.m
//
//  Created by worktree on 16/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "ErrorPromptView.h"

#import "MTAppConst.h"

#import "NSString+CateString.h"

#import <Masonry.h>

//define
#define PromptImageViewH (80)
#define PromptImageViewW (80)

#define RefreshBtnH (44)
#define RefreshBtnW (80)

@interface ErrorPromptView()

@property(nonatomic,strong,nullable)UIImageView *promptImageView;
@property(nonatomic,strong,nullable)UILabel *promptLabel;
@property(nonatomic,strong,nullable)UIButton *refreshBtn;

@end

@implementation ErrorPromptView

#pragma mark - config
-(void)config{
    
    [self configPromptLabel];
}

#pragma mark -
-(void)configPromptLabel{
    
    NSString *textcc=@"噢，网络开小差啦！";
    if(![NSString isEmptyString:self.promptText]){
        textcc=self.promptText;
    }
    
    self.promptLabel.text=textcc;
}

#pragma mark - init config
-(void)initConfig{
    
    [self initConfigViews];
}

#pragma mark - init config views
-(void)initConfigViews{
    
    self.backgroundColor=[UIColor whiteColor];
    
    [self initConfigPromptLabel];
    [self initConfigPromptImageView];
    [self initConfigRefreshBtn];
}

#pragma mark -
-(void)initConfigPromptLabel{
    
    __weak typeof(self) weakSelf=self;
    
    self.promptLabel.font=[UIFont systemFontOfSize:17];
    self.promptLabel.textColor=ColorFromHex(0x666666);
    self.promptLabel.numberOfLines=1;
    self.promptLabel.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:self.promptLabel];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.mas_leading).offset(0);
        make.trailing.equalTo(weakSelf.mas_trailing).offset(0);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
    }];
}

-(void)initConfigPromptImageView{
    
    __weak typeof(self) weakSelf=self;
    self.promptImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [self addSubview:self.promptImageView];
    
    [self.promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(PromptImageViewH);
        make.width.mas_equalTo(PromptImageViewW);
        
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        make.bottom.equalTo(weakSelf.promptLabel.mas_top).offset(10);
    }];
}

-(void)initConfigRefreshBtn{
    
    __weak typeof(self) weakSelf=self;
    
    self.refreshBtn.layer.borderColor=ColorFromHex(0x666666).CGColor;
    self.refreshBtn.layer.borderWidth=1.0;
    self.refreshBtn.layer.cornerRadius=RefreshBtnH/2.0;
    
    [self.refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [self.refreshBtn setTitleColor:ColorFromHex(0x666666) forState:UIControlStateNormal];
    self.refreshBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.refreshBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.refreshBtn addTarget:self action:@selector(refreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.refreshBtn];
    
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(RefreshBtnW);
        make.height.mas_equalTo(RefreshBtnH);
        
        make.top.equalTo(weakSelf.promptLabel.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
    }];
}

#pragma mark - btn action
-(void)refreshBtnAction:(UIButton *)sender{
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(refreshAction:)]){
        
        [self.delegate refreshAction:nil];
    }
}

#pragma mark - init config datas

#pragma mark - property
-(UIButton *)refreshBtn{
    if(!_refreshBtn){
        _refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    return _refreshBtn;
}

-(UILabel *)promptLabel{
    if(!_promptLabel){
        _promptLabel=[UILabel new];
    }
    
    return _promptLabel;
}

-(UIImageView *)promptImageView{
    if(!_promptImageView){
        _promptImageView=[UIImageView new];
    }
    
    return _promptImageView;
}

@end
