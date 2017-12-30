//
//  ViewController.m
//  JWNinePatchImage
//
//  Created by JiangWang on 28/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "ViewController.h"
//#import "SWNinePatchImageFactory.h"
//#import "UIImage+NinePatch.h"
//#import "SKNinePatchImage.h"
#import "GLStretchImageInfo.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImgeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (assign, nonatomic) CGFloat originalWidthConstraintConstant;
@property (assign, nonatomic) CGFloat originalHeightConstraintConstant;

//label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *originalImage = [UIImage imageNamed:@"car_enter"];
    CGSize imageSize = originalImage.size;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *jsonPath = [mainBundle pathForResource:@"img" ofType:@"json"];
    GLStretchImageInfo *imageInfo = [[GLStretchImageInfo alloc] initWithImageJson:jsonPath];
    UIImage *resizableImage = [originalImage resizableImageWithCapInsets:imageInfo.strechInsets.edgeInsets
                                                            resizingMode:UIImageResizingModeStretch];
    self.testImgeView.image = resizableImage;
    self.originalWidthConstraintConstant = _imageWidthConstraint.constant;
    self.originalHeightConstraintConstant = _imageHeightConstraint.constant;
    _imageHeightConstraint.constant = imageSize.height;
    
    //
    self.left.constant = imageInfo.contentInsets.left;
    self.right.constant = -imageInfo.contentInsets.right;
    self.top.constant = imageInfo.contentInsets.top;
    self.bottom.constant = -imageInfo.contentInsets.bottom;
    [self.view setNeedsUpdateConstraints];
}

- (IBAction)horizontalStrech:(UISlider *)sender {
    CGFloat horizontalSliderValue = sender.value;
    CGFloat resizeFactor = (horizontalSliderValue / 0.5) + 1;
    _imageWidthConstraint.constant = (self.originalWidthConstraintConstant) * resizeFactor;
    [self.view setNeedsUpdateConstraints];
}

- (IBAction)verticalStrech:(UISlider *)sender {
    return;
    CGFloat vertSliderValue = sender.value;
    CGFloat resizeFactor = (vertSliderValue / 0.5);
    if (resizeFactor > 1) {
        resizeFactor = resizeFactor * 2;
    }
    _imageHeightConstraint.constant = (self.originalHeightConstraintConstant) * resizeFactor;
    [self.view setNeedsUpdateConstraints];
}


@end
