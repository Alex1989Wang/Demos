//
//  PGRawTouchViewController.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGRawTouchViewController.h"
#import "PGShapesView.h"

@interface PGRawTouchViewController ()
@property (nonatomic, strong) NSMutableArray<PGShapesView *> *shapes;
@end

@implementation PGRawTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Actions
- (IBAction)addRandomShape:(UIBarButtonItem *)sender {
    PGShapesView *shape = [PGShapesView shapeView];
    CGPoint origin = [self randomOrigin];
    CGRect frame = (CGRect){origin.x, origin.y, kPGShapeWidthHeight, kPGShapeWidthHeight};
    shape.frame = frame;
    [self.view addSubview:shape];
    [self.shapes addObject:shape];
}

- (IBAction)reset:(UIBarButtonItem *)sender {
    [self.shapes enumerateObjectsUsingBlock:
     ^(PGShapesView * _Nonnull shape, NSUInteger idx, BOOL * _Nonnull stop) {
         [shape removeFromSuperview];
    }];
    [self.shapes removeAllObjects];
}

#pragma mark - Private
- (CGPoint)randomOrigin {
    CGFloat toolbarHeight = 44.f;
    NSInteger widthFlex = floor(self.view.bounds.size.width - kPGShapeWidthHeight);
    NSInteger heightFlex = floor(self.view.bounds.size.height - kPGShapeWidthHeight - toolbarHeight);
    CGFloat originX = arc4random_uniform(2000)%widthFlex;
    CGFloat originY = arc4random_uniform(2000)%heightFlex;
    return (CGPoint){originX, originY};
}

#pragma mark - Lazy Loading
- (NSMutableArray<PGShapesView *> *)shapes {
    if (!_shapes) {
        _shapes = [NSMutableArray array];
    }
    return _shapes;
}

@end
