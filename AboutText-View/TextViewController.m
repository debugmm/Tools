//
//  TextViewController.m
//
//  Created by worktree on 21/08/2018.
//  Copyright © 2018 wjg. All rights reserved.
//

#import "TextViewController.h"

#import "NSString+CateString.h"
#import "Micros.h"

//define
#define TextViewInitH (40)

@interface TextViewController ()<UITextViewDelegate>

@property(nonatomic,strong,nullable)UITextView *textView;

@property(nonatomic,assign)CGFloat maxH;

@end

@implementation TextViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configTextView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - configs
-(void)configs{
    
    [self configEditedContent];
}

#pragma mark -
-(void)configTextView{
    
    BOOL result=[self.textView becomeFirstResponder];
    NSLog(@"self.textView becomeFirstResponder:%d",result);
}

-(void)configEditedContent{
    
    if(![NSString isEmptyString:self.editedContent]){
        
        CGFloat minh=TextViewInitH;
        CGFloat maxh=MainScreenHeight/4.0;
        
        NSDictionary *d=@{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGSize textSize=[self.editedContent boundingRectWithSize:CGSizeMake(MainScreenWidth-40, maxh) options:NSStringDrawingUsesLineFragmentOrigin attributes:d context:nil].size;
        
        CGFloat contentH=textSize.height+10;
        CGFloat h=0;
        CGRect frame=self.textView.frame;
        
        if(contentH<minh){
            h=minh;
        }
        else if(contentH>maxh){
            h=maxh;
        }
        else{
            h=contentH;
        }
        
        CGFloat deltaY=0;
        deltaY=h-frame.size.height;
        frame.origin.y-=deltaY;
        
        frame.size.height=h;
        
        self.textView.frame=frame;
        
        self.textView.text=self.editedContent;
    }
}

#pragma mark - init configs
-(void)initConfigs{
    
    [self initConfigViews];
}

#pragma mark - init config views
-(void)initConfigViews{
    
    UIColor *clearColor=[UIColor clearColor];
    clearColor=[clearColor colorWithAlphaComponent:0.5];
    self.view.backgroundColor=clearColor;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self initConfigKeyboardHandle];
    [self initConfigTextView];
}

#pragma mark -
-(void)initConfigTextView{
    
    self.textView.delegate=self;
    self.textView.layer.borderWidth=2.0;
    self.textView.layer.cornerRadius=5;
    self.textView.backgroundColor=[UIColor whiteColor];//ColorFromHex(0xefefef);
    self.textView.layer.borderColor=ColorFromHex(0xe0e0e0).CGColor;
    self.textView.font=[UIFont systemFontOfSize:16];
    self.textView.textColor=ColorFromHex(0x999999);
    self.textView.returnKeyType=UIReturnKeyDone;
    
    CGFloat y=MainScreenHeight-StatusBarHeight-TextViewInitH;
    CGFloat x=20;
    CGFloat w=MainScreenWidth-40;
    CGFloat h=TextViewInitH;
    
    self.textView.frame=CGRectMake(x, y, w, h);
    
    [self.view addSubview:self.textView];
}

-(void)initConfigKeyboardHandle{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNoti:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardNoti:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - init config datas

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    CGFloat minh=TextViewInitH;
    CGFloat maxh=self.maxH-StatusBarHeight-30;
    
    CGFloat contentH=textView.contentSize.height+8;
    CGFloat h=0;
    CGRect frame=textView.frame;
    CGFloat deltaY=0;
    
    BOOL shouldChangeY=NO;
    
    if(contentH<minh){
        h=minh;
    }
    else if(contentH>maxh){
        h=maxh;
        shouldChangeY=YES;
    }
    else{
        h=contentH;
        shouldChangeY=YES;
    }
    
    deltaY=h-frame.size.height;
    frame.size.height=h;
    
    if(shouldChangeY){
        frame.origin.y-=deltaY;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        textView.frame=frame;
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"text:%@",text);
    
    BOOL containEmoji=[text isContainedEmoji];
    if(containEmoji){
        
        //show prompt
        text=[text removeAllEmoji];
        [self showTextInputEmojiPrompt];
        
        NSLog(@"remove all emoji:%@",text);
        
        return NO;
    }
    
    NSString *midText=[NSString isEmptyString:text] ? @"" : text;
    NSRange mrange=[midText rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
    if(mrange.location!=NSNotFound){
        [self dismissSelf];
    }
    
    return YES;
}

#pragma mark -
-(void)showTextInputEmojiPrompt{
    
    JGTextInputPromptController *svc=[[JGTextInputPromptController alloc] init];
    
    svc.view.backgroundColor=[UIColor whiteColor];
    svc.modalPresentationStyle=UIModalPresentationPopover;
    
    svc.preferredContentSize=CGSizeMake(120, 35);
    svc.popoverPresentationController.delegate=self;
    
    CGPoint cursorP=[self.textView getCursorPositionInView];
    if(cursorP.x<40){
        cursorP.x=40;
    }
    else if(self.textView.bounds.size.width-cursorP.x<40){
        cursorP.x-=40;
    }
    
    if(cursorP.y<8){
        cursorP.y-=7;
    }
    
    CGRect pointR=CGRectMake(cursorP.x, cursorP.y, 0.5, 0.5);
    svc.popoverPresentationController.sourceRect=pointR;
    svc.popoverPresentationController.sourceView=self.textView;
    svc.popoverPresentationController.permittedArrowDirections=UIPopoverArrowDirectionAny;
    svc.popoverPresentationController.backgroundColor=[UIColor whiteColor];
    
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - Keyboard Noti
-(void)handleKeyboardNoti:(NSNotification *)noti{
    
    if(![noti.name isEqualToString:UIKeyboardWillShowNotification] &&
       ![noti.name isEqualToString:UIKeyboardWillHideNotification]){
        return;
    }
    
    NSValue *beginValue=[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue=[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect beginRect=beginValue.CGRectValue;
    CGRect endRect=endValue.CGRectValue;
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    
//    BOOL show=NO;
//
//    if([noti.name isEqualToString:UIKeyboardWillShowNotification]){
//        //keyboard show
//        show=YES;
//    }
//    else if([noti.name isEqualToString:UIKeyboardWillHideNotification]){
//        //keyboard hidden
//    }
    
    CGRect frame=self.textView.frame;
    
    frame.origin.y+=deltaY;
    
    self.textView.frame=frame;
    
    self.maxH=frame.origin.y+frame.size.height;
}

#pragma mark - UIGestureRecognizerDelegate
-(void)handleTap:(UITapGestureRecognizer *)tap{
    
    [self dismissSelf];
}

#pragma mark -
-(void)dismissSelf{
    
    [self passValueToPresentingViewController];
    
    [self endEdit];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passValueToPresentingViewController{
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(textViewContent:)]){
        
        NSString *content=[NSString stringByTrimmingBothEndWhiteSpace:self.textView.text];
        [self.delegate textViewContent:content];
    }
}

-(void)endEdit{
    
    [self.textView endEditing:YES];
}

#pragma mark - property
-(UITextView *)textView{
    
    if(!_textView){
        _textView=[[UITextView alloc] init];
    }
    
    return _textView;
}

@end
