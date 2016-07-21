//
//  ViewController.m
//  LoadAndInitialize
//
//  Created by JiangWang on 7/21/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "GlobalSettings.h"
#import "Constants.h"

@interface ViewController ()

@property (nonatomic, weak) UISwitch *addedSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UISwitch *testSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 200, 40, 25)];
    [self.view addSubview:testSwitch];
    
    self.addedSwitch = testSwitch;
    
    self.addedSwitch.on = [GlobalSettings fetchGlobalSettingWithKey:globalSettingTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    BOOL boolValue = [GlobalSettings fetchGlobalSettingWithKey:globalSettingTest];
    
    self.addedSwitch.on = boolValue;
    
}

@end
