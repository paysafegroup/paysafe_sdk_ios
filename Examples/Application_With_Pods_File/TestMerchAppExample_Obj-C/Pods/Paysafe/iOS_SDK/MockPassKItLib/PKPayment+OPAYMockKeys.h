//
//  PKPayment+OPAYMockKeys.h
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <PassKit/PassKit.h>

extern NSString * const OPTSuccessfulChargeCardNumber;
extern NSString * const OPTFailingChargeCardNumber;

@interface PKPayment (OPAYMockKeys)
@property(nonatomic, strong) NSString *opt_testCardNumber;
@end



#endif