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
