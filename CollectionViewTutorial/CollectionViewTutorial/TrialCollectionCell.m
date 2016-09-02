//
//  TrialCollectionCell.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TrialCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TrialCollectionCell()

/* redefine imageView */
@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation TrialCollectionCell


/**
 *  Designated Initializer
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //set bg color to have a color contrast;
        [self setBackgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]];
        
        //Add Image View
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
        [self.contentView addSubview:imageView];
        
        //Configure the cell
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3.f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.f;
        self.layer.shadowOffset = CGSizeMake(.0f, 2.f);
        self.layer.shadowOpacity = 0.5f;
        
        //Rasterize
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize = YES;
    }
    
    return self;
}

/**
 *  Prepare For Reuse
 */
- (void)prepareForReuse {
    [super prepareForReuse];
    
    _imageView = nil;
}



@end
