//
//  OPAYMockCardStore.m
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import "PaySafeMockCardStore.h"

@interface PaySafeMockCardStore ()
@property (nonatomic) NSArray *allItems;
@end

@implementation PaySafeMockCardStore

@synthesize selectedItem;

+ (NSDictionary *)defaultCard {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Optimal Test Card";
    card[@"number"] = @"4111111111111111";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2031;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard1 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Visa Test Card";
    card[@"number"] = @"4530910000012345";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard2 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Visa Electron";
    card[@"number"] = @"4917480000000008";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard3 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"MasterCard Debit (Maestro)";
    card[@"number"] = @"6759950000000162";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard4 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"MasterCard";
    card[@"number"] = @"5191330000004415";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard5 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"American Express";
    card[@"number"] = @"370123456789017";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}

+ (NSDictionary *)testCard6 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Discover";
    card[@"number"] = @"6011234567890123";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}
+ (NSDictionary *)testCard7 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"Laser";
    card[@"number"] = @"6706952343050001237";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}
+ (NSDictionary *)testCard8 {
    NSMutableDictionary *card = [NSMutableDictionary new];
    card[@"name"] = @"JCB";
    card[@"number"] = @"3569990000000009";
    card[@"expMonth"] = @12;
    card[@"expYear"] = @2030;
    card[@"cvc"] = @"123";
    return [card copy];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.allItems = @[[self.class defaultCard], [self.class testCard1],[self.class testCard2],[self.class testCard3],[self.class testCard4],[self.class testCard5],[self.class testCard6],[self.class testCard7],[self.class testCard8]];
        self.selectedItem = self.allItems[0];
    }
    return self;
}

- (NSArray *)descriptionsForItem:(id)item {
    NSDictionary *card = (NSDictionary *)item;
    NSString *number = card[@"number"];
    NSString *suffix = [number substringFromIndex:MAX((NSInteger)[number length] - 4, 0)];
    return @[card[@"name"], [NSString stringWithFormat:@"**** **** **** %@", suffix]];
}

@end
#endif

