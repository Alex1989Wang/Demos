//
//  JWWaveEffectTestViewController.m
//  JWLayerTest
//
//  Created by JiangWang on 18/03/2018.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "JWWaveEffectTestViewController.h"
#import "JWWaveTableCell.h"

static JWWaveViewType type = JWWaveViewTypeTimer;
static NSString *const kWaveTableCellReuseID = @"jiangwang.com.waveTableCellReuseID";

@interface JWWaveEffectTestViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *waveTables;
@end

@implementation JWWaveEffectTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    //flip the type value every time.
    type = (type == JWWaveViewTypeTimer) ? JWWaveViewTypeReplicator :
    JWWaveViewTypeTimer;
    self.title = (type == JWWaveViewTypeTimer) ? @"Wave Built by Timer" :
    @"Wave by Replicator Layer";
    
    //prepare table
    self.waveTables.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.waveTables];
    [self.waveTables.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.waveTables.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.waveTables.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.waveTables.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JWWaveTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kWaveTableCellReuseID];
    cell.waveViewType = type;
    cell.textLabel.text =
    [NSString stringWithFormat:@"row %ld, section %ld",
     indexPath.row, indexPath.section];
    return cell;
}

#pragma mark - Lazy Loading 
- (UITableView *)waveTables {
    if (!_waveTables) {
        _waveTables = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStylePlain];
        [_waveTables registerClass:[JWWaveTableCell class]
            forCellReuseIdentifier:kWaveTableCellReuseID];
        _waveTables.estimatedRowHeight = 0.f;
        _waveTables.estimatedSectionFooterHeight = 0.f;
        _waveTables.estimatedSectionHeaderHeight = 0.f;
        _waveTables.rowHeight = kJWTableCellHeight;
        
        _waveTables.dataSource = self;
        _waveTables.delegate = self;
    }
    return _waveTables;
}

@end
