//
//  OPAYMockShippingManager.h
//
//  Created by sachin on 22/01/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@interface PaySafeMockShippingManager : NSObject

- (NSArray *)defaultShippingMethods;
- (void)fetchShippingCostsForAddress:(ABRecordRef)address completion:(void (^)(NSArray *shippingMethods, NSError *error))completion;

@end
