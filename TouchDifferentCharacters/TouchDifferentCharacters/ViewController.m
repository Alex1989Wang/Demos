//
//  ViewController.m
//  TouchDifferentCharacters
//
//  Created by JiangWang on 19/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *testTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTextView];
}

- (void)configureTextView
{
    UITapGestureRecognizer *tapGues = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(didTapTextField:)];
    [self.testTextView addGestureRecognizer:tapGues];
    self.testTextView.editable = NO;
    
    
    //test text
    NSString *textFirstSegm = @"没有点击事件";
    NSString *tapActionOne = @"第一个点击事件";
    NSString *textThirdSegm = @"也没有点击事件";
    NSString *tapActionTwo = @"第二个点击事件";
    
    NSDictionary *tapOneAttribs = @{
                                    @"tapActionOne" : @(YES),
                                    NSForegroundColorAttributeName : [UIColor orangeColor]
                                    };
    NSAttributedString *tapOneAttribsStr = [[NSAttributedString alloc]
                                            initWithString:tapActionOne
                                            attributes:tapOneAttribs];
    NSDictionary *tapTwoAttribs = @{
                                    @"tapActionTwo" : @(YES),
                                    NSForegroundColorAttributeName : [UIColor brownColor]
                                    };
    NSAttributedString *tapTwoAttribsStr = [[NSAttributedString alloc]
                                            initWithString:tapActionTwo
                                            attributes:tapTwoAttribs];
    
    NSMutableAttributedString *fullAttribStr =
    [[NSMutableAttributedString alloc] initWithString:textFirstSegm];
    [fullAttribStr appendAttributedString:tapOneAttribsStr];
    NSAttributedString *thirdSegmAttribStr =
    [[NSAttributedString alloc] initWithString:textThirdSegm];
    [fullAttribStr appendAttributedString:thirdSegmAttribStr];
    [fullAttribStr appendAttributedString:tapTwoAttribsStr];
    
    self.testTextView.attributedText = fullAttribStr;
}


- (void)didTapTextField:(UITapGestureRecognizer *)tap
{
    UITextView *textView = (UITextView *)tap.view;
    CGPoint location = [tap locationInView:textView];
    NSLayoutManager *layoutManager = textView.layoutManager;
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSLog(@"tap location in text view: %@", NSStringFromCGPoint(location));
    
    //点击了字符索引
    NSUInteger tappedIndex = 0;
    tappedIndex = [layoutManager characterIndexForPoint:location
                                        inTextContainer:textView.textContainer
               fractionOfDistanceBetweenInsertionPoints:NULL];
    if (tappedIndex < textView.textStorage.length)
    {
        NSRange effectiveRange;
        NSDictionary *tappedCharsAttribs = [textView.textStorage
                                            attributesAtIndex:tappedIndex
                                            effectiveRange:&effectiveRange];
        NSLog(@"tapped attribs: %@", tappedCharsAttribs);
    }
}
@end
