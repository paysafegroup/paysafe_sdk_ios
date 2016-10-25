//
//  OPAYMockDataStore.h
//
//  Created by sachin on 23/02/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <Foundation/Foundation.h>

@protocol PaySafeMockDataStore  <NSObject>

@property(nonatomic) id selectedItem;
@property(nonatomic, readonly) NSArray *allItems;
- (NSArray *)descriptionsForItem:(id)item;

@end

#endif