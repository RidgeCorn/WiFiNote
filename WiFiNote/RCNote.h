//
//  RCNote.h
//  WiFiNote
//
//  Created by Looping on 14-3-24.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RCNote : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * times;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * update;

@end
