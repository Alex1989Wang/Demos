//
//  INSEarthquakeOperationsProvider.m
//  INSOperationsKit Demo
//
//  Created by Michal Zaborowski on 09.09.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import "INSiOSEarthquakeOperationsProvider.h"
#import "INSDownloadOperation.h"
#import "INSOperationQueue.h"
#import "INSChainOperation.h"
#import "INSParseOperation.h"
#import "INSEarthquake.h"
#import "INSCoreDataStack.h"
#import "INSAlertOperation.h"

@implementation INSiOSEarthquakeOperationsProvider

+ (INSChainOperation *)getAllEarthquakesWithCompletionHandler:(void (^)(INSChainOperation *operation, NSError *error))completionHandler {
    INSDownloadOperation *downloadOperation = [[INSDownloadOperation alloc] initWithURL:[NSURL URLWithString:@"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson"] responseFiltering:^id(id responseObject) {
        return responseObject[@"features"];
    }];
    
    INSParseOperation *parseOperation = [[INSParseOperation alloc] initWithParsableClass:[INSEarthquake class] context:[[INSCoreDataStack sharedInstance] createPrivateContextWithMainQueueParent]];
    
    __block INSChainOperation *chainOperation = [INSChainOperation operationWithOperations:@[downloadOperation,parseOperation]];
    [chainOperation ins_addCompletionBlockInMainQueue:^(INSOperation *operation){
        NSError *error = [chainOperation.internalErrors firstObject];
        if (completionHandler) {
            completionHandler(chainOperation, error);
        }
        if (error) {
            INSAlertOperation *alertOperation = [INSAlertOperation alertOperationWithPresentationContext:nil];
            alertOperation.title = @"Error";
            alertOperation.message = error.localizedDescription;
            [chainOperation produceOperation:alertOperation];
        }
    }];
    return chainOperation;
}


+ (INSMoreInformationOperation *)moreInformationForEarthquake:(INSEarthquake *)earthquake completionHandler:(void (^)(INSMoreInformationOperation *operation))completionHandler {
    __block INSMoreInformationOperation *operation = [[INSMoreInformationOperation alloc] initWithURL:[NSURL URLWithString:earthquake.webLink] presentationContext:nil];
    
    [operation ins_addCompletionBlockInMainQueue:^(INSOperation *op){
        if (completionHandler) {
            completionHandler(operation);
        }
    }];
    return operation;
}

@end
