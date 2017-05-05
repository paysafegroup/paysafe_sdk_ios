//
//  DeleteAccountViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class DeleteAccountViewController: UIViewController , UITextFieldDelegate ,OPayPaymentAccountOperationsProcessDelegate
{
    @IBOutlet var confirmBtn : UIButton!
    var opayPaymentAccountOperationsProcess: OPayPaymentAccountOperationsProcess!
    var accountBankType : Int!
    
    @IBOutlet var bankAccountIDTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        if self.accountBankType == ACH_BANK_TYPE {
            self.bankAccountIDTextField.text = Utils.getACH_AccountID() as? String
            self.title = "Delete ACH Account"
        }
        else if self.accountBankType == BACS_BANK_TYPE {
            self.bankAccountIDTextField.text = Utils.getBACS_AccountID() as? String
            self.title = "Delete BACS Account"
        }
        else if self.accountBankType == EFT_BANK_TYPE {
            self.bankAccountIDTextField.text = Utils.getEFT_AccountID() as? String
            self.title = "Delete EFT Account"
        }
        else if self.accountBankType == SEPA_BANK_TYPE {
            self.bankAccountIDTextField.text = Utils.getSEPA_AccountID() as? String
            self.title = "Delete SEPA Account"
        }
        
        self.scrollView.contentSize=CGSizeMake(320,660)
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
                self.opayPaymentAccountOperationsProcess.deleteACHBankAccount(self, withRequestData: nil, profileID: profileId, bankAccountID: bankID) 
            //  }
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
                self.opayPaymentAccountOperationsProcess.deleteBACSBankAccount(self, withRequestData: nil,  profileID: profileId, bankAccountID: bankID) 
            }
        }
            
        else if self.accountBankType == EFT_BANK_TYPE 
        {
            let bankID = Utils.getEFT_AccountID() as? String
            let profileId = Utils.getProfileID() as? String
        
            let accountId = Utils.getEFT_AccountID() as? String
            if  accountId == nil
                {
                    self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
            }
            else 
            {
                  self.opayPaymentAccountOperationsProcess.deleteEFTBankAccount(self, withRequestData: nil,  profileID: profileId, bankAccountID: bankID) 
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
             if self.opayPaymentAccountOperationsProcess.respondsToSelector("lookUpSEPABankAccount:withRequestData:profileID:strBankAccount_ID")
              {
                self.opayPaymentAccountOperationsProcess.deleteSEPABankAccount(self, withRequestData: nil,  profileID: profileId, bankAccountID: bankID)
              }
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
                
                if self.accountBankType == ACH_BANK_TYPE 
                {
                    Utils.deleteACH_AccountID()
                    Utils.setACH_AccountNO("")
                }
                else if self.accountBankType == BACS_BANK_TYPE 
                {
                    Utils.deleteBACS_AccountID()
                    Utils.setBACS_AccountNO("")
                } 
                else if self.accountBankType == EFT_BANK_TYPE 
                {
                    Utils.deleteEFT_AccountID()
                    Utils.setEFT_AccountNO("")
                } 
                else if self.accountBankType == SEPA_BANK_TYPE 
                {
                    Utils.deleteSEPA_AccountID()
                    Utils.setSEPA_AccountNO("")
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
    
    /* -------------Delegate method called when webservice call completion from OPayPaymentAccountOperationsProcess------------*/
    func callBackAccountResponseFromOPTSDK(response: [NSObject : AnyObject]!)  
    {
        self.callSplitResponse(response)
    }

}
