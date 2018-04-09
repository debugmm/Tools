//
//  AbstractSubViewController.h
//
//  Created by worktree on 20/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractSubViewController : UIViewController

@property(nonatomic,strong)UITableView * _Nullable tableView;

#pragma mark -
-(id _Nullable )generateCellFromNibFile:(nonnull NSString *)nibNamed;

@end
