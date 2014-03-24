//
//  RCHTTPConnection.m
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCHTTPConnection.h"
#import "HTTPLogging.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;

@implementation RCHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
	HTTPLogTrace();
		
	if ([method isEqualToString:@"POST"]) {
		if ([path isEqualToString:@"/notepost.html"]) {
			return requestContentLength < (NSInteger)pow(2, 10);
		}
	}
	
	return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
		
	if([method isEqualToString:@"POST"]) {
		return YES;
	}
	
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	HTTPLogTrace();
	
	if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/notepost.html"]) {
		HTTPLogVerbose(@"%@[%p]: postContentLength: %qu", THIS_FILE, self, requestContentLength);
		
		NSString *postStr = nil;
		
		NSData *postData = [request body];
		if (postData)
		{
			postStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
		}
		
		HTTPLogVerbose(@"%@[%p]: postStr: %@", THIS_FILE, self, postStr);
		
		RCHTTPParams *params = [[RCHTTPParams alloc] initWithPostData:postData];
        [[RCDatabase sharedDatabase] addNote:[params.postDictionary valueForKey:@"note"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RCANoteHasBeenReceived" object:nil];
		NSData *response = nil;
        response = [[NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body><br /><center><h3>%@ Saved!<h3></center><body></html>", params.postString] dataUsingEncoding:NSUTF8StringEncoding];
		
		return [[HTTPDataResponse alloc] initWithData:response];
	}
	
	return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
	HTTPLogTrace();
	
	// If we supported large uploads,
	// we might use this method to create/open files, allocate memory, etc.
}

- (void)processBodyData:(NSData *)postDataChunk
{
	HTTPLogTrace();
	
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	BOOL result = [request appendData:postDataChunk];
	if (!result) {
		HTTPLogError(@"%@[%p]: %@ - Couldn't append bytes!", THIS_FILE, self, THIS_METHOD);
	}
}

@end
