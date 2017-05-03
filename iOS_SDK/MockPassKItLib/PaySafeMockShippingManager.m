//
//  OPAYMockShippingManager.m
//
//  Created by sachin on 22/01/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//

#import "PaySafeMockShippingManager.h"
#import <PassKit/PassKit.h>

@implementation PaySafeMockShippingManager


- (NSArray *)defaultShippingMethods {
    return [self californiaShippingMethods];
}

- (void)fetchShippingCostsForAddress:(CNContact *)address completion:(void (^)(NSArray *shippingMethods, NSError *error))completion {
    
    // you could, for example, go to UPS here and calculate shipping costs to that address.
    NSArray *addresses = address.postalAddresses;
    
    NSString *state;
    
    if (addresses.count > 0) {
        
        CNPostalAddress *postalAddress = [addresses objectAtIndex:0];
        
        state = postalAddress.state;
        postalAddress = nil;
    }
    
    if (!state) {
        completion(nil, [NSError new]);
    }
    if ([state isEqualToString:@"CA"]) {
        completion([self californiaShippingMethods], nil);
    } else {
        completion([self internationalShippingMethods], nil);
    }
    
    addresses = nil;
    state = nil;
    
    //CFRelease(addressValues);
}


- (NSArray *)californiaShippingMethods {
    PKShippingMethod *normalItem =[PKShippingMethod summaryItemWithLabel:@"Llama California Shipping" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    normalItem.detail = @"3-5 Business Days";
    normalItem.identifier = normalItem.label;
    PKShippingMethod *expressItem =
    [PKShippingMethod summaryItemWithLabel:@"Llama California Express Shipping" amount:[NSDecimalNumber decimalNumberWithString:@"30.00"]];
    expressItem.detail = @"Next Day";
    expressItem.identifier = expressItem.label;
    return @[normalItem, expressItem];
}

- (NSArray *)internationalShippingMethods {
    PKShippingMethod *normalItem = [PKShippingMethod summaryItemWithLabel:@"Llama US Shipping" amount:[NSDecimalNumber decimalNumberWithString:@"40.00"]];
    normalItem.detail = @"3-5 Business Days";
    normalItem.identifier = normalItem.label;
    PKShippingMethod *expressItem =
    [PKShippingMethod summaryItemWithLabel:@"Llama US Express Shipping" amount:[NSDecimalNumber decimalNumberWithString:@"50.00"]];
    expressItem.detail = @"Next Day";
    expressItem.identifier = expressItem.label;
    return @[normalItem, expressItem];
}

@end
