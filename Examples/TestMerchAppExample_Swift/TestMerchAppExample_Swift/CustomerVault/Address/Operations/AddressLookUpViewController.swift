//
//  AddressLookUpViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class AddressLookUpViewController: UIViewController, OPayPaymentAddressOperationsProcessDelegate 
{
    var opayAddressOperationsController: OPayPaymentAddressOperationsProcess!
    
    var responseData  : NSData!
    
    @IBOutlet var confirmBtn : UIButton!
    @IBOutlet var ProfileIDTextField:UITextField!
    @IBOutlet var AddressIDTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
       
    override func viewDidLoad() 
    {     
        self.title = "LookUp Address";
        let strProfile = Utils.getProfileID() as? String
        let strAddress =  Utils.getAddressID() as? String
        
        if strProfile != nil
        {
            self.ProfileIDTextField.text = strProfile
        }
        
        if strAddress != nil
        {
            self.AddressIDTextField.text = strAddress
        }
        self.scrollView.contentSize=CGSizeMake(320,660);
    }
    
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool 
    {
        self.view.endEditing(true);
        return true
    }
    
    @IBAction func SubmitButtonClicked(sender : UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        let addressId = Utils.getAddressID() as? String
        if profileId == nil || addressId == nil
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE_ADDRESS)
        }
        else 
        {
            self.getDataFromPlist();
            self.opayAddressOperationsController.lookupAddress(self,  profileID: profileId, addressID:Utils.getAddressID() as? String)
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
        
        opayAddressOperationsController = OPayPaymentAddressOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        opayAddressOperationsController.authDelegate = self
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
    
    /* -------------Delegate method called when webservice call completion from OPayPaymentAddressOperationsProcess------------*/
   func callBackAddressResponseFromOPTSDK(response: [NSObject : AnyObject]!)  
    {
        self.callSplitResponse(response)
    }

}
