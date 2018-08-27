//
//  PGCollectionViewTapCell.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/20.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGCollectionViewTapCell.h"

@implementation PGCollectionViewTapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    //tap gesture
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
    tapGest.numberOfTouchesRequired = 1;
    tapGest.numberOfTapsRequired = 1;
    [self.contentView addGestureRecognizer:tapGest];
}

- (IBAction)didTapCellButton:(UIButton *)sender {
    NSLog(@"tapped cell button.");
}

- (void)didTapContentView:(UITapGestureRecognizer *)tapGest {
    NSLog(@"tap gesture called.");
}
@end
