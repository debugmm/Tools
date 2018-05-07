//
//  AbstractSubViewController.m
//
//  Created by worktree on 20/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "AbstractSubViewController.h"

//define
#define PlaceHoldH (2.0)

@interface AbstractSubViewController ()

@end

@implementation AbstractSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initConfigNavigation];
    [self initConfigTabbar];
}

#pragma mark -
-(void)initConfigNavigation{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)initConfigTabbar{
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)initConfig{
    
}

-(void)removeNavigationBackItemDefaultTitle{
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil]];
}

-(void)hiddenDefaultBackButton{
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.leftBarButtonItems=nil;
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - Public
-(id)generateCellFromNibFile:(nonnull NSString *)nibNamed{
    
    id cell =[[[NSBundle mainBundle] loadNibNamed:nibNamed owner:nil options:nil] firstObject];
    
    return cell;
}

#pragma mark - Property
-(UITableView *)tableView{
    
    if(!_tableView){
        
        CGFloat h=PlaceHoldH;
        CGFloat w=self.view.bounds.size.width;
        
        CGRect tR=CGRectMake(0, 0, w, h);
        
        _tableView=[[UITableView alloc] initWithFrame:tR style:UITableViewStylePlain];
        
        _tableView.backgroundColor=[UIColor whiteColor];
    }
    
    return _tableView;
}

@end
