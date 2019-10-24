//
//  ZTSortDescriptorTestViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2019/10/15.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import "ZTSortDescriptorTestViewController.h"
#import "ZTSorter.h"

@interface ZTSortDescriptorTestViewController ()

@end

@implementation ZTSortDescriptorTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sort {
    [[ZTSorter shared] simulateSorting];
    [[ZTSorter shared] simulateObjectDateChange];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
