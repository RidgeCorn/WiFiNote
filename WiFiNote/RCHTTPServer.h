//
//  RCHTTPServer.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "HTTPServer.h"
#import "RCHTTPConnection.h"
#import <DDLog.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface RCHTTPServer : HTTPServer
@property (nonatomic) NSString *serverURL;

- (void)startServer;
- (void)stopServer;

+ (RCHTTPServer *)sharedServer;

@end
