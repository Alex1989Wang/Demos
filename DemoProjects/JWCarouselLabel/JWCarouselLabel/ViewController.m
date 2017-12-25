//
//  ViewController.m
//  JWCarouselLabel
//
//  Created by JiangWang on 01/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "JWCarouselLabel.h"

@interface ViewController ()
@property (nonatomic, weak) JWCarouselLabel *carouselLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self carouselLabel];
}

#pragma mark - Lazy Loading
- (JWCarouselLabel *)carouselLabel {
    if (!_carouselLabel) {
        JWCarouselLabel *carouselLabel = [[JWCarouselLabel alloc] init];
        carouselLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        carouselLabel.textColor = [UIColor blackColor];
        carouselLabel.numberOfLines = 1;
        carouselLabel.font = [UIFont systemFontOfSize:15];
        carouselLabel.text = @"carousel label should go round and round, please do.";
        carouselLabel.frame = (CGRect){100, 100, 200, 20};
        _carouselLabel = carouselLabel;
        [self.view addSubview:carouselLabel];
    }
    return _carouselLabel;
}

@end
