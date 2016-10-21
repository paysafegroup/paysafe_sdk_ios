//
//  OPAYMockPayment.h
//
//  Created by sachin on 26/02/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@class PKPaymentRequest;

@interface PaySafeMockPayment : NSObject

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest;

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier;
@end

#endif