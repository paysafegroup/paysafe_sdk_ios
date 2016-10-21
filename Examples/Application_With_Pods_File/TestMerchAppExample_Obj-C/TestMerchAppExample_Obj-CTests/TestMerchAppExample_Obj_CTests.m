//
//  TestMerchAppExample_Obj_CTests.m
//  TestMerchAppExample_Obj-CTests
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 4/23/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface TestMerchAppExample_Obj_CTests : XCTestCase

@end

@implementation TestMerchAppExample_Obj_CTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
