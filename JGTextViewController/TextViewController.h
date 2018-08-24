//
//  TextViewController.h
//  MoTou
//
//  Created by worktree on 21/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextViewControllerDelegate<NSObject>

@optional
//-(void)keyboardEventHandle:(BOOL)keyboardShow keyboardDeltaY:(CGFloat)deltaY;

-(void)textViewContent:(nullable NSString *)content;

@end

@interface TextViewController : UIViewController

#pragma mark - property
@property(nonatomic,weak,nullable)id<TextViewControllerDelegate> delegate;

@property(nonatomic,copy,nullable)NSString *editedContent;

@end
