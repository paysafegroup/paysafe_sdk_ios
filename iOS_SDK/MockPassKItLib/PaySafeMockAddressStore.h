//
//  OPAYMockAddressStore.h
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <Foundation/Foundation.h>
#import "PaySafeMockDataStore.h"
#import <AddressBook/AddressBook.h>

@interface PaySafeMockAddressStore : NSObject <PaySafeMockDataStore>

- (ABRecordRef)contactForSelectedItemObscure:(BOOL)obscure;
@end

#endif