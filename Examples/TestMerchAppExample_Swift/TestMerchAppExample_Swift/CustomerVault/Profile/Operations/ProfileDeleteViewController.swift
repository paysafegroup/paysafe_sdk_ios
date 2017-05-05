//
//  ProfileDeleteViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class ProfileDeleteViewController: UIViewController , OPayPaymentProfileOperationsProcessDelegate {
    
    var opayProfileOperationsController: OPayPaymentProfilesOperationsProcess!
    
    var responseData  : NSData!
    @IBOutlet var confirmBtn : UIButton!
    
    @IBOutlet var ProfileIDTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        self.title = "Delete Profile"
        
        let str = Utils.getProfileID() as? String
        if str != nil
        {
            self.ProfileIDTextField.text = str
        }
      
        self.scrollView.contentSize=CGSizeMake(320,660)
    }
    
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return true
    }
    
    @IBAction func SubmitButtonClicked(sender : UIButton)
    {
        if let text = self.ProfileIDTextField.text where text.isEmpty 
        {
            self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE)
        }
        else 
        {
        self.getDataFromPlist();
        
        self.opayProfileOperationsController.deleteProfile(self, profileID: Utils.getProfileID() as? String)        
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
        
        opayProfileOperationsController = OPayPaymentProfilesOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        opayProfileOperationsController.authDelegate = self;
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
                Utils.deleteProfileID()
                Utils.deleteMerchantCustomerID()
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
    
     /* -------------Delegate method called when webservice call completion from OPayPaymentProfilesOperationsProcess------------*/
    func callBackProfileResponseFromOPTSDK(response: [NSObject : AnyObject]!) 
    {
        self.callSplitResponse(response)
    }
}
