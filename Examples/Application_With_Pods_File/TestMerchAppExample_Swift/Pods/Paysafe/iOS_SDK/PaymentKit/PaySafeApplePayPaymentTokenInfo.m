//
//  OPAYApplePayPaymentTokenInfo.m
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import "PaySafeApplePayPaymentTokenInfo.h"

@implementation PaySafeApplePayPaymentTokenInfo


- (id)init
{
    return self;
}

+(NSString*) data {
    return data;
}

+ (void) setData:(NSString*)value
{
    data = value;
}

+ (NSString*) version
{
    return version;
}

+ (void) setVersion:(NSString*)value{
    version=value;
}

+ (NSString*) signature
{
    return signature;
}

+ (void) setSignature:(NSString*)value
{
    signature=value;
}

+(NSString*) transactionId
{
    return transactionId;
}

+ (void) setTransactionId:(NSString*)value
{
    transactionId=value;
}

+(NSString*) ephemeralPublicKey
{
    return ephemeralPublicKey;
}

+ (void) setEphemeralPublicKey:(NSString*)value
{
    ephemeralPublicKey=value;
}

+(NSString*) publicKeyHash
{
    return publicKeyHash;
}

+(void) setPublicKeyHash:(NSString*)value
{
    publicKeyHash=value;
}

@end
