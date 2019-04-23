//___FILEHEADER___

#import "___FILEBASENAME___.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark - view init
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
