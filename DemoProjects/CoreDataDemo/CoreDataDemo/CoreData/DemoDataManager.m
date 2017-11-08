//
//  DemoDataManager.m
//  CoreDataDemo
//
//  Created by JiangWang on 10/07/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#import "DemoDataManager.h"
#import <CoreData/CoreData.h>
#import "DemoEmployee+CoreDataProperties.h"


@interface DemoDataManager()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@end

@implementation DemoDataManager

#pragma mark - Initialization 
+ (instancetype)sharedManager {
    static DemoDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DemoDataManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"DeomDataModel"
                                                   withExtension:@"momd"];
        NSManagedObjectModel *managedModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
        _managedObjectModel = managedModel;
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataStorePath =  [documentPath stringByAppendingPathComponent:@"data.sqlite"];
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:[NSURL fileURLWithPath:dataStorePath]
                                        options:nil
                                          error:nil];
        _storeCoordinator = coordinator;
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return self;
}

#pragma mark - Data Access
- (void)testEmployeeInsertion {
    DemoEmployee *demoEmployee =
    [NSEntityDescription insertNewObjectForEntityForName:@"DemoEmployee"
                                  inManagedObjectContext:self.managedObjectContext];
    demoEmployee.name = @"JIANG WANG";
    demoEmployee.height = 164;
    demoEmployee.sectionName = @"iOS Department";
    NSError *insertionError = nil;
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:&insertionError];
    }
    if (insertionError) {
        NSLog(@"insertion error: %@", insertionError);
    }
}

- (void)testEmployeeRequest {
    NSFetchRequest *employeeFetch = [NSFetchRequest fetchRequestWithEntityName:@"DemoEmployee"];
    NSPredicate *requestPredicate = [NSPredicate predicateWithFormat:@"name = %@", @"JIANG WANG"];
    employeeFetch.predicate = requestPredicate;
    NSError *fetchError = nil;
    NSArray<DemoEmployee *> *employees = [self.managedObjectContext executeFetchRequest:employeeFetch
                                                                                  error:&fetchError];
    [employees enumerateObjectsUsingBlock:
     ^(DemoEmployee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"fetched employee's name: %@", obj.name);
    }];
}


@end
