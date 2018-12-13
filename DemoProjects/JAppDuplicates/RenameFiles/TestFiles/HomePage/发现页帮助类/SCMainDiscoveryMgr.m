//
//  PCMainDiscoveryMgr.m
//  SelfieCamera
//
//  Created by Cc on 2016/11/17.
//  Copyright © 2016年 Pinguo. All rights reserved.
//

#import "SCMainDiscoveryMgr.h"
#import <pg_sdk_common/pg_sdk_common.h>


    #define kPCMainDiscoveryName @"PCMainDiscoveryInner.json"
    #define kPCMainDiscoveryDownloadTime @"kPCMainDiscoveryDownloadTime"


@interface PCMainDiscoveryMgr ()

    @property (nonatomic,strong) NSDictionary *mDic_current;
    @property (nonatomic,strong) NSString *mCacheURL;

@end

@implementation PCMainDiscoveryMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 获取Library inner
        NSString *libPath = [self pGotLibraryInnerJsonPath];
        if ([pg_sdk_common_file_manager sIsFileExists:libPath]) {
            
            _mDic_current = [NSDictionary dictionaryWithContentsOfFile:libPath];
        }
        
//        [self pInner_v1];
        
#ifdef DEBUG
        [self DEBUG_just];
#endif
        
        NSInteger lastTime = [[NSUserDefaults standardUserDefaults] integerForKey:kPCMainDiscoveryDownloadTime];
        NSInteger currentTime = (NSInteger) [[NSDate date] timeIntervalSince1970];
        if (labs(lastTime - currentTime) > 72 * 3600) {
            SDKWS
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), queue, ^{
                // 下载
                SDKSS
                NSURL *url = [NSURL URLWithString:@"https://store-bsy.c360dn.com/PCMainDiscoveryInner.json"];
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self pDownloadUpdate:data]) {
                        
                        [[NSUserDefaults standardUserDefaults] setInteger:currentTime forKey:kPCMainDiscoveryDownloadTime];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                });
                
            });
        }
    }
    
    return self;
}

- (void)DEBUG_just
{
    NSString *docpath = [[pg_sdk_common_path_manager sGotDocumentDirectoryPath] stringByAppendingPathComponent:kPCMainDiscoveryName];
    if ([pg_sdk_common_file_manager sIsFileExists:docpath]) {
        
        NSData *data = [NSData dataWithContentsOfFile:docpath];
        [self pDownloadUpdate:data];
    }
}

- (BOOL)pDownloadUpdate:(NSData *)data
{
    @synchronized (self) {
        
        NSDictionary *dic = [NSJSONSerialization c_common_JSONObjectWithData:data];
        if ([[dic c_common_gotStringForKey:@"v"] integerValue] > [[_mDic_current c_common_gotStringForKey:@"v"] integerValue]) {
            
            return [self pSaveDic:dic];
        }
        
        return YES;
    }
    
    return NO;
}

//- (void)pInner_v1
//{
//    NSString *strKey = @"PCMainDiscoveryMgr_inner_v1";
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:strKey]) {
//    
//        NSString *innerPath = [[NSBundle mainBundle] pathForResource:@"PCMainDiscoveryInner" ofType:@"json"];
//        NSDictionary *dic = [NSJSONSerialization c_common_JSONObjectWithJsonContentsOfFile:innerPath];
//        
//        // 是否保存内置的json到目标目录
//        BOOL isSaveInnerJson = NO;
//        if (_mDic_current) {
//            // 做对比
//            if ([[dic c_common_gotStringForKey:@"v"] integerValue] >= [[_mDic_current c_common_gotStringForKey:@"v"] integerValue]) {
//                
//                isSaveInnerJson = YES;
//            }
//        }
//        else {
//            
//            isSaveInnerJson = YES;
//        }
//        
//        if (isSaveInnerJson) {
//            
//            [self pSaveDic:dic];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:strKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}

- (NSString *)pGotLibraryInnerJsonPath
{
    NSString *libPath = [pg_sdk_common_path_manager sGotLibraryDirectoryPath];
    NSString *name = [libPath stringByAppendingPathComponent:kPCMainDiscoveryName];
    return name;
}

- (BOOL)pSaveDic:(NSDictionary *)dic
{
    @synchronized (self) {
        
        if (dic) {
            
            NSString *libPath = [self pGotLibraryInnerJsonPath];
            if ([pg_sdk_common_file_manager sIsFileExists:libPath]) {
                
                [pg_sdk_common_file_manager sRemoveFile:libPath];
            }
            
            if ([dic writeToFile:libPath atomically:YES]) {
                
                self.mDic_current = dic;
                return YES;
            }
        }
        SDKAssertElseLog(@"");
    }
    
    return NO;
}


- (NSString *)pGotDiscovertLink
{
    @synchronized (self) {
        
        if (self.mCacheURL) {
            
            return self.mCacheURL;
        }
        
        if (_mDic_current) {
            
            NSDictionary *dic_currentRule = nil;
            NSString *ll = [[pg_sdk_common_device_manager instance] pGotOriginalSystemLanguage];
            NSString *cc = nil;
            // 判定最后一个字符是否是大写，如果有区域是大写的
            if (ll.length > 3) {
                
                NSString *b = [ll substringFromIndex:ll.length - 1];
                if ([b.uppercaseString isEqualToString:b]) {
                    
                    NSArray *mArr_duan = [ll componentsSeparatedByString:@"-"];
                    cc = mArr_duan.lastObject;
                }
            }
            
            if (cc.length > 0) {
                
                NSString *la = [NSString stringWithFormat:@"-%@", cc];
                if ([ll hasSuffix:la]) {
                    
                    ll = [ll stringByReplacingOccurrencesOfString:la withString:@""];
                }
            }
            
            NSArray<NSDictionary *> *mArr_r = [self.mDic_current c_common_gotArrayForKey:@"r"];
            for (NSDictionary *dic_rule in mArr_r) {
                // 开始遍历每一次rule
                {
                    // 版本 builde号的检测
                    NSInteger min_v = [[dic_rule c_common_gotStringForKey:@"v0"] integerValue];
                    NSInteger max_v = [[dic_rule c_common_gotStringForKey:@"v1"] integerValue];
                    if (min_v > max_v) {
                        
                        SDKAssert;
                        continue;
                    }
                    
                    NSInteger bundleVersionCode = [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] integerValue];
                    if (bundleVersionCode < min_v || bundleVersionCode > max_v) {
                        
                        SDKLog(@"版本号不匹配跳过 v0=%@  v1=%@  v=%@", @(min_v), @(max_v), @(bundleVersionCode));
                        continue;
                    }
                }
                
                {
                    // 地区检测
                    NSArray *mArr_c = [dic_rule c_common_gotArrayForKey:@"c"];
                    if (mArr_c && cc) {
                        
                        BOOL isContinue = YES;
                        for (NSString *country in mArr_c) {
                            
                            if ([country isEqualToString:cc]) {
                                
                                isContinue = NO;
                                break;
                            }
                        }
                        
                        if (isContinue) {
                            
                            continue;
                        }
                    }
                }
                
                {
                    // 语言检测
                    NSArray *mArr_l = [dic_rule c_common_gotArrayForKey:@"l"];
                    if (mArr_l && ll) {
                        
                        BOOL isContinue = YES;
                        for (NSString *lang in mArr_l) {
                            
                            if ([lang isEqualToString:ll]) {
                                
                                isContinue = NO;
                                break;
                            }
                        }
                        
                        if (isContinue) {
                            
                            continue;
                        }
                    }
                }
                
                // 成功匹配
                dic_currentRule = dic_rule;
                break;
            }
            
            if (dic_currentRule) {
            
                NSString *strK = [dic_currentRule c_common_gotStringForKey:@"k"];
                NSArray *mArr_l = [self.mDic_current c_common_gotArrayForKey:@"l"];
                for (NSDictionary *dic_link in mArr_l) {
                    
                    NSString *link_k = [dic_link c_common_gotStringForKey:@"k"];
                    if ([link_k isEqualToString:strK]) {
                        
                        NSString *link_v = [dic_link c_common_gotStringForKey:@"v"];
                        self.mCacheURL = link_v;
                        break;
                    }
                }
            }
        }
        
        return self.mCacheURL;
    }
}

@end

