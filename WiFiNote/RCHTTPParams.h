//
//  RCHTTPParams.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHTTPParams : NSObject
@property (nonatomic) NSData *postData;
@property (nonatomic) NSString *postString;
@property (nonatomic) NSDictionary *postDictionary;

- (id)initWithPostData:(NSData *)postData;
@end
