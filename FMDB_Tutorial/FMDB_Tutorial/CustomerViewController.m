//
//  CustomerViewController.m
//  FMDB_Tutorial
//
//  Created by JiangWang on 05/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "CustomerViewController.h"
#import "CutomersManager.h"
#import "Customer.h"

@interface CustomerViewController ()

@property (nonatomic, strong) NSMutableArray<Customer *> *customers;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Customer *firstCus = [[Customer alloc] init];
    firstCus.firstName = @"Jiang";
    firstCus.lastName = @"Wang";
    
    [CutomersManager insertACustomer:firstCus];
    
    self.customers = [[CutomersManager getCutomers] mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *customerCellID = @"customersCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customerCellID];
    }
    
    Customer *cellCus = self.customers[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", cellCus.firstName, cellCus.lastName];
    
    return cell;
}

@end
