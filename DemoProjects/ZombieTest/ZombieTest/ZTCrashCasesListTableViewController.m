//
//  CrashCasesListTableViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/11/5.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZTCrashCasesListTableViewController.h"
#import "ZTCrashAssignPropertyViewController.h"
#import "ZTCrashNonatomicViewController.h"
#import "ZTCallBackReleaseViewController.h"
#import "ZTCrashMutableArrayViewController.h"
#import "ZTSortDescriptorTestViewController.h"


typedef NS_ENUM(NSUInteger, ZTCrashType) {
    ZTCrashTypeAssignDanglingPointer = 0,
    ZTCrashTypeNonatomicMultithread,
    ZTCrashTypeBlockMissUse,
    ZTCrashTypeMutableArray,
    ZTCrashTypeSortDescriptor,
};

NSString *const kCrashListTableCellID = @"ZTCrashListTableCellID";

@interface ZTCrashCasesListTableViewController ()
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *crashes;
@end

@implementation ZTCrashCasesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //cell registeration
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCrashListTableCellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crashes.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrashListTableCellID forIndexPath:indexPath];
    NSString *title = self.crashes[@(indexPath.row)];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTCrashType type = indexPath.row;
    NSString *title = self.crashes[@(type)];
    switch (type) {
        case ZTCrashTypeAssignDanglingPointer: {
            ZTCrashAssignPropertyViewController *assignCaseVC =
            [[ZTCrashAssignPropertyViewController alloc] initWithNibName:@"ZTCrashAssignPropertyViewController" bundle:nil];
            assignCaseVC.title = title;
            [self.navigationController pushViewController:assignCaseVC animated:YES];
            break;
        }
            
        case ZTCrashTypeNonatomicMultithread: {
            ZTCrashNonatomicViewController *nonatomicVC =
            [[ZTCrashNonatomicViewController alloc] initWithNibName:@"ZTCrashNonatomicViewController" bundle:nil];
            nonatomicVC.title = title;
            [self.navigationController pushViewController:nonatomicVC animated:YES];
            break;
        }
            
        case ZTCrashTypeBlockMissUse: {
            ZTCallBackReleaseViewController *testVC = [[ZTCallBackReleaseViewController alloc] init];
            testVC.title = title;
            [self.navigationController pushViewController:testVC animated:YES];
            break;
        }
            
        case ZTCrashTypeMutableArray: {
            ZTCrashMutableArrayViewController *testVC = [[ZTCrashMutableArrayViewController alloc] init];
            testVC.title = title;
            [self.navigationController pushViewController:testVC animated:YES];
            break;
        }
        case ZTCrashTypeSortDescriptor: {
            ZTSortDescriptorTestViewController *testVC = [[ZTSortDescriptorTestViewController alloc] init];
            testVC.title = title;
            [self.navigationController pushViewController:testVC animated:YES];
            break;
        }
            
        default:
            NSAssert(NO, @"invalid type");
            break;
    }
}

- (NSDictionary<NSNumber *,NSString *> *)crashes {
    if (!_crashes) {
        _crashes = @{@(ZTCrashTypeAssignDanglingPointer): @"Assign Property",
                     @(ZTCrashTypeNonatomicMultithread): @"Nonatomic Multithreading Issue",
                     @(ZTCrashTypeBlockMissUse): @"Block Missuse",
                     @(ZTCrashTypeMutableArray): @"Mutable Array",
                     @(ZTCrashTypeSortDescriptor): @"Sort Descriptor"
                     };
    }
    return _crashes;
}

@end
