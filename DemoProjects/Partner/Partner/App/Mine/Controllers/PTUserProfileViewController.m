//
//  PTUserProfileViewController.m
//  Partner
//
//  Created by JiangWang on 12/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTUserProfileViewController.h"

@interface PTUserProfileViewController ()
@property (nonatomic, weak) UIButton *debugLogBtn;
@property (nonatomic, weak) UIButton *warnLogBtn;
@property (nonatomic, weak) UIButton *errorLogBtn;
@property (nonatomic, weak) UIButton *nsLogBtn;
@end

@implementation PTUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self debugLogBtn];
    [self warnLogBtn];
    [self errorLogBtn];
    [self nsLogBtn];
}

#pragma mark - Private
- (void)didClickDebugLogButton:(UIButton *)debugLogBtn {
    DDLogDebug(@"this is a debug log.");
}

- (void)didClickWarnLogButton:(UIButton *)warnLogBtn {
    DDLogWarn(@"this is a warning log.");
}

- (void)didClickErrorLogButton:(UIButton *)errorLogBtn {
    DDLogError(@"this is a error log.");
}

- (void)didClickNSLogButton:(UIButton *)nsLogBtn {
    NSLog(@"original ns log.");
}

#pragma mark - Lazy Loading 
- (UIButton *)debugLogBtn {
    if (!_debugLogBtn) {
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _debugLogBtn = logBtn;
        logBtn.frame = (CGRect){100, 100, 80, 40};
        [self.view addSubview:logBtn];
        
        [logBtn setTitle:@"Debug Log" forState:UIControlStateNormal];
        [logBtn addTarget:self
                   action:@selector(didClickDebugLogButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _debugLogBtn;
}

- (UIButton *)warnLogBtn {
    if (!_warnLogBtn) {
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _warnLogBtn = logBtn;
        logBtn.frame = (CGRect){100, 200, 80, 40};
        [self.view addSubview:logBtn];
        
        [logBtn setTitle:@"Warn Log" forState:UIControlStateNormal];
        [logBtn addTarget:self
                   action:@selector(didClickWarnLogButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _warnLogBtn;
}

- (UIButton *)errorLogBtn {
    if (!_errorLogBtn) {
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _errorLogBtn = logBtn;
        logBtn.frame = (CGRect){100, 300, 80, 40};
        [self.view addSubview:logBtn];
        
        [logBtn setTitle:@"Error Log" forState:UIControlStateNormal];
        [logBtn addTarget:self
                   action:@selector(didClickErrorLogButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorLogBtn;
}

- (UIButton *)nsLogBtn {
    if (!_nsLogBtn) {
        UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nsLogBtn = logBtn;
        logBtn.frame = (CGRect){100, 400, 80, 40};
        [self.view addSubview:logBtn];
        
        [logBtn setTitle:@"NSlog Log" forState:UIControlStateNormal];
        [logBtn addTarget:self
                   action:@selector(didClickNSLogButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _nsLogBtn;
}

@end
