//
//  AddressCreateUpdateViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class AddressCreateUpdateViewController: UIViewController , OPayPaymentAddressOperationsProcessDelegate {
    
    var opayAddressOperationsController: OPayPaymentAddressOperationsProcess!
    var isCreateFlage : Bool!
    var responseData  : NSData!
    
    @IBOutlet var confirmBtn : UIButton!
    
    @IBOutlet var StreetTextField:UITextField!
    @IBOutlet var CityTextField:UITextField!
    @IBOutlet var CountryTextField:UITextField!
    @IBOutlet var ZipTextField:UITextField!
    
    @IBOutlet var NicknameTextField:UITextField!
    @IBOutlet var Street2TextField:UITextField!
    @IBOutlet var StateTextField:UITextField!
    @IBOutlet var RecipientNameTextField:UITextField!
    @IBOutlet var PhoneTextField:UITextField!
    
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    { 
        if self.isCreateFlage == true {
            self.title = "Create Address";
        }
        else 
        {
            self.title = "Update Address";
            self.scrollView.contentSize=CGSizeMake(320,660);
        }
        self.StreetTextField.text = street;
        self.CityTextField.text = city;
        self.CountryTextField.text = country;
        self.ZipTextField.text = zip;
        self.NicknameTextField.text = nickname;
        self.Street2TextField.text = street2;
        self.StateTextField.text = state;
        self.RecipientNameTextField.text = recipientName;
        self.PhoneTextField.text = address_phone;
    }
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool 
    {
        self.view.endEditing(true);
        return true
    }
    
    @IBAction func SubmitButtonClicked(sender : UIButton)
    {
        if self.isCreateFlage == true // If Create Address Mode
        {
            let profileId = Utils.getProfileID() as? String
            if profileId == nil
            {
                self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE)
            }
            else 
            {
                self.getDataFromPlist();
                self.opayAddressOperationsController.createAddress(self, withRequestData: self.createDataDictionary(),  profileID: profileId)
            }
        }
        else
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
                self.opayAddressOperationsController.updateAddress(self, withRequestData: self.createDataDictionary(),  profileID: Utils.getProfileID() as? String, addressID:Utils.getAddressID() as? String)            
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
        
        opayAddressOperationsController = OPayPaymentAddressOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        self.opayAddressOperationsController.authDelegate = self
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
                Utils.setAddressID(response["id"]! as! String)
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
    
      /* -------------Delegate method called when webservice call completion from OPayPaymentAddressOperationsProcess------------*/
    func callBackAddressResponseFromOPTSDK(response: [NSObject : AnyObject]!)  
    {
        self.callSplitResponse(response)
    }
    
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["street"] = self.StreetTextField.text
        dictionary["city"] = self.CityTextField.text
        dictionary["country"] = self.CountryTextField.text
        dictionary["zip"] = self.ZipTextField.text
        dictionary["nickname"] = self.NicknameTextField.text
        dictionary["street2"] = self.Street2TextField.text
        dictionary["state"] = self.StateTextField.text
        dictionary["recipientName"] = self.RecipientNameTextField.text
        dictionary["phone"] = self.PhoneTextField.text
        return dictionary;
    }
    
   }
