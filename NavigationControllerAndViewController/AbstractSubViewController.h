//
//  AbstractSubViewController.h
//
//  Created by worktree on 20/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbstractSubViewControllerDelegate<NSObject>

@optional

@end;

@interface AbstractSubViewController : UIViewController

@property(nonatomic,strong)UITableView * _Nullable tableView;

@property(nonatomic,assign)id<AbstractSubViewControllerDelegate> delegate;

#pragma mark -
-(id _Nullable )generateCellFromNibFile:(nonnull NSString *)nibNamed;

-(void)initConfig;

-(void)removeNavigationBackItemDefaultTitle;

-(void)hiddenDefaultBackButton;

@end
