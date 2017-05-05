//
//  SEPACreateUpdateViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class SEPACreateUpdateViewController: UIViewController , OPayPaymentAccountOperationsProcessDelegate {
    
    @IBOutlet var confirmBtn : UIButton!
    var opayPaymentAccountOperationsProcess: OPayPaymentAccountOperationsProcess!
    var isCreateFlage : Bool!
    //Required fields
    @IBOutlet var accountHolderNameTextField:UITextField!
    @IBOutlet var ibanTextField:UITextField!
    @IBOutlet var billingAddressIdTextField:UITextField!
    
    //Optional fields
    @IBOutlet var merchantRefNOTextField:UITextField!
    @IBOutlet var nickNameTextField:UITextField!
    @IBOutlet var bicTextField:UITextField!
    
    @IBOutlet var scrollView:UIScrollView!
    
    
    override func viewDidLoad() 
    { 
        if self.isCreateFlage == true 
        {
            self.title = "Create SEPA Account";
        }
        else 
        {
            self.title = "Update SEPA Account";
        }

        //required
        self.accountHolderNameTextField.text = AccountHolderName;
        self.ibanTextField.text = Iban;
        self.billingAddressIdTextField.text =  Utils.getAddressID() as? String;
        
        //optional
        self.merchantRefNOTextField.text = MerchantRefNum ;
        self.nickNameTextField.text = NickName;
        self.bicTextField.text = Bic;
        
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
        if self.isCreateFlage == true // If Create Account Mode
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
            self.opayPaymentAccountOperationsProcess.createSEPABankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId)
            }
        }
        else    // If Create Account Mode
            {
                let profileId = Utils.getProfileID() as? String
               
                let accountId = Utils.getSEPA_AccountID() as? String
                if  accountId == nil
                {
                    self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
                }
                else 
                {
                self.getDataFromPlist();
                    
                    let bankID = Utils.getSEPA_AccountID() as? String
                    self.opayPaymentAccountOperationsProcess.updateSEPABankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId, bankAccountID: bankID) 
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
                NSLog("error message %@", errorMsg)
            } 
            else
            {
                let message:String = String(format:"Your Response is :: %@", response.description)
                self .showAlertView("Success", strMessage: message)
                let strId: AnyObject = response["id"]!
                Utils.setSEPA_AccountID(strId as! String)
                
                let strPayToken: AnyObject = response["paymentToken"]!
                Utils.setSEPA_PaymentToken(strPayToken as! String)
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
        dictionary["accountHolderName"] = AccountHolderName
        dictionary["billingAddressId"] = self.billingAddressIdTextField.text
        dictionary["nickName"] = NickName
        dictionary["iban"] = Iban
        dictionary["bic"] = Bic
        
        var refdict = Dictionary<String, AnyObject>()
        refdict["reference"] = SEPA_reference
        
        let arrayMandates:[Dictionary<String,AnyObject>!] = [refdict]
        
        dictionary["mandates"] = arrayMandates
        return dictionary;
    }
}
