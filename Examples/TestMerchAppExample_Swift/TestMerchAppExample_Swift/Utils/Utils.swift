//
//  Utils.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 26/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

class Utils: NSObject {
    
    
    
    //*****************
    // Customer Vault
    //*****************
    
    //-----------------Profile ID-------------------
    class func setProfileID(_ strProfileID:String)
    {
    defaults.set(strProfileID, forKey:keyProfileID)
    defaults.synchronize()
    }

    class func getProfileID() -> AnyObject!
    {
    return defaults.object(forKey: keyProfileID) as AnyObject!
    }
    
    class func deleteProfileID()
    {
        defaults.removeObject(forKey: keyProfileID)
        defaults.synchronize()
    }
    
    //-----------------Address ID-------------------
    
    class func setMerchantCustomerID(_ strMerchantID:String)
    {
        defaults.set(strMerchantID, forKey:keyMerchantCustomerID)
        defaults.synchronize()
    }
    class func getMerchantCustomerID() -> AnyObject!
    {
        return defaults.object(forKey: keyMerchantCustomerID) as AnyObject!
    }
    class func deleteMerchantCustomerID()
    {
        defaults.removeObject(forKey: keyMerchantCustomerID)
        defaults.synchronize()
    }
    //-----------------Address ID-------------------
    class func  setAddressID(_ strAddressID:String)
    {
    defaults.set(strAddressID, forKey:keyAddressID)
    defaults.synchronize()
    }
    
    class func getAddressID() -> AnyObject!
    {
    return defaults.object(forKey: keyAddressID) as AnyObject!
    }
    
    class func  deleteAddressID()
    {
        defaults.removeObject(forKey: keyAddressID)
        defaults.synchronize()
    }
    
    //*****************
    // Account ID's
    //*****************
   
    //--------------------------------------------------------
    class func setACH_AccountID(_ strAccountID:String)
    {
      defaults.set(strAccountID, forKey:keyACH_AccountID)
         defaults.synchronize()
    }
    class func getACH_AccountID() -> AnyObject!
    {
     return defaults.object(forKey: keyACH_AccountID) as AnyObject!
    }
    class func deleteACH_AccountID()
    {
        defaults.removeObject(forKey: keyACH_AccountID)
        defaults.synchronize()
    }
    //--------------------------------------------------------
    class func setBACS_AccountID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyBACS_AccountID)
         defaults.synchronize()
    }
    class func getBACS_AccountID() -> AnyObject!
    {
        return defaults.object(forKey: keyBACS_AccountID) as AnyObject!
    }
    class func deleteBACS_AccountID() 
    {
        defaults.removeObject(forKey: keyBACS_AccountID)
        defaults.synchronize()
    }
    
    //--------------------------------------------------------
    class func setEFT_AccountID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyEFT_AccountID)
        defaults.synchronize()
    }
    class func getEFT_AccountID() -> AnyObject!
    {
        return defaults.object(forKey: keyEFT_AccountID) as AnyObject!
    }
    class func deleteEFT_AccountID() 
    {
        defaults.removeObject(forKey: keyEFT_AccountID)
        defaults.synchronize()
    }
    
    //--------------------------------------------------------
    class func setSEPA_AccountID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keySEPA_AccountID)
         defaults.synchronize()
    }
    class func getSEPA_AccountID() -> AnyObject!
    {
        return defaults.object(forKey: keySEPA_AccountID) as AnyObject!
    }
    class func deleteSEPA_AccountID() 
    {
        defaults.removeObject(forKey: keySEPA_AccountID)
        defaults.synchronize()
    }
    //-----------------Account PaymentToken-------------------
   class func  setACH_PaymentToken (_ strPaymentToken:String)
    {
        defaults.set(strPaymentToken, forKey:keyACH_PaymentToken)
        defaults.synchronize()
    }
    
    class func getACH_PaymentToken() -> AnyObject!
    {
        return defaults.object(forKey: keyACH_PaymentToken) as AnyObject!
    }
    
    class func setBACS_PaymentToken(_ strPaymentToken:String)
    {
        defaults.set(strPaymentToken, forKey:keyBACS_PaymentToken)
        defaults.synchronize()
    }
    
     class func getBACS_PaymentToken() -> AnyObject!
    {
        return defaults.object(forKey: keyBACS_PaymentToken) as AnyObject!
    }
    
     class func setEFT_PaymentToken(_ strPaymentToken:String)
    {
        defaults.set(strPaymentToken, forKey:keyEFT_PaymentToken)
        defaults.synchronize()
    }
    
     class func getEFT_PaymentToken() -> AnyObject!
    {
        return defaults.object(forKey: keyEFT_PaymentToken) as AnyObject!
    }
    
     class func setSEPA_PaymentToken(_ strPaymentToken:String)
    {
        defaults.set(strPaymentToken, forKey:keySEPA_PaymentToken)
        defaults.synchronize()
    }
    
     class func getSEPA_PaymentToken() -> AnyObject!
    {
        return defaults.object(forKey: keySEPA_PaymentToken) as AnyObject!
    }

    //*****************
    // Account Numbers 
    //*****************
    class func setACH_AccountNO(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyACH_AccountNo)
        defaults.synchronize()
    }
    class func getACH_AccountNo() -> AnyObject!
    {
        return defaults.object(forKey: keyACH_AccountNo) as AnyObject!
    }
    
    
    class func setEFT_AccountNO(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyEFT_AccountNo)
        defaults.synchronize()
    }
    class func getEFT_AccountNo() -> AnyObject!
    {
        return defaults.object(forKey: keyEFT_AccountNo) as AnyObject!
    }

    class func setBACS_AccountNO(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyBACS_AccountNo)
        defaults.synchronize()
    }
    class func getBACS_AccountNo() -> AnyObject!
    {
        return defaults.object(forKey: keyBACS_AccountNo) as AnyObject!
    }

    
    class func setSEPA_AccountNO(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keySEPA_AccountNo)
        defaults.synchronize()
    }
    class func getSEPA_AccountNo() -> AnyObject!
    {
        return defaults.object(forKey: keySEPA_AccountNo) as AnyObject!
    }


    
    
    //*****************
    // Purchases ID's
    //*****************
    
    //--------------------------------------------------------
    class func setACH_PurchaseID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyACH_PurchaseID)
         defaults.synchronize()
    }
    class func getACH_PurchaseID() -> AnyObject!
    {
        return defaults.object(forKey: keyACH_PurchaseID) as AnyObject!
    }
    
    //--------------------------------------------------------
    class func setBACS_PurchaseID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyBACS_PurchaseID)
         defaults.synchronize()
    }
    class func getBACS_PurchaseID() -> AnyObject!
    {
        return defaults.object(forKey: keyBACS_PurchaseID) as AnyObject!
    }
    
    //--------------------------------------------------------
    class func setEFT_PurchaseID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keyEFT_PurchaseID)
         defaults.synchronize()
    }
    class func getEFT_PurchaseID() -> AnyObject!
    {
        return defaults.object(forKey: keyEFT_PurchaseID) as AnyObject!
    }
    
    //--------------------------------------------------------
    class func setSEPA_PurchaseID(_ strAccountID:String)
    {
        defaults.set(strAccountID, forKey:keySEPA_PurchaseID)
         defaults.synchronize()
    }
    class func getSEPA_PurchaseID() -> AnyObject!
    {
        return defaults.object(forKey: keySEPA_PurchaseID) as AnyObject!
    }
        
    //--------------------------------------------------------
    
    func randomStringWithLength() -> NSString {
        let len = 13
        let letters : NSString = Letters as NSString
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    func randomNumberWithLength (_ strLenght:String) -> NSString {
        let len = 13
        let letters : NSString = Numbers as NSString
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }

}


