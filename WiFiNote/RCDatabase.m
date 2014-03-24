//
//  RCDatabase.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCDatabase.h"

static RCDatabase *SharedDatabase;

@implementation RCDatabase

- (void)launch {
    [self managedObjectModel];
    [self persistentStoreCoordinator];
    [self managedObjectContext];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:RCDBPath];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        DDLogError(@"Error: %@,%@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (void)addNote:(NSString *)noteString {
    
    RCNote *note = (RCNote *)[NSEntityDescription insertNewObjectForEntityForName:RCDBTable inManagedObjectContext:_managedObjectContext];
    
    [note setContent:noteString];
    [note setTimes:@0];
    [note setDate:[NSDate date]];
    
    NSError *error;
    
    BOOL isSaveSuccess = [_managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        DDLogError(@"Error: %@,%@", error, [error userInfo]);
    }else {
        DDLogInfo(@"Save successful!");
    }
}

- (NSArray *)queryWithKey:(NSString *)key {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *note = [NSEntityDescription entityForName:RCDBTable inManagedObjectContext:_managedObjectContext];

    [request setEntity:note];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;

    NSMutableArray *mutableFetchResult = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        DDLogError(@"Error: %@,%@", error, [error userInfo]);
    }
    
    DDLogInfo(@"The count of entry:%i", [mutableFetchResult count]);
    
    for (RCNote *note in mutableFetchResult) {
        DDLogInfo(@"Content:%@---Date:%@Times:%@---", note.content, note.date, note.times);
    }
    
    return mutableFetchResult;
}

- (void)updateNote:(RCNote *)note {
    NSError *error;
    BOOL isUpdateSuccess = [_managedObjectContext save:&error ];
    
    if ( !isUpdateSuccess) {
        DDLogError(@"Error:%@,%@", error, [error userInfo]);
    }
}

- (void)deleteNote:(RCNote *)note {
    [_managedObjectContext deleteObject:note];
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        DDLogError(@"Error:%@,%@", error, [error userInfo]);
    }
}

+ (RCDatabase *)sharedDatabase {
    @synchronized(self) {
        if (!SharedDatabase) {
            SharedDatabase  = [[RCDatabase alloc] init];
        }
    }
    return SharedDatabase;
}
@end
