//
//  AbstractCell.h
//
//  Created by worktree on 20/03/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbstractCellDelegate<NSObject>

@optional

@end

@interface AbstractCell : UITableViewCell

@property (assign,nonatomic) id<AbstractCellDelegate> delegate;

@end
