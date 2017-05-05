//
//  SubmitPurchaseViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class SubmitPurchaseViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate ,OPayPaymentPurchaseOperationsProcessDelegate {
    
    @IBOutlet var confirmBtn : UIButton!
    
    var opayPaymentPurchaseOperationsProcess: OPayPaymentPurchaseOperationsProcess!
    var titleString : String!
    var purchaseBankType : Int!
    
    @IBOutlet var bankAccountIDTextField:UITextField!
    @IBOutlet var merchantRefNumTextField:UITextField!
    @IBOutlet var amountTextField:UITextField!
    @IBOutlet var paymentToKenTextField:UITextField!
    @IBOutlet var paymentMethodTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    {
        if self.purchaseBankType == ACH_BANK_TYPE 
        {
            self.bankAccountIDTextField.text = ACH_MerchantAccount
            self.paymentToKenTextField.text = Utils.getACH_PaymentToken() as? String
        }
        else if self.purchaseBankType == BACS_BANK_TYPE 
        {
            self.bankAccountIDTextField.text =  BACS_MerchantAccount
            self.paymentToKenTextField.text = Utils.getBACS_PaymentToken() as? String
        }
        else if self.purchaseBankType == EFT_BANK_TYPE 
        {
            self.bankAccountIDTextField.text =  EFT_MerchantAccount
            self.paymentToKenTextField.text = Utils.getEFT_PaymentToken() as? String
        }
        else if self.purchaseBankType == SEPA_BANK_TYPE 
        {
            self.bankAccountIDTextField.text =  SEPA_MerchantAccount
            self.paymentToKenTextField.text = Utils.getSEPA_PaymentToken() as? String
        }

        let len = 13
        let letters : NSString = Numbers
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        self.merchantRefNumTextField.text = String(format: "ORDER_ID: %@", randomString)
            
        self.amountTextField.text = Amount;
        self.paymentMethodTextField.text = PayMethod;
        self.scrollView.contentSize=CGSizeMake(320,660)
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func submitButtonClicked(sender:UIButton)
    {
    self.getDataFromPlist()
    
    opayPaymentPurchaseOperationsProcess.purchasesSubmit(self, withRequestData: self.createDataDictionary(), merchantAccount: self.bankAccountIDTextField.text)
    }
    
     /*----------Getting HTTP Basic Authentication credentails--------------*/ 
    func getDataFromPlist()
    {
        let filepath = NSBundle.mainBundle().pathForResource("MerchantRealConfiguration", ofType: "plist")
        //var myDictionary: NSDictionary?
        let myDictionary:NSDictionary! = NSDictionary.init(contentsOfFile: filepath!)
        
        let merchantID = myDictionary.objectForKey("OptiMerchantID-Server") as! String
        let merchantPassword = myDictionary.objectForKey("OptiMerchantPassword-Server") as! String
        let appleMerchantIdentifier = myDictionary.objectForKey("merchantIdentifier") as! String
        
        opayPaymentPurchaseOperationsProcess = OPayPaymentPurchaseOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        
        opayPaymentPurchaseOperationsProcess.authDelegate = self;
    }

    
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["merchantRefNum"] = self.merchantRefNumTextField.text
        dictionary["amount"] = self.amountTextField.text
        
        var achDic = Dictionary<String, AnyObject>()
        achDic["paymentToken"] = self.paymentToKenTextField.text
        
        if self.purchaseBankType == ACH_BANK_TYPE 
        {
             achDic["payMethod"] = self.paymentMethodTextField.text
             dictionary["ach"] = achDic
            
        }
        else if self.purchaseBankType == BACS_BANK_TYPE 
        {
            dictionary["bacs"] = achDic
        }
        else if self.purchaseBankType == EFT_BANK_TYPE {
            dictionary["eft"] = achDic
        }
        else if self.purchaseBankType == SEPA_BANK_TYPE {
            dictionary["sepa"] = achDic
        }
        return dictionary;
    }
   
     /* ------------- Method for parsing the response object------------*/        
    func callSplitResponse (response: [NSObject : AnyObject]!)
    {
    if response != nil
    {
        if let nameObject: AnyObject = response["error"] {
            var errorCode: String = String()
            var errorMsg: String = String()
            if let errCode: AnyObject = nameObject["code"]{
                if let nameString = errCode as? String {
                    errorCode = nameString
                }
            }
            if let errCode: AnyObject = nameObject["message"]{
                if let nameString = errCode as? String {
                    errorMsg = nameString
                }
            }
            
            self .showAlertView(errorCode, strMessage: errorMsg)
        } 
    else
    {
        let message:String = String(format:"Your Response is :: %@", response.description)
         self .showAlertView("Success", strMessage: message)
        
        if self.purchaseBankType == ACH_BANK_TYPE {
            let strPurchaseId: AnyObject = response["id"]!
            Utils.setACH_PurchaseID(strPurchaseId as! String)
            
        }
        else if (self.purchaseBankType == BACS_BANK_TYPE) {
            let strPurchaseId: AnyObject = response["id"]!
            Utils.setBACS_PurchaseID(strPurchaseId as! String)
                
        }
        else if (self.purchaseBankType == EFT_BANK_TYPE) {
            let strPurchaseId: AnyObject = response["id"]!
            Utils.setEFT_PurchaseID(strPurchaseId as! String)
               
        }
        else if (self.purchaseBankType == SEPA_BANK_TYPE) {
            let strPurchaseId: AnyObject = response["id"]!
            Utils.setSEPA_PurchaseID(strPurchaseId as! String)
                
        }
    }
    }
    else
    {
        //Error handling
         self .showAlertView("Alert", strMessage: "Error message")
    }
    }
    
    func showAlertView(errorCode:String, strMessage:String){
        let alert = UIAlertView(title: errorCode, message: strMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
        
    func callBackPurchaseResponseFromOPTSDK(response: [NSObject : AnyObject]!)
    {
        self.callSplitResponse(response)
    }
}
