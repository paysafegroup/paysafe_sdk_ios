//
//  ProfileCreateUpdateViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class ProfileCreateUpdateViewController: UIViewController , OPayPaymentProfileOperationsProcessDelegate {
    
    var opayAddressOperationsController: OPayPaymentProfilesOperationsProcess!
    var isCreateFlage : Bool!
    var responseData  : NSData!
    
    @IBOutlet var confirmBtn : UIButton!
    
    @IBOutlet var MerchantCustomerIDTextField:UITextField!
    @IBOutlet var LocaleTextField:UITextField!
    @IBOutlet var FirstNameIDTextField:UITextField!
    @IBOutlet var MiddleNameTextField:UITextField!
    
    @IBOutlet var LastNameTextField:UITextField!
    @IBOutlet var IpTextField:UITextField!
    @IBOutlet var GenderTextField:UITextField!
    @IBOutlet var NationalityTextField:UITextField!
    @IBOutlet var EmailTextField:UITextField!
    @IBOutlet var PhoneTextField:UITextField!
    @IBOutlet var CellPhoneTextField:UITextField!
    @IBOutlet var DayTextField:UITextField!
    @IBOutlet var MonthTextField:UITextField!
    @IBOutlet var YearTextField:UITextField!
    
    @IBOutlet var scrollView:UIScrollView!
    
    
    override func viewDidLoad() 
    { 
        if self.isCreateFlage == true 
        {
            self.title = "Create Profile"
            
            let len = 13
            let letters : NSString = Letters
            
            let randomString : NSMutableString = NSMutableString(capacity: len)
            
            for (var i=0; i < len; i++){
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }
            
            self.MerchantCustomerIDTextField.text = randomString as String
        }
        else 
        {
            self.title = "Update Profile"
            self.MerchantCustomerIDTextField.text = Utils.getMerchantCustomerID() as? String
        }
        self.LocaleTextField.text=locale;
        self.FirstNameIDTextField.text=firstName;
        self.MiddleNameTextField.text=middleName;
        self.LastNameTextField.text=lastName
        self.IpTextField.text=ip;
        self.GenderTextField.text=gender;
        self.NationalityTextField.text=nationality;
        self.EmailTextField.text=email;
        self.PhoneTextField.text=phone;
        self.CellPhoneTextField.text=cellPhone;
        self.DayTextField.text=birthDay;
        self.MonthTextField.text=birthMonth;
        self.YearTextField.text=birthYear;
        
        self.scrollView.contentSize=CGSizeMake(320,660)
        }
    
    // ----------- TextField Delegates-------------
    func textFieldShouldReturn(textField: UITextField) -> Bool 
    {
        self.view.endEditing(true);
        return true
    }
    
    @IBAction func SubmitButtonClicked(sender : UIButton)
    {
        if self.isCreateFlage == true // If Create Profile Mode
        {
            self.getDataFromPlist();
            self.opayAddressOperationsController.createProfile(self, withRequestData: self.createDataDictionary())
        }
        else  // if Update Profile Mode
        {
            let profileId = Utils.getProfileID() as? String
            if  profileId == nil 
            {
                self .showAlertView("Alert", strMessage: ALERT_CREATE_PROFILE)
            }
            else 
            {
                self.getDataFromPlist();
                self.opayAddressOperationsController.updateProfile(self, withRequestData: self.createDataDictionary(),  profileID: Utils.getProfileID() as? String)            
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
        
        opayAddressOperationsController = OPayPaymentProfilesOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        opayAddressOperationsController.authDelegate = self
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
             Utils.setProfileID(strId as! String)
                let strMerchantId: AnyObject = self.MerchantCustomerIDTextField.text!
                Utils.setMerchantCustomerID(strMerchantId as! String)
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
    
    
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, AnyObject>()
        dictionary["merchantCustomerId"] = self.MerchantCustomerIDTextField.text
        dictionary["locale"] = self.LocaleTextField.text
        dictionary["firstName"] = self.FirstNameIDTextField.text
        dictionary["middleName"] = self.MiddleNameTextField.text
        dictionary["lastName"] = self.LastNameTextField.text
        dictionary["ip"] = self.IpTextField.text
        dictionary["gender"] = self.GenderTextField.text
        dictionary["nationality"] = self.NationalityTextField.text
        dictionary["phone"] = self.PhoneTextField.text
        dictionary["cellPhone"] = self.CellPhoneTextField.text
        
        let year = self.YearTextField.text
        let month = self.MonthTextField.text
        let day = self.DayTextField.text

        if year?.characters.count > 0 || month?.characters.count>0 || day?.characters.count>0{
            var birthDict = Dictionary<String, AnyObject>()
            birthDict["year"] = self.YearTextField.text
            birthDict["month"] = self.MonthTextField.text
            birthDict["day"] = self.DayTextField.text
            dictionary["dateOfBirth"] = birthDict
        }
        return dictionary
    }
}

