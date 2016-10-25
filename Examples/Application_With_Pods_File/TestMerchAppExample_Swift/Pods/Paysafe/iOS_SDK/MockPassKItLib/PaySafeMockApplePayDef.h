//
//  OPAYMockApplePayDef.h
//
//  Created by sachin on 26/02/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const url_single_user_token;
extern NSString * const url_fake_apple_token;

static NSString *merchantIdentifier;
static NSString *merchantUserID;
static NSString *merchantPassword;
static NSDictionary *responseData;
static NSString *countryCode;
static NSString *currencyCode;
static NSString *selectedCardNumber;

@interface PaySafeMockApplePayDef : NSObject


@property(assign)NSString *merchantPassword;

+(void)OPAYLog:(NSString*)functionName returnMessage:(id)message;

+ (NSString*) merchantUserID;
+ (void) setMerchantUserID:(NSString*)value;

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

+ (NSString*) selectedCardNumber;
+ (void) setSelectedCardNumber:(NSString*)value;

@end
