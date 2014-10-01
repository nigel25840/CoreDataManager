//
//  DataManager.m
//  RiverLog
//
//  Created by Philip Townsend on 9/29/14.
//  Copyright (c) 2014 Elliptio, LLC. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>

@implementation DataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static NSString *kDataStoreName = @"RiverLogModel";

#pragma mark - Global Instance

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Context, Object Model, Persistent Store Coordinator

// create an instance of the managed object context
-(NSManagedObjectContext*)managedObjectContext{
    // if the MOC does not already exist, create it
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    // otherwise get an instance through the persistent store coordinator
    NSPersistentStoreCoordinator *psc = [self persistentStoreCoordinator];
    if(psc){
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:psc];
    }
    return _managedObjectContext;
}

// get the managed object model
-(NSManagedObjectModel*)managedObjectModel{
    if(_managedObjectModel){
        return _managedObjectModel;
    }
    NSURL *modelFileLocation = [[NSBundle mainBundle] URLForResource:kDataStoreName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelFileLocation];
    return _managedObjectModel;
}

// get a reference to the persistent store coordinator
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    if(_persistentStoreCoordinator){
        return _persistentStoreCoordinator;
    }
    NSString *dataStoreFileName = [NSString stringWithFormat:@"%@.sqlite", kDataStoreName];
    NSURL *dataStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataStoreFileName];
    
    NSError *err = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dataStoreURL options:nil error:&err]){
        NSLog(@"CORE DATA ERROR: \n%@: \n%@: \n%@", err, [err description], [err userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Actions

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(BOOL)save{
    NSError *err = nil;
    [_managedObjectContext save:&err];
    if(err){
        NSLog(@"An ERROR occured while wirting to Core Data: %@", [err description]);
        return NO;
    }
    return YES;
}

#pragma mark - Utility Functions

-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
