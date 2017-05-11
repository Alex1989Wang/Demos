//
//  ViewController.m
//  EventHandlingTest
//
//  Created by JiangWang on 11/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *guestureTestView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self guestureTestView];
    [self gestureTest];
}

- (void)gestureTest {
    UITapGestureRecognizer *tapGest =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didTapView:)];
    [self.guestureTestView addGestureRecognizer:tapGest];
    
    //long press
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didLongPressView:)];
    [self.guestureTestView addGestureRecognizer:longPress];
}

- (void)didTapView:(UITapGestureRecognizer *)tapGuesture {
    NSLog(@"tap guesture state: %lu", tapGuesture.state);
    NSLog(@"tap guesture view: %@", tapGuesture.view);
}

- (void)didLongPressView:(UILongPressGestureRecognizer *)longPress {
    NSLog(@"long press guesture state: %lu", longPress.state);
    NSLog(@"long press guesture view: %@", longPress.view);
}


- (UIView *)guestureTestView {
    if (nil == _guestureTestView) {
        UIView *guestureTestView = [[UIView alloc] init];
        _guestureTestView = guestureTestView;
        [self.view addSubview:guestureTestView];
        
        guestureTestView.backgroundColor = [UIColor brownColor];
        guestureTestView.frame = (CGRect){100, 200, 200, 200};
    }
    return _guestureTestView;
}
@end
