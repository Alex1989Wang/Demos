//
//  IndividualsTable.m
//  settingsTest
//
//  Created by JiangWang on 7/22/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "IndividualsTable.h"
#import "IndividualSettings.h"

@interface IndividualsTable ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation IndividualsTable

static NSString *const cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"individual table";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"UserID: %@", self.data[indexPath.row]];
    
    return cell;
}

#pragma mark - table view delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IndividualSettings *individualSettingsVC = [[IndividualSettings alloc] init];
    individualSettingsVC.userID = self.data[indexPath.row];
    individualSettingsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:individualSettingsVC animated:YES];
}

#pragma mark - lazy loading
- (NSArray *)data {
    if (_data == nil) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSUInteger index = 0; index < 40; index++) {
            [tempArray addObject:[NSString stringWithFormat:@"1234%ld", index]];
        }
        _data = [tempArray copy];
    }
    return _data;
}

@end
