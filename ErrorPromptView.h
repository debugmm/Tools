//
//  ErrorPromptView.h
//
//  Created by worktree on 16/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ErrorPromptViewDelegate<NSObject>

@optional
-(void)refreshAction:(id _Nullable)passedValue;

@end

@interface ErrorPromptView : UIView

#pragma mark - property
//prompt image view's image
@property(nonatomic,strong,nullable)UIImage *promptImage;
@property(nonatomic,copy,nullable)NSString *promptImageName;

//prompt label text content
@property(nonatomic,copy,nullable)NSString *promptText;

//refresh button appearance's content
@property(nonatomic,copy,nullable)NSString *refreshBtnTitle;
@property(nonatomic,strong,nullable)UIImage *refreshBtnBgImage;
@property(nonatomic,copy,nullable)NSString *refreshBtnBgImageName;

//delegate
@property(nonatomic,weak,nullable)id<ErrorPromptViewDelegate> delegate;

#pragma mark - methods
//build instance,set prompts
//then invoke initConfig
//and then invoke config

#pragma mark - init config
-(void)initConfig;

#pragma mark - config
-(void)config;

@end
