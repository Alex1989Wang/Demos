//
//  TestSynchronusOperation.m
//  ConcurrentDemo
//
//  Created by JiangWang on 27/04/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "TestSynchronusOperation.h"
#import <UIKit/UIKit.h>

@implementation TestSynchronusOperation

//Synchronous
//不需要override -(void)start;
//只需要将work load放到main方法就可以了
- (void)main {
    if (self.isFinished || self.isCancelled) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDir =
    [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSLog(@"document directory: %@", documentDir.absoluteString);
    
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(imageContext, [UIColor brownColor].CGColor);
    CGContextFillRect(imageContext, CGRectMake(0, 0, 300, 300));
    UIImage *drawedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (drawedImage) {
        NSString *imagePath = [documentDir.path stringByAppendingPathComponent:@"image.png"];
        BOOL createImageFile = [fileManager createFileAtPath:imagePath
                                                    contents:UIImagePNGRepresentation(drawedImage)
                                                  attributes:nil];
        NSLog(@"image file creation: %d", createImageFile);
    }
    
    NSError *error = nil;
    NSArray *resourceKeys = @[NSURLFileResourceTypeKey];
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsHiddenFiles;
    NSArray<NSURL *> *filePaths = [fileManager contentsOfDirectoryAtURL:documentDir
                                             includingPropertiesForKeys:resourceKeys
                                                                options:options
                                                                  error:&error];
    for (NSURL *subFileURL in filePaths) {
        if (self.isCancelled) {
            return;
        }
        
        NSError *error = nil;
        id resourceValue = nil;
        [subFileURL getResourceValue:&resourceValue
                              forKey:NSURLFileResourceTypeKey
                               error:&error];
        NSLog(@"resource type: %@ -- url: %@", resourceValue, subFileURL);
    }
}

@end
