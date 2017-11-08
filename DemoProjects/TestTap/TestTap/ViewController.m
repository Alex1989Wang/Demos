//
//  ViewController.m
//  TestTap
//
//  Created by JiangWang on 31/08/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"

static NSString *const kTreasureBoxListCellID = @"kTreasureBoxListCellID";

@interface ViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *treasureBoxesTable;
@property (nonatomic, strong) NSMutableArray *treasureBoxes;
@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGest =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didTapView:)];
    tapGest.delegate = self;
    [self.view addGestureRecognizer:tapGest];
    [self setupViewHierachy];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.treasureBoxesTable]) {
        return NO;
    }
    return YES;
}

- (void)didTapView:(UIGestureRecognizer *)tapGest {
    NSLog(@"tap method called.");
}

- (void)setupViewHierachy {
    [self treasureBoxesTable];
}

- (void)dealloc {
    NSLog(@"tresure box list controller deallocated.");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.treasureBoxes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0 && indexPath.row < self.treasureBoxes.count) {
        NSString *item = self.treasureBoxes[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTreasureBoxListCellID];
        cell.textLabel.text = item;
        return cell;
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.treasureBoxes.count && indexPath.row >= 0) {
        return 54.f;
    }
    return 0;
}

#pragma mark - Delegate UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0 && indexPath.row < self.treasureBoxes.count) {
        NSLog(@"did tap cell.");
    }
}

#pragma mark - Lazy Loading
- (UITableView *)treasureBoxesTable {
    if (nil == _treasureBoxesTable) {
        UITableView *tableView =
        [[UITableView alloc] initWithFrame:self.view.bounds
                                     style:UITableViewStylePlain];
        _treasureBoxesTable = tableView;
        [self.view addSubview:tableView];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.contentInset = UIEdgeInsetsZero;
        [tableView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:kTreasureBoxListCellID];
    }
    return _treasureBoxesTable;
}

- (NSMutableArray *)treasureBoxes {
    if (nil == _treasureBoxes) {
        _treasureBoxes = [NSMutableArray array];
        for (NSInteger index = 0; index <= 100; index++) {
            NSString *itemNumber = [NSString stringWithFormat:@"%ld", index];
            [_treasureBoxes addObject:itemNumber];
        }
    }
    return _treasureBoxes;
}

@end
