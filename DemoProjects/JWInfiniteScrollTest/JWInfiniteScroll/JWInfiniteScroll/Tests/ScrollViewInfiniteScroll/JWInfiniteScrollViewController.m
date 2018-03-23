//
//  JWInfiniteScrollViewController.m
//  JWInfiniteScroll
//
//  Created by JiangWang on 23/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWInfiniteScrollViewController.h"
#import "JWInfiniteScrollView.h"

@interface JWInfiniteScrollViewController ()
@property (nonatomic, strong) JWInfiniteScrollView *infiniteScrollView;
@end

@implementation JWInfiniteScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 250.f;
    CGFloat height = 50.f;
    CGSize viewSize = self.view.bounds.size;
    self.infiniteScrollView.frame = (CGRect){0.5*(viewSize.width - width),
        0.5*(viewSize.height - height), width, height};
    [self.view addSubview:self.infiniteScrollView];
}

#pragma mark - Lazy Loading
- (JWInfiniteScrollView *)infiniteScrollView {
    if (!_infiniteScrollView) {
        _infiniteScrollView = [[JWInfiniteScrollView alloc] init];
        _infiniteScrollView.layer.borderColor = [UIColor redColor].CGColor;
        _infiniteScrollView.layer.borderWidth = 1.f;
    }
    return _infiniteScrollView;
}
@end
