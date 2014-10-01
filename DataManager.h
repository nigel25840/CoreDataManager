//
//  DataManager.h
//  RiverLog
//
//  Created by Philip Townsend on 9/29/14.
//  Copyright (c) 2014 Elliptio, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(DataManager*)sharedInstance;
-(BOOL)save;

@end
