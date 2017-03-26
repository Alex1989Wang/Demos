//
//  ViewController.m
//  JavaScriptCoreTest
//
//  Created by JiangWang on 20/12/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSContext *jsCTX = [[JSContext alloc] init];
    jsCTX.exceptionHandler = ^(JSContext *context, JSValue *exception)
    {
        NSLog(@"js context: %@, exception: %@", context, exception);
    };
    
    [jsCTX evaluateScript:@"var number = 5 + 5"];
    [jsCTX evaluateScript:@"var tripple = function(value) {return value * 3}"];
    JSValue *result = [jsCTX evaluateScript:@"triple(number)"];
    NSLog(@"js evaluation result: %@", [result toNumber]);
    
    [jsCTX evaluateScript:@"var names = ['Grace', 'Ada', 'Margret']"];
    JSValue *names = jsCTX[@"names"];
    JSValue *firstName = names[0];
    NSLog(@"first name: %@", [firstName toString]);
    
    JSValue *trippleFunction = jsCTX[@"tripple"];
    JSValue *trippleRes = [trippleFunction callWithArguments:@[@(5)]];
    NSLog(@"tripple (5) result: %@", [trippleRes toNumber]);
    
    [jsCTX evaluateScript:@"function multiply(value1, value2) {return value1 * value2}"];
    
    jsCTX[@"simplifyString"] = ^(NSString *input) {
        NSMutableString *mutableString = [input mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
        return mutableString;
    };
    NSLog(@"%@", [jsCTX evaluateScript:@"simplifyString('王江!')"]);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //
    JSContext *jsContext = [[JSContext alloc] init];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception)
    {
        NSLog(@"context: %@ ==== exception: %@", context, exception);
    };
    [jsContext evaluateScript:@"\
     var loadPeopleFromJSON = function(jsonString) { \
        var data = JSON.parse(jsonString); \
        var people = []; \
        for (i = 0; i < data.length; i++) { \
            var person = Person.createWithFirstNameLastName(data[i].first, data[i].last); \
            person.birthYear = data[i].year; \
            people.push(person); \
        } \
        return people; \
    }"];
    jsContext[@"Person"] = [Person class];
    NSArray *people = @[
                       @{ @"first": @"Grace",     @"last": @"Hopper",   @"year": @1906 },
                       @{ @"first": @"Ada",       @"last": @"Lovelace", @"year": @1815 },
                       ];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:people
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];
    NSString *peopleStr = [[NSString alloc] initWithData:jsonData
                                                encoding:NSUTF8StringEncoding];
    JSValue *load = jsContext[@"loadPeopleFromJSON"];
    JSValue *loadRes = [load callWithArguments:@[peopleStr]];
    NSArray *peopleArr = [loadRes toArray];
    
    for (Person *person in peopleArr)
    {
        NSLog(@"person: %@ --- first name: %@", person, person.firstName);
    }
}


@end
