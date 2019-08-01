//
//  OCViewController.m
//  EnumsInteroperability
//
//  Created by JiangWang on 2019/7/4.
//  Copyright © 2019 JiangWang. All rights reserved.
//

#import "OCViewController.h"
#import "OCEnums.h"

@interface OCViewController ()
@property (nonatomic, assign) OCEnumTest ocEnum;
@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ocEnum = OCEnumTestR1_1;
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
