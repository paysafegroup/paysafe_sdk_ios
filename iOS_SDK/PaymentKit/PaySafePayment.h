//
//  OPAYPayment.h
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@class PKPaymentRequest;

@interface PaySafePayment : NSObject

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest;

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier;



@end
