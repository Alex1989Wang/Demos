//
//  JWNTViewController.m
//  JWNavigationTransitionDemo
//
//  Created by JiangWang on 30/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNTViewController.h"
#import "JWNTSecondViewController.h"
#import "JWNTNavigationDelegate.h"

@interface JWNTViewController ()
@property (nonatomic, strong) JWNTNavigationDelegate *localNaviDelegate;
@end

@implementation JWNTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First View Controller";
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)clickToPush:(UIButton *)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *secondVCId = NSStringFromClass([JWNTSecondViewController class]);
    JWNTSecondViewController *secondVC =
    [mainStoryBoard instantiateViewControllerWithIdentifier:secondVCId];
    if (secondVC) {
        self.navigationController.delegate = self.localNaviDelegate;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
}

#pragma mark - Lazy Loading 
- (JWNTNavigationDelegate *)localNaviDelegate {
    if (!_localNaviDelegate) {
        _localNaviDelegate = [[JWNTNavigationDelegate alloc] init];
    }
    return _localNaviDelegate;
}

@end
