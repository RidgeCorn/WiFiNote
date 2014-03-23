//
//  RCAppDelegate.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCAppDelegate.h"
#import <DDLog.h>
#import <DDTTYLogger.h>

@implementation RCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    [RCDatabase checkDatabase];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[RCHTTPServer sharedServer] startServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[RCHTTPServer sharedServer] stopServer];
}
@end
