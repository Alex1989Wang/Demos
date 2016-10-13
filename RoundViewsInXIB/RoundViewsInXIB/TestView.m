//
//  TestView.m
//  RoundViewsInXIB
//
//  Created by JiangWang on 13/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TestView.h"

@interface TestView()

@property (weak, nonatomic) IBOutlet UIImageView *testImageView;


@end

@implementation TestView

+ (instancetype)testView {
    return [[[NSBundle mainBundle] loadNibNamed:@"TestView" owner:nil options:nil] lastObject];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _testImageView.layer.cornerRadius = _testImageView.bounds.size.height * 0.5;
    _testImageView.layer.masksToBounds = YES;
}

@end
