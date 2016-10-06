//
//  BSVMainViewController.m
//  BuildScorllView
//
//  Created by JiangWang on 06/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "BSVMainViewController.h"
#import "BSVCustomScrollViewController.h"

@interface BSVMainViewController ()

/* the main view - acts as a scroll view */
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation BSVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Custome" style:UIBarButtonItemStylePlain target:self action:@selector(pushOutCustomScrollView)];
}

- (void)setupSubviews {
    //configure main view
    self.mainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.mainView.clipsToBounds = YES;
    
    //subviews
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    redView.backgroundColor = [UIColor colorWithRed:0.85 green:0.007 blue:0.1 alpha:1.0];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(150, 160, 150, 200)];
    greenView.backgroundColor = [UIColor colorWithRed:0.07 green:0.85 blue:0.1 alpha:1.0];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(40, 400, 200, 150)];
    yellowView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.1 alpha:1.0];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(100, 600, 180, 150)];
    blueView.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1.0];
    
    [self.mainView addSubview:redView];
    [self.mainView addSubview:greenView];
    [self.mainView addSubview:yellowView];
    [self.mainView addSubview:blueView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect bounds = self.mainView.bounds;
    
    NSLog(@"bounds before change: %@", NSStringFromCGRect(bounds));
    bounds.origin.y += 10;
    self.mainView.bounds = bounds;
    
    NSLog(@"bounds after change: %@", NSStringFromCGRect(self.mainView.bounds));
}


- (void)pushOutCustomScrollView {
    BSVCustomScrollViewController *customScrollController = [[BSVCustomScrollViewController alloc] init];
    [self.navigationController pushViewController:customScrollController animated:YES];
}

@end
