//
//  RCToolKit.h
//  WiFiNote
//
//  Created by Looping on 14-3-23.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface RCToolKit : NSObject

+ (float)systemVersion;
+ (float)fullScreenHeight;
+ (float)fullScreenWidth;
+ (BOOL)is4InchDevice;
+ (CGPoint)screenCenter;

+ (NSString *)bundleVersion;
+ (NSString *)shortBuildString;
+ (NSString *)versionString;
+ (NSString *)appScheme;
+ (NSString *)productDisplayName;

+ (CGFloat)calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(NSInteger)width;
+ (CGFloat)calculateTextWidth:(UIFont *)font givenText:(NSString *)text;

+ (BOOL)isZero:(CGFloat)value;

+ (NSString *)deviceUUID;

+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)pathInDocumentsWithFile:(NSString *)filename;

@end
