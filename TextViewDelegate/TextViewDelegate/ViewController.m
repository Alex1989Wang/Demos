//
//  ViewController.m
//  TextViewDelegate
//
//  Created by JiangWang on 16/7/20.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

// should change characters in range won't be called when you are using the 

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addATextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addATextView {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [textView setBackgroundColor:[UIColor grayColor]];
    
    textView.delegate = self;
    
    [self.view addSubview:textView];
}

#pragma mark - UITextView delegate 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"text view text: %@, replacement text: %@, in range:%@", textView.text, text, NSStringFromRange(range));
    
    return YES;
}

@end
