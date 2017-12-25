//
//  JWNSAttributedStringCrashViewController.m
//  JWCrashTest
//
//  Created by JiangWang on 11/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "JWNSAttributedStringCrashViewController.h"

@interface JWNSAttributedStringCrashViewController ()
@property (nonatomic, weak) UILabel *testLabel;
@end

@implementation JWNSAttributedStringCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //label
    [self testLabel];
    CGRect viewBounds = self.view.bounds;
    CGRect labelFrame = CGRectInset(viewBounds, 50, 0);
    labelFrame.size.height = 20;
    labelFrame.origin.y = 100;
    self.testLabel.frame = labelFrame;
    
    //set attributed string
//    [self setAttributedStringMainThread];
    [self setAttributedStringOtherThread];
    
    //测试是否崩溃
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAttributedStringAfterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}



- (void)setAttributedStringMainThread {
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                    repeats:YES
                                      block:
     ^(NSTimer * _Nonnull timer) {
         BOOL random = (arc4random() % 2 == 0);
         NSString *htmlStr = (random) ? @"<font color=#ff6371>300</font> coins remain. Sharing the live can have a chance to open the Treasure Box again!" : nil;
         NSData *htmlData = [htmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
         NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
         __block NSDictionary *documentAttribs = [NSDictionary dictionary];
         __block NSError *error = nil;
         NSAttributedString *attribStr = [[NSAttributedString alloc] initWithData:htmlData
                                                                          options:options
                                                               documentAttributes:&documentAttribs
                                                                            error:&error];
         NSLog(@"function: %@ document attributes: %@ and parse error: %@",
               NSStringFromSelector(_cmd), documentAttribs, error);
         __strong typeof(weakSelf) strSelf = weakSelf;
         [strSelf.testLabel setAttributedText:attribStr];
     }];
}

- (void)setAttributedStringOtherThread {
    
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                    repeats:YES
                                      block:
     ^(NSTimer * _Nonnull timer) {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             BOOL random = (arc4random() % 2 == 0);
             NSString *htmlStr = (random) ? @"<font color=#ff6371>300</font> coins remain. Sharing the live can have a chance to open the Treasure Box again!" : nil;
             NSData *htmlData = [htmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
             NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
             __block NSDictionary *documentAttribs = [NSDictionary dictionary];
             __block NSError *error = nil;
             NSAttributedString *attribStr = [[NSAttributedString alloc] initWithData:htmlData
                                                                              options:options
                                                                   documentAttributes:&documentAttribs
                                                                                error:&error];
             NSLog(@"function: %@ document attributes: %@ and parse error: %@",
                   NSStringFromSelector(_cmd), documentAttribs, error);
             __strong typeof(weakSelf) strSelf = weakSelf;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [strSelf.testLabel setAttributedText:attribStr];
             });
         });
     }];
}

- (void)setAttributedStringAfterBackground {
    NSString *htmlStr = @"<font color=#ff6371>300</font> coins remain. Sharing the live can have a chance to open the Treasure Box again!";
    NSData *htmlData = [htmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *options = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                              NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSDictionary *documentAttribs = [NSDictionary dictionary];
    NSError *error = nil;
    NSAttributedString *attribStr = [[NSAttributedString alloc] initWithData:htmlData
                                                                     options:options
                                                          documentAttributes:&documentAttribs
                                                                       error:&error];
    NSLog(@"function: %@ document attributes: %@ and parse error: %@",
          NSStringFromSelector(_cmd), documentAttribs, error);
    [self.testLabel setAttributedText:attribStr];
}

#pragma mark - Lazy Loading
- (UILabel *)testLabel {
    if (!_testLabel) {
        UILabel *testLabel = [[UILabel alloc] init];
        testLabel.font = [UIFont systemFontOfSize:15];
        testLabel.backgroundColor = [UIColor grayColor];
        _testLabel = testLabel;
        [self.view addSubview:testLabel];
    }
    return _testLabel;
}

@end
