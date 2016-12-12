//
//  ViewController.m
//  UIDevice
//
//  Created by JiangWang on 04/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>

@interface ViewController ()

@property (nonatomic, strong) UITextView *deviceInfoTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect infoViewFrame = CGRectInset(self.view.bounds, 20, 100);
    self.deviceInfoTextView.frame = infoViewFrame;
    [self.view addSubview:self.deviceInfoTextView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //dispaly device info
    [self displayDeviceInfo];
}

- (void)displayDeviceInfo
{
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSString *deviceLocalizedModel = [[UIDevice currentDevice] localizedModel];
    NSString *deviceSysName = [[UIDevice currentDevice] systemName];
    NSString *deviceSysVersion = [[UIDevice currentDevice] systemVersion];
    
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    NSString *outputInfo =
    [NSString stringWithFormat:@"current device: %@ \n \
     device name: %@ \n \
     device model: %@ \n \
     device localized model name: %@ \n \
     device system name: %@ \n \
     device system version %@ \n \
     platform: %@",
     [UIDevice currentDevice],
     deviceName,
     deviceModel,
     deviceLocalizedModel,
     deviceSysName,
     deviceSysVersion,
     platform];
    
    self.deviceInfoTextView.text = outputInfo;
}

- (UITextView *)deviceInfoTextView
{
    if (nil == _deviceInfoTextView)
    {
        _deviceInfoTextView = [[UITextView alloc] init];
        _deviceInfoTextView.editable = NO;
        _deviceInfoTextView.font = [UIFont systemFontOfSize:17.f];
        _deviceInfoTextView.textColor = [UIColor purpleColor];
    }
    return _deviceInfoTextView;
}


@end
