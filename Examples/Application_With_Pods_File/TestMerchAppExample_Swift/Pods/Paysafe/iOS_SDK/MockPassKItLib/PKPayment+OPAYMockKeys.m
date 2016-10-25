//
//  PKPayment+OPAYMockKeys.m
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import "PKPayment+OPAYMockKeys.h"
#import <objc/runtime.h>

NSString *const OPTSuccessfulChargeCardNumber = @"4111111111111111";
NSString *const OPTFailingChargeCardNumber =    @"4000000000000002";

@implementation PKPayment (OPAYMockKeys)
@dynamic opt_testCardNumber;

- (void)setOpt_testCardNumber:(NSString *)opt_testCardNumber {
    objc_setAssociatedObject(self, @selector(opt_testCardNumber), opt_testCardNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)opt_testCardNumber {
    return objc_getAssociatedObject(self, @selector(opt_testCardNumber));
}
@end

#endif