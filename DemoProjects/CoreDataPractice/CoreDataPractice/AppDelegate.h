//
//  AppDelegate.h
//  CoreDataPractice
//
//  Created by JiangWang on 02/10/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

