//
//  ViewController.m
//  AutolayoutThreeButton
//
//  Created by JiangWang on 22/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constWithConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equalWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeLayout:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _constWithConstraint.constant = (sender.selected) ? 0 : 94.5;
    _equalWidthConstraint.active = (!sender.selected);
    _gapConstraint.constant = (sender.selected) ? 0 : 20;
}

@end
