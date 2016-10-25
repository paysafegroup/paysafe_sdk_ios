//
//  OPAYMockApplePayDef.m
//  Created by sachin on 26/02/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//

#import "PaySafeMockApplePayDef.h"

#define LOG_ON 1
#define LOG_OFF 2

#undef IS_LOG_ENABLE
#define IS_LOG_ENABLE LOG_OFF


@implementation PaySafeMockApplePayDef

NSString * const url_single_user_token = @"https://api.test.paysafe.com/customervault/v1/applepaysingleusetokens";
NSString * const url_fake_apple_token = @"https://api.test.paysafe.com/customervault/v1/applepaysingleusetokens/faketoken/simple";

+ (NSString*) merchantUserID {
    return merchantUserID;
}

+ (void) setMerchantUserID:(NSString*)value
{
    merchantUserID = value;
}

+ (NSString*) merchantPassword{
    return merchantPassword;
}

+ (void) setMerchantPassword:(NSString*)value
{
    merchantPassword = value;
}

+ (NSDictionary*) responseData
{
    return responseData;
}

+ (void) setResponseData:(NSDictionary*)value
{
    responseData=value;
}

+ (NSString*) merchantIdentifier
{
    return merchantIdentifier;
}

+ (void) setMerchantIdentifier:(NSString*)value
{
    merchantIdentifier=value;
}

+ (NSString*) countryCode{
    return countryCode;
}

+ (void) setCountryCode:(NSString*)value{
    countryCode=value;
}

+ (NSString*) currencyCode{
    return currencyCode;
}

+ (void) setCurrencyCode:(NSString*)value{
    currencyCode=value;
}

+ (NSString*) selectedCardNumber
{
    return selectedCardNumber;
}

+ (void) setSelectedCardNumber:(NSString*)value
{
    selectedCardNumber=value;
}

+(void)OPAYLog:(NSString*)functionName returnMessage:(id)message;
{
#if (IS_LOG_ENABLE == LOG_ON)
    
    NSLog(@"OPAY Log::Key::%@ ||Value::%@",functionName,message);
    
#endif
}

@end
