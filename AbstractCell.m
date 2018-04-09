//
//  AbstractCell.m
//
//  Created by worktree on 20/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "AbstractCell.h"

@implementation AbstractCell

-(void)setFrame:(CGRect)frame{
    
    frame.size.width=MainScreenWidth;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
