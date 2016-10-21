//
//  OPAYMockShippingMethodStore.m
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#import "PaySafeMockShippingMethodStore.h"
#import <PassKit/PassKit.h>

@interface PaySafeMockShippingMethodStore()
@property(nonatomic)NSArray *shippingMethods;
@end

@implementation PaySafeMockShippingMethodStore
@synthesize selectedItem;

- (instancetype)initWithShippingMethods:(NSArray *)shippingMethods {
    self = [super init];
    if (self) {
        [self setShippingMethods:shippingMethods];
    }
    return self;
}

- (NSArray *)allItems {
    return self.shippingMethods;
}

- (NSArray *)descriptionsForItem:(id)item {
    PKShippingMethod *method = (PKShippingMethod *)item;
    return @[method.label, method.amount.stringValue];
}

- (void)setShippingMethods:(NSArray *)shippingMethods {
    _shippingMethods = shippingMethods;
    for (PKShippingMethod *method in shippingMethods) {
        if ([self.selectedItem isEqual:method]) {
            self.selectedItem = method;
            return;
        }
    }
    self.selectedItem = shippingMethods[0];
}


@end

#endif
