//
//  PopoverTestController.m
//  ViewControllerProgrammingGuideDemo
//
//  Created by JiangWang on 25/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "PopoverTestController.h"
#import "TestTwoViewController.h"
#import <Masonry.h>

@interface PopoverTestController ()

@property (nonatomic, weak) UIButton *popoverButton;
@end

@implementation PopoverTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *middleBtn = [[UIButton alloc] init];
    [middleBtn setTitle:@"pop over" forState:UIControlStateNormal];
    [middleBtn addTarget:self
                  action:@selector(clickToSeePopOver:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];
    self.popoverButton = middleBtn;
    
    [middleBtn mas_makeConstraints:
     ^(MASConstraintMaker *make)
     {
         make.center.equalTo(self.view);
     }];
}

- (void)clickToSeePopOver:(UIButton *)button
{
    TestTwoViewController *orangePopOver = [[TestTwoViewController alloc] init];
    orangePopOver.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:orangePopOver
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController *presController =
    [orangePopOver popoverPresentationController];
    presController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    UIView *sourceView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    presController.sourceView = sourceView;
    presController.sourceRect = CGRectMake(100, 100, 100, 100);
//    presController.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.popoverButton];
}

@end
