//
//  OPAYApplePayPaymentTokenInfo.h
//  
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *version;
static NSString *data;
static NSString *signature;
static NSString *transactionId;
static NSString *ephemeralPublicKey;
static NSString *publicKeyHash;


@interface PaySafeApplePayPaymentTokenInfo : NSObject

+(NSString*) data;
+(void) setData:(NSString*)value;

+ (NSString*) version;
+ (void) setVersion:(NSString*)value;

+ (NSString*) signature;
+ (void) setSignature:(NSString*)value;

+ (NSString*) transactionId;
+ (void) setTransactionId:(NSString*)value;

+ (NSString*) ephemeralPublicKey;
+ (void) setEphemeralPublicKey:(NSString*)value;

+(NSString*) publicKeyHash;
+(void) setPublicKeyHash:(NSString*)value;
@end
