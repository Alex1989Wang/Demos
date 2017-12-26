//
//  JWVCPViewController.m
//  JWViewControllerPresentationTransitions
//
//  Created by JiangWang on 23/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWVCPViewController.h"
#import "JWVCPBookDetailViewController.h"
#import "JWVCPBookPresentationTransitionAnimator.h"

@interface JWVCPCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation JWVCPCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

#pragma mark - Lazy Loading 
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
@end

#define kPictureCellReuseID @"jiang.com.kPictureCellReuseID"
#define kInvalidCellReuseID @"jiang.com.kInvalidCellReuseID"
#define kCellCornerRadius (20.f)
@interface JWVCPViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *picturesCollection;
@property (nonatomic, strong) NSArray *pictureNames;
@property (nonatomic, strong) JWVCPBookPresentationTransitionAnimator *presentationAnimator;
@property (nonatomic, weak) UICollectionViewCell *selectedCell;
@end

@implementation JWVCPViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPicturesCollection];
}

- (void)setupPicturesCollection {
    [_picturesCollection registerClass:[JWVCPCollectionCell class]
            forCellWithReuseIdentifier:kPictureCellReuseID];
    [_picturesCollection registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kInvalidCellReuseID];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.pictureNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.pictureNames.count && indexPath.item >= 0) {
        NSString *pictureName = self.pictureNames[indexPath.row];
        JWVCPCollectionCell *itemCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:kPictureCellReuseID
                                                  forIndexPath:indexPath];
        itemCell.imageView.image = [UIImage imageNamed:pictureName];
        itemCell.layer.cornerRadius = kCellCornerRadius;
        itemCell.layer.masksToBounds = YES;
        return itemCell;
    }
    else {
        UICollectionViewCell *invalidCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:kInvalidCellReuseID
                                                  forIndexPath:indexPath];
        return invalidCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= 0 && indexPath.item < self.pictureNames.count) {
        self.selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
        NSString *bookName = self.pictureNames[indexPath.item];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSString *detailVCId = NSStringFromClass([JWVCPBookDetailViewController class]);
        JWVCPBookDetailViewController *bookDetailVC =
        [mainStoryboard instantiateViewControllerWithIdentifier:detailVCId];
        bookDetailVC.bookName = bookName;
        bookDetailVC.transitioningDelegate = self;
        [self presentViewController:bookDetailVC
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presentationAnimator.presenting = YES;
    CGRect cellViewRect = [self.selectedCell convertRect:self.selectedCell.bounds toView:self.view];
    self.presentationAnimator.originRect = cellViewRect;
    self.presentationAnimator.originCornerRadius = self.selectedCell.layer.cornerRadius;
    self.selectedCell.hidden = YES;
    return self.presentationAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presentationAnimator.presenting = NO;
    __weak typeof(self) weakSelf = self;
    self.presentationAnimator.aniCompletion = ^{
        __strong typeof(weakSelf) strSelf = weakSelf;
        strSelf.selectedCell.hidden = NO;
    };
    return self.presentationAnimator;
}


#pragma mark - Lazy Loading 
- (NSArray *)pictureNames {
    if (!_pictureNames) {
        _pictureNames = @[@"book_one",
                          @"book_two",
                          @"book_three",
                          @"book_four",
                          @"book_five",
                          @"book_six",
                          @"book_seven",];
                          
    }
    return _pictureNames;
}

- (JWVCPBookPresentationTransitionAnimator *)presentationAnimator {
    if (!_presentationAnimator) {
        _presentationAnimator = [[JWVCPBookPresentationTransitionAnimator alloc] init];
    }
    return _presentationAnimator;
}

@end
