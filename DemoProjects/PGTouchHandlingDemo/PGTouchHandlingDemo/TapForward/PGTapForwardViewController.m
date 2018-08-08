//
//  PGTapForwardViewController.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/8.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGTapForwardViewController.h"
#import "PGTapView.h"

@interface PGTapForwardViewController ()
@property (strong, nonatomic) PGTapView *tapView;
@end

@implementation PGTapForwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapView = [[PGTapView alloc] initWithFrame:(CGRect){100, 100, 200, 200}];
    self.tapView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tapView];
    
    NSLog(@"tap gestures in tap view: %@", [self tapGesturesInView:self.tapView]);
    
    [self registerTaps:[self tapGesturesInView:self.tapView]];
}

- (NSArray<UITapGestureRecognizer *> *)tapGesturesInView:(UIView *)view {
    NSMutableArray<UITapGestureRecognizer *> *taps = [NSMutableArray array];
    //无subviews
    if (!view.subviews.count) {
        [view.gestureRecognizers enumerateObjectsUsingBlock:
         ^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                 [taps addObject:obj];
             }
        }];
        return taps;
    }
   
    //有subview
    [view.subviews enumerateObjectsUsingBlock:
     ^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
         [taps addObjectsFromArray:[self tapGesturesInView:subView]];
    }];
    //自己
    [view.gestureRecognizers enumerateObjectsUsingBlock:
     ^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
             [taps addObject:obj];
         }
     }];
    return taps;
}

- (void)registerTaps:(NSArray<UITapGestureRecognizer *> *)taps {
    [taps enumerateObjectsUsingBlock:
     ^(UITapGestureRecognizer * _Nonnull tapGest, NSUInteger idx, BOOL * _Nonnull stop) {
         [tapGest addTarget:self action:@selector(didTapTapView:)];
    }];
}

- (void)didTapTapView:(UITapGestureRecognizer *)tapGest {
    NSLog(@"view controller's did tap tap view called.");
}

@end
