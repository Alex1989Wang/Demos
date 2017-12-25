//
//  JWVCPBookDetailViewController.m
//  JWViewControllerPresentationTransitions
//
//  Created by JiangWang on 23/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWVCPBookDetailViewController.h"

@interface JWVCPBookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@end

@implementation JWVCPBookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bookImageView.image = [UIImage imageNamed:self.bookName];
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(didTapBookBackground)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - Actions
- (void)didTapBookBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
