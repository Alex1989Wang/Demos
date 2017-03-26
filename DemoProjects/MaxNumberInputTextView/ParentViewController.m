//
//  ParentViewController.m
//  MaxNumberInputTextView
//
//  Created by JiangWang on 7/26/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ParentViewController.h"
#import "XDPublicChatController.h"
#import "XDInputLimitTextView.h"

/* screen constants */
#define kChatTableHeight 300.f
#define kTextViewHeight 49.f

@interface ParentViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UIView *publicChatTable;
@property (nonatomic, weak) XDInputLimitTextView *textView;

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register as an observer of the keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupPublicScreenTable];
    
    [self setupInputTextView];
}

#pragma mark - setup public chat screen table 
- (void)setupPublicScreenTable {
    XDPublicChatController *publicChatVC = [[XDPublicChatController alloc] initWithStyle:UITableViewStylePlain];
    
    [publicChatVC.view setFrame:CGRectMake(0, kChatTableHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kTextViewHeight - kChatTableHeight)];
    [publicChatVC.view setBackgroundColor:[UIColor brownColor]];
    self.publicChatTable = publicChatVC.view;
    
    [self.view addSubview:publicChatVC.view];
}

- (void)setupInputTextView {
    XDInputLimitTextView *inputTextView = [[XDInputLimitTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.publicChatTable.frame), [UIScreen mainScreen].bounds.size.width, kTextViewHeight)];
    [inputTextView setBackgroundColor:[UIColor grayColor]];
    
    //configure the input text view
    inputTextView.maxNumOfCharacters = 6;
    
    self.textView = inputTextView;
    
    [self.view addSubview:inputTextView];
}


#pragma mark - UITextViewDelegate

#pragma mark - keyboard frame change
- (void)handleKeyboardFrameChange:(NSNotification *)noti {
    //get the frame Y diff
    CGFloat endFrameY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    //change the textview's frame
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.origin.y = endFrameY - kTextViewHeight;
    self.textView.frame = textViewFrame;
}

#pragma mark - end editing
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView endEditing:YES];
}


@end
