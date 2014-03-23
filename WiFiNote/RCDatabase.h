//
//  RCDatabase.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>

#define RCDBPath [RCToolKit pathInDocumentsWithFile:@"/notebooks.db"]
#define RCDBTable @"notebook"

@interface RCDatabase : NSObject

+ (void)checkDatabase;
+ (void)insertNote:(NSString *)note;
+ (NSArray *)selectAll;

@end
