//
//  TrialCollectionViewController.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TrialCollectionViewController.h"
#import "TrialCollectionCell.h"
#import "TrialCollectionViewLayout.h"
#import "TrialCollectionTitle.h"
#import "TrialDecorationView.h"
#import "BHAlbum.h"
#import "BHPhoto.h"

#define kSectionCount 12

@interface TrialCollectionViewController ()

/* The Layout Outlet */
@property (weak, nonatomic) IBOutlet TrialCollectionViewLayout *trialLayout;

/* Array To Hold Albums */
@property (nonatomic, strong) NSMutableArray<BHAlbum *> *albums;

/* Concurrent Queue To Load Pics */
@property (nonatomic, strong) NSOperationQueue *picLoadingQueue;

@end

@implementation TrialCollectionViewController

static NSString *const trialCollectionCellReuseID = @"trialCollectionCellReuseID";
static NSString *const trialCollectionTitleReuseID = @"trialCollectionTitleReuseID";
static NSString *const trialCollectionDecorationReuseID = @"trialCollectionDecorationReuseID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TrialCollectionCell class] forCellWithReuseIdentifier:trialCollectionCellReuseID];
    [self.collectionView registerClass:[TrialCollectionTitle class] forSupplementaryViewOfKind:TrialCollectionTitleKindID withReuseIdentifier:trialCollectionTitleReuseID];

    
    //Bg Color
    UIImage *image = [UIImage imageNamed:@"concrete_wall"];
    [self.collectionView setBackgroundColor:[UIColor colorWithPatternImage:image]];
    
    
    //Get Photos
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix =
    [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    
    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < kSectionCount; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %ld",a + 1];
        
        NSUInteger photoCount = arc4random()%4 + 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%ld.jpg",photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    
    //Instantiate A Pic Loading Queue
    _picLoadingQueue = [[NSOperationQueue alloc] init];
    _picLoadingQueue.maxConcurrentOperationCount = 3;
}


/**
 *  Handle Orientation Change
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > 480) {
        _trialLayout.numOfColumns = 3;
        _trialLayout.itemEdgeInsets = UIEdgeInsetsMake(22.f, 35.f, 13.f, 35.f);
    }else {
        _trialLayout.numOfColumns = 2;
        _trialLayout.itemEdgeInsets = UIEdgeInsetsMake(22.f, 22.f, 13.f, 22.f);
    }
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.albums.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:trialCollectionCellReuseID forIndexPath:indexPath];
    
    BHAlbum *albumToShow = self.albums[indexPath.section];
    BHPhoto *photo = albumToShow.photos[indexPath.row];
    
    __weak typeof(self) collectionVCWeakSel = self;
    
    NSBlockOperation *picLoadingOp = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = photo.image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ([collectionVCWeakSel.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                TrialCollectionCell * cell = (TrialCollectionCell *)[collectionVCWeakSel.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
            
        });
        
    }];
    picLoadingOp.queuePriority = (indexPath.item == 0) ? NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    [_picLoadingQueue addOperation:picLoadingOp];
    
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TrialCollectionTitle *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:trialCollectionTitleReuseID forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    titleView.titleLabel.text = album.name;
    
    return titleView;
}





@end
