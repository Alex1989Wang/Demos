//
//  XDChatViewController.m
//  ChatDemo
//
//  Created by JiangWang on 7/6/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "XDChatViewController.h"
#import "UIColor+Hex.h"

/* text insets */
#define kTextInsetTopAndBottom 8.f
#define kTextInsetLeftAndRight 10.f

/* kTextViewTopToWholeView & kTextViewBottomToWholeView */
#define kTextViewTopToWholeView self.textViewTopToWholeView.constant
#define kTextViewBottomToWholeView self.textViewBottomToWholeView.constant

/* whole view height in IB */
#define kWholeViewOriginalHeight 50.f

@interface XDChatViewController ()<UITextViewDelegate>

/* the whole view at the bottom - the textField's parent view */
@property (weak, nonatomic) IBOutlet UIView *wholeViewAtBottom;

/* text field used to input messages */
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

/* the bottom constraint of the whole view */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wholeViewBottomConstraint;

/* change this value to adjust the text view's height */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wholeViewHeight;

/* need their constants to calculate the should-be height of the whole view */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomToWholeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopToWholeView;

@end

@implementation XDChatViewController

#pragma mark - initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     become the notification observer of the input text field
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupNaviBar];
    
    [self setupTextView];
    
    
}

- (void)setupNaviBar {
    //title
    
    //right
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(moreMessagesSettings)];
}

- (void)setupTextView {
    [self.inputTextView setFont:[UIFont systemFontOfSize:14]];
    [self.inputTextView setTextContainerInset:UIEdgeInsetsMake(kTextInsetTopAndBottom, kTextInsetLeftAndRight, kTextInsetTopAndBottom, kTextInsetLeftAndRight)];
    [self.inputTextView setTextColor:[UIColor colorWithHexString:@"#2f3c46"]];
    
    //set the text view's delegate
    self.inputTextView.delegate = self;
}


#pragma mark - button actions;
- (void)moreMessagesSettings {
    
}

#pragma mark - notification related 
- (void)respondsToKeyboardFrameChange:(NSNotification *)notif {
    CGFloat keyboardEndFrameY = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat diff = screenHeight - keyboardEndFrameY;
    self.wholeViewBottomConstraint.constant = diff;
    
    [UIView animateWithDuration:[[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[[notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}


#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - delegate methods
//UITextFieldDelegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat textViewContentHeight = textView.contentSize.height;
    self.wholeViewHeight.constant = textViewContentHeight + kTextViewBottomToWholeView + kTextViewTopToWholeView + 1.0;
    
    NSLog(@"%f", textViewContentHeight);
    
    if (self.wholeViewHeight.constant <= kWholeViewOriginalHeight) {
        self.wholeViewHeight.constant = kWholeViewOriginalHeight;
    }
    
    [self.wholeViewAtBottom layoutIfNeeded];
    
    NSLog(@"%s", __func__);
}
@end
