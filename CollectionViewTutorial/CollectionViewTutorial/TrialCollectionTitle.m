//
//  TrialCollectionTitle.m
//  CollectionViewTutorial
//
//  Created by JiangWang on 9/2/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "TrialCollectionTitle.h"

@interface TrialCollectionTitle()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation TrialCollectionTitle

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        _titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        _titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        [self addSubview:self.titleLabel];
    }
    return self;

}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLabel.text = nil;
}

@end
