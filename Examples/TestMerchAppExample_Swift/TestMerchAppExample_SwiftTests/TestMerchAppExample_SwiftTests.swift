//
//  TestMerchAppExample_SwiftTests.swift
//  TestMerchAppExample_SwiftTests
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 4/23/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import UIKit
import XCTest

class TestMerchAppExample_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEnrollmentProcess()
    {
        /*let filepath = NSBundle.mainBundle().pathForResource("MerchantRealConfiguration", ofType: "plist")
        //var myDictionary: NSDictionary?
        let myDictionary:NSDictionary! = NSDictionary.init(contentsOfFile: filepath!)
        
        let merchantAccountNo = myDictionary.objectForKey("merchantAccount") as! String
        
        self.accountIDTextField.text = merchantAccountNo
        
        let merchantPassword = myDictionary.objectForKey("MerchantPassword") as! String
        
        let appleMerchantIdentifier = myDictionary.objectForKey("MerchantID") as! String
        
        opayEnrollmentProcess = OPAYEnrollmentProcess(merchantAccountNo:merchantAccountNo,withMerchantID: appleMerchantIdentifier, withMerchantPwd: merchantPassword)
        opayEnrollmentProcess.enrollmentProcessDelegate = self*/
    }
}
