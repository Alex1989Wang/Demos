//
//  INSOSXEarthquakeOperationProvider.h
//  INSOperationsKit Demo
//
//  Created by Michal Zaborowski on 13.09.2015.
//  Copyright © 2015 Michal Zaborowski. All rights reserved.
//

#import <Foundation/Foundation.h>
@import INSOperationsKit;

@interface INSOSXEarthquakeOperationProvider : NSOperation
+ (INSChainOperation *)getAllEarthquakesWithCompletionHandler:(void (^)(INSChainOperation *operation, NSError *error))completionHandler;
@end
