//
//  OPAYDef.h
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const url_for_single_user_token_Test;
extern NSString * const url_for_single_user_token_Prod;


static NSString *merchantIdentifier;
static NSString *merchantAccountNo;
static NSString *merchantUserID;
static NSString *merchantPassword;
static NSDictionary *responseData;
static NSString *countryCode;
static NSString *currencyCode;
static NSString *timeInterval;
static NSString *envType;
static NSString *enrollmentID;

@interface PaySafeDef : NSObject

@property(assign)NSString *merchantPassword;
@property (nonatomic, copy) NSString *optimalSIngleTokenURL;

+(void)OPAYLog:(NSString*)functionName returnMessage:(id)message;

+ (NSString*) merchantUserID;
+ (void) setMerchantUserID:(NSString*)value;

+ (NSString*) merchantAccountNo;
+ (void) setMerchantAccountNo:(NSString*)value;

+ (NSString*) merchantPassword;
+ (void) setMerchantPassword:(NSString*)value;

+ (NSDictionary*) responseData;
+ (void) setResponseData:(NSDictionary*)value;

+ (NSString*) merchantIdentifier;
+ (void) setMerchantIdentifier:(NSString*)value;

+ (NSString*) countryCode;
+ (void) setCountryCode:(NSString*)value;

+ (NSString*) currencyCode;
+ (void) setCurrencyCode:(NSString*)value;

+ (NSString*) timeInterval;
+ (void) setTimeInterval:(NSString*)value;

+ (NSString*) envType;
+ (void) setEnvType:(NSString*)value;

+ (NSString*) enrollmentID;
+ (void) setEnrollmentID:(NSString*)value;

+(NSString*)getOptimalUrl;

@end
