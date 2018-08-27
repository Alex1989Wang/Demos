//
//  PGTapTestCollectionViewController.m
//  PGTouchHandlingDemo
//
//  Created by JiangWang on 2018/8/20.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "PGTapTestCollectionViewController.h"
#import "PGCollectionViewTapCell.h"

@interface PGTapTestCollectionViewController ()

@end

@implementation PGTapTestCollectionViewController

static NSString * const kPGTapTestCollectionCellReuseID = @"PGTapTestCollectionViewControllerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"PGCollectionViewTapCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kPGTapTestCollectionCellReuseID];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPGTapTestCollectionCellReuseID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self recursiveLogGestureRecognizersInView:cell];
    NSLog(@"collection cell item selected.");
}

- (void)recursiveLogGestureRecognizersInView:(UIView *)view {
    NSLog(@"-------- view %@ begin ---------\n", view);
    
    [view.gestureRecognizers enumerateObjectsUsingBlock:
     ^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"gesture recognizer: %@\n", obj);
    }];
    
    if (view.subviews.count) {
        [view.subviews enumerateObjectsUsingBlock:
         ^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self recursiveLogGestureRecognizersInView:obj];
        }];
    }
    NSLog(@"-------- view %@ ends ---------\n", view);
}

@end
