//
//  TestViewController.m
//  containerViewCon
//
//  Created by JiangWang on 9/18/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//
/* 
 
    The test view controller is used to simulate the input text field and 
    public chat table;
 
    The goal is to minize the exposure of public methods or properties as 
    much as possible; but, having a smoth transitition between two view controller's views;
 
 */

#import "TestViewController.h"
#import "UITextView+XDOverrideBaseLineMethods.h"

@interface TestViewController ()

@property (nonatomic, strong, readwrite) UITableView *chatTable;

@property (nonatomic, weak) UITextView *inputView;

@property (nonatomic, weak) UIView *chatTableOriginalSuperView;

@property (nonatomic, assign) CGRect chatTableOriginalRect;

@end

@implementation TestViewController

#pragma mark - 
#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureVC];
}

- (void)configureVC {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardFrameChange:(NSNotification *)noti {
    CGRect endKeyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat endInputViewY = endKeyboardRect.origin.y - 40; //40 is the height of the input view;
    
    CGRect inputNewFrame = _inputView.frame;
    inputNewFrame.origin.y = endInputViewY;
    
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _inputView.frame = inputNewFrame;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView resignFirstResponder];
    
    [_inputView removeFromSuperview];
    [self.view removeFromSuperview];
    
    [_chatTableOriginalSuperView addSubview:_chatTable];
    [UIView animateWithDuration:0.5 animations:^{
        _chatTable.frame = _chatTableOriginalRect;
    }];
}

#pragma mark - 
#pragma mark - Public Methods
- (void)beginChating {
    [self.inputView becomeFirstResponder];
    
    /**
     *  keep track of the table frame and it's superview
     */
    _chatTableOriginalSuperView = _chatTable.superview;
    _chatTableOriginalRect = _chatTable.frame;
    
    [self.view addSubview:_chatTable];
    CGRect chatTableNewFrame = _chatTable.frame;
    chatTableNewFrame.origin.y = _inputView.frame.origin.y - _chatTable.frame.size.height - 25.f;
    
    [UIView animateWithDuration:0.5 animations:^{
        _chatTable.frame = chatTableNewFrame;
    }];
}

#pragma mark - 
#pragma mark - Lazy Loading
- (UITableView *)chatTable {
    if (nil == _chatTable) {
        _chatTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) style:UITableViewStylePlain];
        _chatTable.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }
    return _chatTable;
}


- (UITextView *)inputView {
    if (nil == _inputView) {
        UITextView *inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40)];
        inputView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [self.view addSubview:inputView];
        _inputView = inputView;
    }    
    return _inputView;
}

@end
