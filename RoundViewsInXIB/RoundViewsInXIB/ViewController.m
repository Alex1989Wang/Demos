//
//  ViewController.m
//  RoundViewsInXIB
//
//  Created by JiangWang on 13/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@property (weak, nonatomic) TestView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestView *testView = [TestView testView];
    _testView = testView;
    testView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:testView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _testView.frame = CGRectMake(50, 50, 200, 150);
    
    NSLog(@"test view's frame: %@", NSStringFromCGRect(_testView.frame));
    NSLog(@"test view's image view's frme: %@", NSStringFromCGRect(_testView.testImageView.frame));
    
    _testImageView.layer.cornerRadius = _testImageView.frame.size.height * 0.5;
    _testImageView.layer.masksToBounds = YES;
}


@end
