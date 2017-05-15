//
//  ViewController.m
//  EventHandlingTest
//
//  Created by JiangWang on 11/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "MultiTouchDemoView.h"
#import "CheckGuestureRecognizer.h"

@interface ViewController ()
@property (nonatomic, weak) UIView *guestureTestView;
@property (nonatomic, weak) MultiTouchDemoView *multiTouchDemoView;
@property (nonatomic, weak) UIView *checkGuestTestView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self guestureTestView];
//    [self gestureTest];
//    [self multiTouchDemoView];
    [self checkGuestTestView];
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

- (void)didCheckView:(CheckGuestureRecognizer *)checkGues {
    switch (checkGues.state) {
        case UIGestureRecognizerStateFailed: {
            NSLog(@"Check guesture failed.");
            break;
        }
        case UIGestureRecognizerStateRecognized: {
            NSLog(@"Check guesture recognized.");
            break;
        }
        case UIGestureRecognizerStatePossible: {
            NSLog(@"Check guesture possible.");
        }
        default:
            NSAssert(NO, @"discret guesture recognizer.");
            break;
    }
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

- (MultiTouchDemoView *)multiTouchDemoView {
    if (nil == _multiTouchDemoView) {
        MultiTouchDemoView *view = [[MultiTouchDemoView alloc] init];
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    }
    return _multiTouchDemoView;
}

- (UIView *)checkGuestTestView {
    if (nil == _checkGuestTestView) {
        UIView *checkGuesTestView = [[UIView alloc] init];
        _checkGuestTestView = checkGuesTestView;
        [self.view addSubview:checkGuesTestView];
        
        checkGuesTestView.frame = CGRectMake(50, 100, 250, 250);
        checkGuesTestView.backgroundColor = [UIColor lightGrayColor];
        
        CheckGuestureRecognizer *checkGues =
        [[CheckGuestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(didCheckView:)];
        [checkGuesTestView addGestureRecognizer:checkGues];
    }
    return _checkGuestTestView;
}
@end
