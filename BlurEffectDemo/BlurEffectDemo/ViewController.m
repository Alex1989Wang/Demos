//
//  ViewController.m
//  BlurEffectDemo
//
//  Created by JiangWang on 12/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showBlurBtn;

//lazy loading properties
@property (nonatomic, strong) UITextView *introTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupBlurEffect
{
    UIBlurEffect *lightBlur =
    [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView =
    [[UIVisualEffectView alloc] initWithEffect:lightBlur];
    blurView.frame = self.view.bounds;
    
    //add content views
//    [blurView.contentView addSubview:self.introTextView];
    [self.view addSubview:blurView];
    
    //vibrancy
    UIVibrancyEffect *vibEffect =
    [UIVibrancyEffect effectForBlurEffect:lightBlur];
    UIVisualEffectView *vibView =
    [[UIVisualEffectView alloc] initWithEffect:vibEffect];
    vibView.frame = blurView.bounds;
    
    [blurView.contentView addSubview:vibView];
    
    [vibView addSubview:self.introTextView];
}


- (IBAction)showBlur:(UIButton *)sender
{
    [self setupBlurEffect];
}

- (UITextView *)introTextView
{
    if (!_introTextView)
    {
        _introTextView = [[UITextView alloc] initWithFrame:
                          CGRectMake(0, 250, self.view.bounds.size.width, 300)];
        _introTextView.textContainerInset =
        UIEdgeInsetsMake(20, 20, 20, 20);
        _introTextView.backgroundColor = [UIColor clearColor];
        _introTextView.font = [UIFont systemFontOfSize:17];
        _introTextView.text = @"It appears that the NSURLSessionTask factory method downloadTaskWithURL: has some black-box magic happening on iOS 7. Since __NSCFLocalDownloadTask doesn't inherit from NSURLSessionTask on iOS 7, that means that our associated object wont exist on our task object. All we had to do was change the class to NSURLSessionDownloadTask and everything worked just fine. My hunch is that NSURLSessionTask is some sort of class-cluster similar to UIButton.";
    }
    return _introTextView;
}


@end
