//
//  RCHTTPServer.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCHTTPServer.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

static RCHTTPServer *SharedServer;

@implementation RCHTTPServer

- (void)startServer {
	NSError *error;

	if([self start:&error]) {
        self.serverURL = [NSString stringWithFormat:@"http://%@:%hu/", [RCHTTPServer getIPAddress], [self listeningPort]];
		DDLogInfo(@"Started HTTP Server on %@", self.serverURL);
	} else {
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
}

- (void)stopServer {
    DDLogInfo(@"HTTP Server will stop on port %hu", [self listeningPort]);

    [self stop];
}

+ (RCHTTPServer *)sharedServer {
    @synchronized(self) {
        if (!SharedServer) {
            SharedServer  = [[RCHTTPServer alloc] init];
            
            [SharedServer setType:@"_http._tcp."];
            [SharedServer setPort:80];
            
            NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WWWROOT"];
            DDLogInfo(@"Setting document root: %@", webPath);
            
            [SharedServer setDocumentRoot:webPath];
            
            [SharedServer setConnectionClass:[RCHTTPConnection class]];
        }
    }
    return SharedServer;
}

//
//Refs http://zachwaugh.me/posts/programmatically-retrieving-ip-address-of-iphone/
//
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
@end
