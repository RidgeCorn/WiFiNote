//
//  RCDatabase.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCDatabase.h"

@implementation RCDatabase

+ (void)checkDatabase {
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:RCDBPath]) {
        FMDatabase *db = [FMDatabase databaseWithPath:RCDBPath];
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"create table %@ (note text)", RCDBTable]];
        [db close];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:RCDBPath];
    [db open];
    if ( ![db tableExists:RCDBTable]) {
        [db executeUpdate:[NSString stringWithFormat:@"create table %@ (note text)", RCDBTable]];
    }
    [db close];
}

+ (void)insertNote:(NSString *)note {
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:RCDBPath]) {
        [self checkDatabase];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:RCDBPath];
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"insert into %@ values ('%@')",RCDBTable , note]];
    [db close];
}

+ (NSArray *)selectAll {
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:RCDBPath]) {
        [self checkDatabase];
    }
    
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:RCDBPath];

    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@", RCDBTable]];
    
    while ([rs next]) {
        [notes insertObject:[rs stringForColumn:@"note"] atIndex:0];
    }
    [rs close];
    [db close];
    
    return notes;
}
@end
