//
//  LookUpAccountViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class LookUpAccountViewController: UIViewController, UITextFieldDelegate ,OPayPaymentAccountOperationsProcessDelegate
{
    @IBOutlet var confirmBtn : UIButton!
    
    var opayPaymentAccountOperationsProcess: OPayPaymentAccountOperationsProcess!
    var accountBankType : Int!
    
    @IBOutlet var bankAccountIDTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        if self.accountBankType == ACH_BANK_TYPE 
        {
            self.bankAccountIDTextField.text = Utils.getACH_AccountID() as? String
            self.title = "Lookup ACH Account"
        }
        else if self.accountBankType == BACS_BANK_TYPE 
        {
            self.bankAccountIDTextField.text = Utils.getBACS_AccountID() as? String
            self.title = "Lookup BACS Account"
        }
        else if self.accountBankType == EFT_BANK_TYPE 
        {
            self.bankAccountIDTextField.text = Utils.getEFT_AccountID() as? String
            self.title = "Lookup EFT Account"
        }
        else if self.accountBankType == SEPA_BANK_TYPE 
        {
            self.bankAccountIDTextField.text = Utils.getSEPA_AccountID() as? String
            self.title = "Lookup SEPA Account"
        }
        
        
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
    self.getDataFromPlist();
            
    if self.accountBankType == ACH_BANK_TYPE 
    {
        let bankID = Utils.getACH_AccountID() as? String
        let profileId = Utils.getProfileID() as? String
        let accountId = Utils.getACH_AccountID() as? String
        if  accountId == nil
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
        }
        else 
        {
            
            self.opayPaymentAccountOperationsProcess.lookUpACHBankAccount(self, withRequestData: nil, profileID: profileId, bankAccountID: bankID) 
        }
    }
    else if self.accountBankType == BACS_BANK_TYPE 
    {
        let bankID = Utils.getBACS_AccountID() as? String
        let profileId = Utils.getProfileID() as? String
        let accountId = Utils.getBACS_AccountID() as? String
        if  accountId == nil
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
        }
        else 
        {
            self.opayPaymentAccountOperationsProcess.lookUpBACSBankAccount(self, withRequestData: nil, profileID: profileId, bankAccountID: bankID) 
        }
    }
        
    else if self.accountBankType == EFT_BANK_TYPE 
    {
        let profileId = Utils.getProfileID() as? String
        let accountId = Utils.getEFT_AccountID() as? String
        if  accountId == nil
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
        }
        else 
        {
            self.opayPaymentAccountOperationsProcess.lookUpEFTBankAccount(self, withRequestData: nil,  profileID: profileId, bankAccountID: accountId) 
        }
    }
    else if self.accountBankType == SEPA_BANK_TYPE 
    {
        let bankID = Utils.getSEPA_AccountID() as? String
        let profileId = Utils.getProfileID() as? String
        let accountId = Utils.getSEPA_AccountID() as? String
        if  accountId == nil
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
        }
        else 
        {
            self.opayPaymentAccountOperationsProcess.lookUpSEPABankAccount(self, withRequestData: nil,  profileID: profileId, bankAccountID: bankID) 
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

}
