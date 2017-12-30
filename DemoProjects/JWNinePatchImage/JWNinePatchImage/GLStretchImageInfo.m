//
//  GLStretchImageInfo.m
//  JWNinePatchImage
//
//  Created by JiangWang on 28/12/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "GLStretchImageInfo.h"

@implementation GLEdgeInsets

- (UIEdgeInsets)edgeInsets {
    return (UIEdgeInsets){self.top, self.left, self.bottom, self.right};
}
@end

@implementation GLStretchImageInfo

- (instancetype)initWithImageJson:(NSString *)json {
    self = [super init];
    if (self) {
        NSError *error;
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:json];
        NSDictionary  *JSONObject = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                               options:0 error:&error] : nil;
        GLEdgeInsets *strechInsets = [[GLEdgeInsets alloc] init];
        NSDictionary *stretchDict = JSONObject[@"stretch"];
        strechInsets.top = [stretchDict[@"top"] floatValue];
        strechInsets.left = [stretchDict[@"left"] floatValue];
        strechInsets.bottom = [stretchDict[@"bottom"] floatValue];
        strechInsets.right = [stretchDict[@"right"] floatValue];
        _strechInsets = strechInsets;
        
        NSDictionary *contentDict = JSONObject[@"content_insets"];
        GLEdgeInsets *contentInsets = [[GLEdgeInsets alloc] init];
        contentInsets.top = [contentDict[@"top"] floatValue];
        contentInsets.left = [contentDict[@"left"] floatValue];
        contentInsets.bottom = [contentDict[@"bottom"] floatValue];
        contentInsets.right = [contentDict[@"right"] floatValue];
        _contentInsets = contentInsets;
    }
    return self;
}
@end
