//___FILEHEADER___

#import "___FILEBASENAME___.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark - viewController init

#pragma mark - viewController lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - config init
-(void)configInit{
    //init config views
    //usually we do views auto layout init configs in initConfigViews
    [self viewsInit]; 
    [self dataInit];
}

#pragma mark - views init
-(void)viewsInit{
    // invoke all views init config method
}

#pragma mark - datas init
-(void)dataInit{
    
    //in this method,usually we do request data from internet.
}

#pragma mark - property

@end
