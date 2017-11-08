//
//  PTLogFormatter.m
//  Partner
//
//  Created by JiangWang on 17/09/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "PTLogFormatter.h"
@interface PTLogFormatter()
@property (nonatomic, strong) NSDateFormatter *threadUnsafeDateFormatter;
@property (nonatomic, assign) NSInteger loggerCount;
@end

@implementation PTLogFormatter

- (id)init {
    if((self = [super init])) {
        _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [_threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        _loggerCount = 0;
    }
    return self;
}

//required methods
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *timeFormat = [self.threadUnsafeDateFormatter stringFromDate:logMessage.timestamp];
    return [NSString stringWithFormat:@"[%@] | %@ | method: %@ line:%lu | %@",
            timeFormat,
            logLevel, logMessage.function,
            logMessage.line, logMessage->_message];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    _loggerCount++;
    NSAssert(_loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    _loggerCount--;
}

@end
