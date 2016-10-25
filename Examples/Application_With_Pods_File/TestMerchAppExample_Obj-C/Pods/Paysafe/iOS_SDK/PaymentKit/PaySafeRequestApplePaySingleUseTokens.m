//
//  OPAYRequestApplePaySingleUseTokens.m
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import "PaySafeRequestApplePaySingleUseTokens.h"
#import "PaySafeApplePayPaymentTokenInfo.h"


@implementation PaySafeRequestApplePaySingleUseTokens
@synthesize tokenInfo;

-(id)prepareRequestRealToken:(NSData*)tokenData
{
    id request = [NSMutableDictionary dictionary];
    
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:tokenData options:NSJSONReadingMutableContainers error:nil];
    
    [request setObject:dict forKey:@"applePayPaymentToken"];
    
    
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:request options:NSUTF8StringEncoding error:&jsonSerializationError];
    
    return jsonData;
}

@end
