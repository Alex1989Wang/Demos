//
//  ViewController.m
//  RegisterNotificationMultipleTimes
//
//  Created by JiangWang on 8/1/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "NotiTestViewController.h"


@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

- (IBAction)sendNoti {
    
    
    NotiTestViewController *notiVC = [[NotiTestViewController alloc] init];
    [self.navigationController pushViewController:notiVC animated:YES];
}
@end
