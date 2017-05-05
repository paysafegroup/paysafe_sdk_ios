//
// OPAYMockAddressStore.m
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import "PaySafeMockAddressStore.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface PaySafeMockAddressStore()
@property (nonatomic) NSArray *allItems;

@end

@implementation PaySafeMockAddressStore
@synthesize selectedItem;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allItems = @[
                          @{
                              @"name": @"Apple HQ",
                              @"line1": @"1 Infinite Loop",
                              @"line2": @"",
                              @"city": @"Cupertino",
                              @"state": @"CA",
                              @"zip": @"95014",
                              @"country": @"US",
                              @"phone": @"888 555-1212",
                              },
                          @{
                              @"name": @"The White House",
                              @"line1": @"1600 Pennsylvania Ave NW",
                              @"line2": @"",
                              @"city": @"Washington",
                              @"state": @"DC",
                              @"zip": @"20500",
                              @"country": @"US",
                              @"phone": @"888 867-5309",
                              },
                          @{
                              @"name": @"Buckingham Palace",
                              @"line1": @"SW1A 1AA",
                              @"line2": @"",
                              @"city": @"London",
                              @"state": @"",
                              @"zip": @"",
                              @"country": @"UK",
                              @"phone": @"07 987 654 321",
                              },
                          ];
        self.selectedItem = self.allItems[0];
    }
    return self;
}

- (NSArray *)descriptionsForItem:(id)item {
    return @[item[@"name"], item[@"line1"]];
}

- (CNContact *)contactForSelectedItemObscure:(BOOL)obscure {
    
    id item = self.selectedItem;
    CNMutableContact *mutableContact = [[CNMutableContact alloc]init];
    
    // address
    CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc] init];
    
    if (!obscure) {
        postalAddress.street = (__bridge NSString * _Nonnull)(CFBridgingRetain(item[@"line1"]));
    }
    postalAddress.city = (__bridge NSString * _Nonnull)(CFBridgingRetain(item[@"city"]));
    postalAddress.state = (__bridge NSString * _Nonnull)(CFBridgingRetain(item[@"state"]));
    postalAddress.postalCode = (__bridge NSString * _Nonnull)(CFBridgingRetain(item[@"zip"]));
    postalAddress.country = (__bridge NSString * _Nonnull)(CFBridgingRetain(item[@"country"]));
    
    CNLabeledValue *address = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:postalAddress];
    mutableContact.postalAddresses = @[address];
    
    // add zip and country fields
    if (!obscure) {
        
        NSString *firstName = [self.selectedItem[@"name"] componentsSeparatedByString:@" "].firstObject;
        NSString *lastName = [self.selectedItem[@"name"] componentsSeparatedByString:@" "].lastObject;
        
        mutableContact.givenName = firstName;
        mutableContact.familyName = lastName;
        
        // phone
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc]init];
        NSString *phNumber = self.selectedItem[@"phone"];
        CNLabeledValue *contactNumber;
        
        contactNumber = [[CNLabeledValue alloc]initWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:phNumber]]; phNumber = nil;
        [phoneNumbers addObject:contactNumber];
        contactNumber = nil;
        mutableContact.phoneNumbers =  phoneNumbers;
    
        //email
        NSMutableArray *emailAddresses = [[NSMutableArray alloc]initWithCapacity:0];
        NSString *email = self.selectedItem[@"email"];
        if (email) {
            CNLabeledValue *emailAddress = [[CNLabeledValue alloc]initWithLabel:CNLabelHome value:email]; email = nil;
            [emailAddresses addObject:emailAddress]; emailAddress = nil;
            mutableContact.emailAddresses = emailAddresses;
        }
        
    }
    
    return mutableContact;
    
} 
 
@end

#endif
