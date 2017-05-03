//
//  Utils.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 26/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

let defaults = NSUserDefaults.standardUserDefaults()

class Utils: NSObject {

    //--------------------------------------------------------
    
    func randomStringWithLength() -> NSString {
        let len = 13
        let letters : NSString = Letters
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func randomNumberWithLength (strLenght:String) -> NSString {
        let len = 13
        let letters : NSString = Numbers
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
}


