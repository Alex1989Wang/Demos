//
//  GLSensitiveWordsFilter.m
//  GLive
//
//  Created by JiangWang on 26/07/2017.
//  Copyright © 2017 3g.cn. All rights reserved.
//

#import "GLSensitiveWordsFilter.h"

static NSString *kSensitiveWordEnd = @"kSensitiveWordEnd";
static NSString *kSensittiveWordGap = @" ";
static NSInteger kPositionExtrem = (-1);

@interface GLSensitiveWordsFilter()
@property (nonatomic, assign, getter=isFilterOn) BOOL filterOn;
@property (nonatomic, copy) NSString *filterPath;
@property (nonatomic, strong) NSMutableDictionary *filterVocab;
@property (nonatomic, assign, getter=shouldContinueFilter) BOOL continueFilter;
@end

@implementation GLSensitiveWordsFilter

+ (GLSensitiveWordsFilter *)sharedFilter {
    static GLSensitiveWordsFilter *sharedFilter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFilter = [[GLSensitiveWordsFilter alloc] init];
        [sharedFilter setFilterVocabularyPath:[sharedFilter defaultFilterPath]];
        sharedFilter.filterOn = YES;
    });
    return sharedFilter;
}

- (void)setFilterVocabularyPath:(NSString *)vocabPath {
    if (!vocabPath.length) {
        return;
    }
    
    if (![_filterPath isEqualToString:vocabPath]) {
        _filterPath = vocabPath;
        [self setupFilterVocabulary];
    }
}

- (NSString *)filterWords:(NSString *)words {
    if (!words.length || !self.isFilterOn || !self.filterVocab.count) {
        return words;
    }
    
    NSMutableString *result = [words mutableCopy];
    @autoreleasepool {
        for (NSInteger start = 0; start < words.length; start++) {
            NSInteger matchedLength = [self matchedLengthWithTargetString:words
                                                          matchBeginIndex:start];
            if (matchedLength > 0) {
                NSInteger adjustedStart = (start - 1) < 0 ? kPositionExtrem : (start - 1);
                NSInteger adjustedEnd = (start + matchedLength + 1) > words.length ?
                kPositionExtrem : (start + matchedLength);
                
                if (adjustedStart == kPositionExtrem && adjustedEnd == kPositionExtrem) {
                    //全部匹配
                    NSString *replacementString = [self buildReplacementStringWithLength:matchedLength];
                    [result replaceCharactersInRange:NSMakeRange(start, matchedLength)
                                          withString:replacementString];
                }
                else if (adjustedStart != kPositionExtrem && adjustedEnd != kPositionExtrem) {
                    NSString *startChar = [words substringWithRange:NSMakeRange(adjustedStart, 1)];
                    NSString *endChar = [words substringWithRange:NSMakeRange(adjustedEnd, 1)];
                    if ([self isCharacterWordBoundaryWithCharcter:startChar] &&
                        [self isCharacterWordBoundaryWithCharcter:endChar]) {
                        NSString *replacementString = [self buildReplacementStringWithLength:matchedLength];
                        [result replaceCharactersInRange:NSMakeRange(start, matchedLength)
                                              withString:replacementString];
                    }
                }
                else if (adjustedStart != kPositionExtrem && adjustedEnd == kPositionExtrem) {
                    NSString *startChar = [words substringWithRange:NSMakeRange(adjustedStart, 1)];
                    if ([self isCharacterWordBoundaryWithCharcter:startChar]) {
                        NSString *replacementString = [self buildReplacementStringWithLength:matchedLength];
                        [result replaceCharactersInRange:NSMakeRange(start, matchedLength)
                                              withString:replacementString];
                    }
                }
                else if (adjustedEnd != kPositionExtrem && adjustedStart == kPositionExtrem) {
                    NSString *endChar = [words substringWithRange:NSMakeRange(adjustedEnd, 1)];
                    if ([self isCharacterWordBoundaryWithCharcter:endChar]) {
                        NSString *replacementString = [self buildReplacementStringWithLength:matchedLength];
                        [result replaceCharactersInRange:NSMakeRange(start, matchedLength)
                                              withString:replacementString];
                    }
                }
                start = (start + matchedLength - 1);
            }
        }
    }
    return result;
}

- (NSInteger)matchedLengthWithTargetString:(NSString *)targetString
                           matchBeginIndex:(NSInteger)beginIndex {
    NSMutableDictionary *charNode = self.filterVocab;
    BOOL matched = NO;
    NSInteger matchedLength = 0;
    for (NSInteger index = beginIndex; index < targetString.length; index++) {
        NSString *character = [targetString substringWithRange:NSMakeRange(index, 1)];
        NSString *lowerCharacter = character.lowercaseString;
        if (lowerCharacter) {
            NSMutableDictionary *nextNode = charNode[lowerCharacter];
            if (!nextNode) {
                break;
            }
            else {
                charNode = nextNode;
                matchedLength++;
            }
            matched = charNode[kSensitiveWordEnd];
        }
        else {
            break;
        }
    }
    return ((matchedLength > 1) && matched) ? matchedLength : 0;
}

- (void)filpFilter:(BOOL)filpOn {
    if (_filterOn != filpOn) {
        _filterOn = filpOn;
    }
}

- (BOOL)shouldContinueFilterWithCurrentCharNode:(NSMutableDictionary *)charNode
                          currentCheckWordIndex:(NSUInteger)wordIndex
                                 sepetatedWords:(NSArray *)wordsArray {
    if (wordsArray.count > (wordIndex + 1)) {
        //还可能有词需要继续匹配
        NSString *nextWord = wordsArray[wordIndex + 1];
        NSMutableDictionary *nextCharNode = charNode[kSensittiveWordGap]; //下一个节点
        if (nextWord.length) {
            NSString *firstChar = [nextWord substringWithRange:NSMakeRange(0, 1)];
            return (nextCharNode[firstChar] != nil);
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

#pragma mark - Private 
- (void)setupFilterVocabulary {
    if (self.filterVocab.count) {
        [self.filterVocab removeAllObjects];
    }
    
    NSError *error = nil;
    NSString *sensitiveWords = [[NSString alloc] initWithContentsOfFile:self.filterPath
                                                               encoding:NSUTF8StringEncoding
                                                                  error:&error];
    if (error) {
        NSLog(@"initilize sensitive words vocabulary failed.");
        return;
    }
    
    NSArray *seperatedWords = [sensitiveWords componentsSeparatedByString:@"\n"];
    for (NSString *sensiWord in seperatedWords) {
        [self insertSensitiveWord:sensiWord];
    }
}

- (void)insertSensitiveWord:(NSString *)sensiWord {
    NSCharacterSet *blankSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedSensiWord = [sensiWord stringByTrimmingCharactersInSet:blankSet];
    if (!trimedSensiWord.length) {
        return;
    }
    
    trimedSensiWord = [trimedSensiWord lowercaseString];
    NSMutableDictionary *nodeDict = self.filterVocab;
    for (NSInteger index = 0; index < trimedSensiWord.length; index++) {
        NSString *character = [trimedSensiWord substringWithRange:NSMakeRange(index, 1)];
        if (nodeDict[character] == nil) {
            nodeDict[character] = [NSMutableDictionary dictionary];
        }
        nodeDict = nodeDict[character];
    }
    nodeDict[kSensitiveWordEnd] = @(YES);
}

- (BOOL)isCharacterWordBoundaryWithCharcter:(NSString *)character {
    NSString *limits = @"[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？ ]";
    return [limits containsString:character];
}

- (NSString *)buildReplacementStringWithLength:(NSInteger)length {
    length = (length < 0) ? 0 : length;
    return [@"" stringByPaddingToLength:length
                             withString:@"*"
                        startingAtIndex:0];
}

#pragma mark - Lazy Loading
- (NSString *)defaultFilterPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SensitiveWords" ofType:@"txt"];
    return filePath;
}

- (NSMutableDictionary *)filterVocab {
    if (!_filterVocab) {
        _filterVocab = [NSMutableDictionary dictionary];
    }
    return _filterVocab;
}

@end
