//
//  ViewController.m
//  AttibutedStringTest
//
//  Created by JiangWang on 7/29/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *attributedLabel;

@property (strong, nonatomic) NSMutableAttributedString *attribsString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.attributedLabel.numberOfLines = 0;
   
    [self initializeText];
}

- (void)initializeText {
    
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"一款强大的图片滤镜工具, 支持自定义滤镜, 可用来实时处理图片和视频流, 作者是 SonoPlot 公司的 CTO, 在很小的时候便开始接触编程, 他在 SO 上面的回答也有很多值得阅读\nGPUImage 这个项目从 2012 年开始, 使用 OpenGL 图形程序接口编写, 性能非常好, 现在很多 iOS 程序员都用它来实现 iOS 的模糊效果"];
    
    self.attribsString = attributedText;
    
    self.attributedLabel.attributedText = attributedText;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fontChangeToSize:12 range:NSMakeRange(2, 10)];
    
    [self colorChangeTo:[UIColor brownColor] range:NSMakeRange(8, 15)];
    
    [self changeAttribs];
    
    [self changeWordGap:7 range:NSMakeRange(43, 5)];
    
    [self strikeThrough];
    
    [self underLine];
    
    [self changeBaselineOffset:10 range:NSMakeRange(60, 5)];
    
    [self changeBaselineOffset:-10 range:NSMakeRange(66, 5)];
    
    [self addAnImage:[UIImage imageNamed:@"testImage"] range:NSMakeRange(71, 0)];
    
    [self changeParagraphStyleAtRange:NSMakeRange(0, self.attribsString.length)];
}

- (void)fontChangeToSize:(CGFloat)font range:(NSRange)range {
    
    [self.attribsString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)colorChangeTo:(UIColor *)color range:(NSRange)range {

    [self.attribsString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)changeAttribs {
    NSDictionary *attribs = @{
                              NSStrokeColorAttributeName : [UIColor redColor],
                              NSStrokeWidthAttributeName : @(4)
                              };
    
    [self.attribsString addAttributes:attribs range:NSMakeRange(30, 10)];
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)changeWordGap:(CGFloat)gap range:(NSRange)range {
    [self.attribsString addAttribute:NSKernAttributeName value:@(gap) range:range];
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)strikeThrough {
    NSDictionary *strikeTrough = @{
                                   NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternDash),
                                   NSStrikethroughColorAttributeName : [UIColor yellowColor]
                                   };
    [self.attribsString addAttributes:strikeTrough range:NSMakeRange(50, 5)];
    [self.attributedLabel setAttributedText:self.attribsString];
}

- (void)underLine {
    NSDictionary *underAttribs = @{
                                   NSUnderlineStyleAttributeName : @(NSUnderlineStyleDouble | NSUnderlinePatternDashDotDot),
                                   NSUnderlineColorAttributeName : [UIColor redColor]
                                   };
    [self.attribsString addAttributes:underAttribs range:NSMakeRange(50, 5)];
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)changeBaselineOffset:(CGFloat)offset range:(NSRange)range {
    [self.attribsString addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:range];
    [self.attributedLabel setAttributedText:self.attribsString];
}

#warning these two are important!!
#pragma mark - picture plus characters 
- (void)addAnImage:(UIImage *)image range:(NSRange)range {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, +10, 14, 14);
    
    //convert the attachment to nsattributedString
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    [self.attribsString insertAttributedString:attachmentString atIndex:range.location];
    
    self.attributedLabel.attributedText = self.attribsString;
}

- (void)changeParagraphStyleAtRange:(NSRange)range {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.f;
    paragraphStyle.paragraphSpacing = 20.f;
    paragraphStyle.headIndent = 30.f;
//    paragraphStyle.tailIndent = 30.f;
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.firstLineHeadIndent = 15.f;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    [self.attribsString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    self.attributedLabel.attributedText = self.attribsString;
}



@end
