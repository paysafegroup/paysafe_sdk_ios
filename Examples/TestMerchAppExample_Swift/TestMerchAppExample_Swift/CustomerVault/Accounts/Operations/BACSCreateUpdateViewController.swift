//
//  BACSCreateUpdateViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class BACSCreateUpdateViewController: UIViewController , OPayPaymentAccountOperationsProcessDelegate {
    
    
    var opayPaymentAccountOperationsProcess: OPayPaymentAccountOperationsProcess!
    var isCreateFlage : Bool!
    @IBOutlet var confirmBtn : UIButton!
    //Required fields
    @IBOutlet var accountHolderTextField:UITextField!
    @IBOutlet var accountNoTextField:UITextField!
    @IBOutlet var sortCodeTextField:UITextField!
    @IBOutlet var billingAddressIdTextField:UITextField!
    //Optional fields
    @IBOutlet var merchantRefNOTextField:UITextField!
    @IBOutlet var nickNameTextField:UITextField!
   
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        if self.isCreateFlage == true {
            self.title = "Create BACS Account";
            self.accountNoTextField.text = AccountNo
        }
        else 
        {
            self.title = "Update BACS Account";
            self.accountNoTextField.text = Utils.getBACS_AccountNo() as? String
        }       
        
        //required
        self.accountHolderTextField.text = AccountHolderName;
     
        self.sortCodeTextField.text = SortCode;
        self.billingAddressIdTextField.text =  Utils.getAddressID() as? String;
        //optional
        self.merchantRefNOTextField.text = MerchantRefNo ;
        self.nickNameTextField.text = NickName;
        
        self.scrollView.contentSize=CGSizeMake(320,660);
        
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
        if self.isCreateFlage == true //If Create Account Mode
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
            self.opayPaymentAccountOperationsProcess.createBACSBankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId)
            }
        }
        else // If Update Account Mode
        {
            let profileId = Utils.getProfileID() as? String
          
            let accountId = Utils.getBACS_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
            }
            else 
            {
            self.getDataFromPlist();
            let bankID = Utils.getBACS_AccountID() as? String
            self.opayPaymentAccountOperationsProcess.updateBACSBankAccount(self, withRequestData: self.createDataDictionary(), profileID: profileId, bankAccountID: bankID) 
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
                let strId: AnyObject = response["id"]!
                Utils.setBACS_AccountID(strId as! String)
                let strPayToken: AnyObject = response["paymentToken"]!
                Utils.setBACS_PaymentToken( response["paymentToken"] as! String)
                Utils.setBACS_AccountNO(self.accountNoTextField.text!)
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
    
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, AnyObject>()
         dictionary["accountHolderName"] = self.accountHolderTextField.text
         dictionary["billingAddressId"] =  self.billingAddressIdTextField.text
         dictionary["nickName"] = self.nickNameTextField.text
         dictionary["sortCode"] = self.sortCodeTextField.text
         dictionary["accountNumber"] = self.accountNoTextField.text
        
        var refdict = Dictionary<String, AnyObject>()
         refdict["reference"] = "ABCDEFGHIJ"
        
        let arrayMandates:[Dictionary<String,AnyObject>!] = [refdict]
        
        dictionary["mandates"] = arrayMandates
        return dictionary
    }
    
}
