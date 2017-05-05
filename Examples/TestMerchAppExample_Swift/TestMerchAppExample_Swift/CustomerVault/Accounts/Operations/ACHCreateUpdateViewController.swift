//
//  ACHCreateUpdateViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class ACHCreateUpdateViewController: UIViewController, OPayPaymentAccountOperationsProcessDelegate {
    @IBOutlet var confirmBtn : UIButton!
    var opayPaymentAccountOperationsProcess: OPayPaymentAccountOperationsProcess!
    var isCreateFlage : Bool!
    //Required fields
    @IBOutlet var accountHolderNameTextField:UITextField!
    @IBOutlet var accountNoTextField:UITextField!
    @IBOutlet var routingNoTextField:UITextField!
    @IBOutlet var billingAddressIdTextField:UITextField!
    @IBOutlet var accountTypeTextField:UITextField!
    //Optional fields
    @IBOutlet var merchantRefNOTextField:UITextField!
    @IBOutlet var nickNameTextField:UITextField!
    
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        if self.isCreateFlage == true { //If Create Account Mode
            self.title = "Create ACH Account";
            
            let len = 8
            let letters : NSString = Numbers
            
            let randomString : NSMutableString = NSMutableString(capacity: len)
            
            for (var i=0; i < len; i++){
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }

            self.accountNoTextField.text = randomString as String
        }
        else // Update Account Mode
        {
            self.title = "Update ACH Account";
            self.accountNoTextField.text = Utils.getACH_AccountNo() as? String
        }       
        
        self.accountHolderNameTextField.text = AccountHolderName;
        
        self.routingNoTextField.text = RoutingNo;
        self.billingAddressIdTextField.text =  Utils.getAddressID() as? String;
        self.accountTypeTextField.text = AccountType;
        self.merchantRefNOTextField.text = MerchantRefNo ;
        self.nickNameTextField.text = NickName;
        self.scrollView.contentSize=CGSizeMake(320,660);
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool 
    {
        self.view.endEditing(true);
        return true
    }
    
    @IBAction func submitButtonClicked(sender:UIButton)
    {
       if self.isCreateFlage == true //If create Account Mode
       {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
        
            if  profileId == nil || addressId == nil 
            {
                self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS)
            }
            else 
            {
                self.getDataFromPlist();
                self.opayPaymentAccountOperationsProcess.createACHBankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId)
            }
       }
        else // If Update Account Mode
        {
            let profileId = Utils.getProfileID() as? String
            let accountId = Utils.getACH_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
            }
            else 
            {
            self.getDataFromPlist();
            let bankID = Utils.getACH_AccountID() as? String
            self.opayPaymentAccountOperationsProcess.updateACHBankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId, bankAccountID: bankID)            
            }
        }
    }
    
     /*----------Getting HTTP Basic Authentication credentails--------------*/ 
    func getDataFromPlist()
    {
        let filepath = NSBundle.mainBundle().pathForResource("MerchantRealConfiguration", ofType: "plist")
        
        let myDictionary:NSDictionary! = NSDictionary.init(contentsOfFile: filepath!)
        
        let merchantID = myDictionary.objectForKey("OptiMerchantID-Server") as! String
        let merchantPassword = myDictionary.objectForKey("OptiMerchantPassword-Server") as! String
        let appleMerchantIdentifier = myDictionary.objectForKey("merchantIdentifier") as! String
        
        opayPaymentAccountOperationsProcess = OPayPaymentAccountOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        
        opayPaymentAccountOperationsProcess.authDelegate = self;
    }
    
     /* ------------- Method for parsing the response object------------*/
    func callSplitResponse (response: [NSObject : AnyObject]!)
    {
        if response != nil
        {
            if let nameObject: AnyObject = response["error"] 
            {
                var errorCode: String = String()
                var errorMsg: String = String()
                if let errCode: AnyObject = nameObject["code"]
                {
                    if let nameString = errCode as? String 
                    {
                        errorCode = nameString
                    }
                }
                if let errCode: AnyObject = nameObject["message"]
                {
                    if let nameString = errCode as? String 
                    {
                        errorMsg = nameString
                    }
                }
                
                self .showAlertView(errorCode, strMessage: errorMsg)
            } 
            else
            {
                let message:String = String(format:"Your Response is :: %@", response.description)
                self .showAlertView("Success", strMessage: message)
                let strId: AnyObject = response["id"]!
                Utils.setACH_AccountID(strId as! String)
                let strPayToken: AnyObject = response["paymentToken"]!
                Utils.setACH_PaymentToken(strPayToken as! String)
                Utils.setACH_AccountNO(self.accountNoTextField.text!)
            }
        }
        else
        {
            //Error handling
            self .showAlertView("Alert", strMessage: "Error message")
        }
    }
    
    func showAlertView(errorCode:String, strMessage:String)
    {
        let alert = UIAlertView(title: errorCode, message: strMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
    
    /* -------------Delegate method called when webservice call completion from OPayPaymentAccountOperationsProcess------------*/
    func callBackAccountResponseFromOPTSDK(response: [NSObject : AnyObject]!)  
    {
        self.callSplitResponse(response)
    }
    
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["accountHolderName"] = self.accountHolderNameTextField.text
        dictionary["billingAddressId"] = self.billingAddressIdTextField.text
        dictionary["accountType"] = self.accountTypeTextField.text
        dictionary["routingNumber"] = self.routingNoTextField.text
        dictionary["accountNumber"] = self.accountNoTextField.text
        dictionary["nickName"] = self.nickNameTextField.text
        return dictionary;
    }
}


