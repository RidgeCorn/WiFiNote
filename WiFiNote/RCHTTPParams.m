//
//  RCHTTPParams.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCHTTPParams.h"

@implementation RCHTTPParams

- (id)initWithPostData:(NSData *)postData {
    self = [super init];

    if (self) {
        _postData = postData;
        [self parsePostDataToDictionary];
    }
    
    return self;
}

- (void)parsePostDataToDictionary {
    if (_postData) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        NSString *postString = [[NSString alloc] initWithData:_postData encoding:NSUTF8StringEncoding];
        _postString = [postString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *keyValues = [_postString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValue in keyValues) {
            NSArray *param = [keyValue componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                [params setObject:param[1] forKey:param[0]];
            }
        }
        
        _postDictionary = [NSDictionary dictionaryWithDictionary:params];
    }
}

@end
