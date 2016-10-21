//
//  OPAYRequestApplePaySingleUseTokens.h
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaySafeApplePayPaymentTokenInfo.h"

@interface PaySafeRequestApplePaySingleUseTokens : NSObject


@property(retain)PaySafeApplePayPaymentTokenInfo *tokenInfo;

-(id)prepareRequestRealToken:(NSData*)tokenData;


@end
