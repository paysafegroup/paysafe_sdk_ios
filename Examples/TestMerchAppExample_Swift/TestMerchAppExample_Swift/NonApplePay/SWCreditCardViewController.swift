//
//  CreditCardViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/8/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import Foundation
import UIKit


class SWCreditCardViewController :UIViewController ,UITextFieldDelegate,PaysafePaymentAuthorizationProcessDelegate
{
    @IBOutlet var  scrollView :UIScrollView!
    @IBOutlet var  txtCardNo:UITextField!
    @IBOutlet var  txtCvv:UITextField!
    @IBOutlet var  txtExpMonth:UITextField!
    @IBOutlet var  txtExpYear:UITextField!
    @IBOutlet var  txtNameOnCard:UITextField!
    @IBOutlet var  txtStreet1:UITextField!
    @IBOutlet var  txtStreet2:UITextField!
    @IBOutlet var  txtCity:UITextField!
    @IBOutlet var  txtCountry:UITextField!
    @IBOutlet var  txtState:UITextField!
    @IBOutlet var  txtZip:UITextField!
    
    @IBOutlet var  btnConfirm:UIButton!
    @IBOutlet var  btnCancel:UIButton!

    
    var  amount:NSString!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Non Apple Pay"
        scrollView.contentSize = CGSize(width:320, height:1200)
        self.txtCardNo!.delegate = self
        self.txtExpMonth!.delegate = self
        self.txtExpYear!.delegate = self
        self.txtNameOnCard!.delegate = self
        self.txtStreet1!.delegate = self
        self.txtStreet2!.delegate = self
        self.txtCity!.delegate = self
        self.txtCountry!.delegate = self
        self.txtState!.delegate = self
        self.txtZip!.delegate = self
    }
    
    func createDataDictionary() -> Dictionary <String , AnyObject>
    {
        var cardExpData = Dictionary<String, AnyObject>()
        cardExpData["month"] = txtExpMonth.text
        cardExpData["year"] = txtExpYear.text
        
        
        var cardBillingAddress = Dictionary<String, AnyObject>()
         cardBillingAddress["street"] = txtStreet1.text
         cardBillingAddress["street2"] = txtStreet2.text
         cardBillingAddress["city"] = txtCity.text
         cardBillingAddress["country"] = txtCountry.text
         cardBillingAddress["state"] = txtState.text
         cardBillingAddress["zip"] = txtZip.text
        
        
        var cardData = Dictionary<String, AnyObject>()
        cardData["cardNum"] = txtCardNo.text
        cardData["holderName"] = txtNameOnCard.text
        cardData["cardExpiry"]=cardExpData
        cardData["billingAddress"]=cardBillingAddress
        
         var cardDataDetails = Dictionary<String, AnyObject>()
         cardDataDetails["card"] = cardData
        
         return cardDataDetails
    }
    
    @IBAction func confirmBtnSelected(sender:UIButton)
    {
        let envType:String = "TEST_ENV";  //PROD_ENV TEST_ENV
        
        let timeIntrval:String = "30.0";  //Time interval for connection to Optimal server
        
        let enviDictionary: [String: String] = ["EnvType":envType, "TimeIntrval":timeIntrval]
        
        appDelegate.PaysafeAuthController?.authDelegate=self
        
        
        if (appDelegate.PaysafeAuthController?.respondsToSelector(Selector("beginNonApplePayment:withRequestData:withEnvSettingDict:")) != nil)
        {
            appDelegate.PaysafeAuthController?.beginNonApplePayment(self, withRequestData: createDataDictionary(), withEnvSettingDict: enviDictionary)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    // Delegate methods
    func callBackResponseFromOPTSDK(response: [NSObject : AnyObject]!)
    {
        if (response != nil){
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
                self .showAlertView(errorCode, errorMessage: errorMsg)
            }
            else{
                
                let tokenData: AnyObject = response["paymentToken"]!
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
        
    }
    func callNonAppleFlowFromOPTSDK()
    {
        
    }
    func showAlertView(errorCode:String, errorMessage:String){
        let alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
        
    }
    
}