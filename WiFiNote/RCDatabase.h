//
//  RCDatabase.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RCNote.h"

#define RCDBPath [RCToolKit pathInDocumentsWithFile:@"RCNoteModel.sqlite"]
#define RCDBTable @"RCNote"

@interface RCDatabase : NSObject

@property(nonatomic) NSManagedObjectModel *managedObjectModel;
@property(nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)launch;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (void)addNote:(NSString *)note;
- (NSArray *)queryWithKey:(NSString *)key;
- (void)updateNote:(RCNote *)note;
- (void)deleteNote:(RCNote *)note;

+ (RCDatabase *)sharedDatabase;

@end
