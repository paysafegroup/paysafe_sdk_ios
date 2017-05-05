//
//  CreditCardViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/8/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import Foundation
import UIKit


class SWCreditCardViewController : UIViewController , UITextFieldDelegate,OPAYPaymentAuthorizationProcessDelegate
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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        cardExpData["month"] = txtExpMonth.text as AnyObject?
        cardExpData["year"] = txtExpYear.text as AnyObject?
        
        
        var cardBillingAddress = Dictionary<String, AnyObject>()
         cardBillingAddress["street"] = txtStreet1.text as AnyObject?
         cardBillingAddress["street2"] = txtStreet2.text as AnyObject?
         cardBillingAddress["city"] = txtCity.text as AnyObject?
         cardBillingAddress["country"] = txtCountry.text as AnyObject?
         cardBillingAddress["state"] = txtState.text as AnyObject?
         cardBillingAddress["zip"] = txtZip.text as AnyObject?
        
        
        var cardData = Dictionary<String, AnyObject>()
        cardData["cardNum"] = txtCardNo.text as AnyObject?
        cardData["holderName"] = txtNameOnCard.text as AnyObject?
        cardData["cardExpiry"]=cardExpData as AnyObject?
        cardData["billingAddress"]=cardBillingAddress as AnyObject?
        
         var cardDataDetails = Dictionary<String, AnyObject>()
         cardDataDetails["card"] = cardData as AnyObject?
        
         return cardDataDetails
    }
    
    @IBAction func confirmBtnSelected(_ sender:UIButton)
    {
        let envType:String = "TEST_ENV";  //PROD_ENV TEST_ENV
        
        let timeIntrval:String = "30.0";  //Time interval for connection to Optimal server
        
        let enviDictionary: [String: String] = ["EnvType":envType, "TimeIntrval":timeIntrval]
        
        appDelegate.PaysafeAuthController?.authDelegate=self
        
        if (appDelegate.PaysafeAuthController?.responds(to: #selector(PaySafePaymentAuthorizationProcess.beginNonApplePayment(_:withRequestData:withEnvSettingDict:))) != nil)
        {
            appDelegate.PaysafeAuthController?.beginNonApplePayment(self, withRequestData: createDataDictionary(), withEnvSettingDict: enviDictionary)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    // Delegate methods
    /* -------------Delegate method called when webservice call completion from OPAYPaymentAuthorizationProcess------------*/
func callBackResponse(fromOPTSDK response: [AnyHashable: Any]!){
    
        if (response != nil){
            //if let nameObject: AnyObject = response["error"] as! NSDictionary as AnyObject? {
            if let nameObject = response["error"] as? NSDictionary {
                var errorCode: String = String()
                var errorMsg: String = String()
                if let errCode: AnyObject = nameObject["code"] as! NSString as AnyObject? {
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
            
                if let errCode: AnyObject = nameObject["message"] as! String as AnyObject? {
                    if let nameString = errCode as? String {
                        errorMsg = nameString
                    }
                }
                self .showAlertView(errorCode, errorMessage: errorMsg)
            }
            else{
                
                let tokenData: AnyObject = response["paymentToken"]! as AnyObject
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
        
    }
    func callNonAppleFlowFromOPTSDK()
    {
        
    }
    func showAlertView(_ errorCode:String, errorMessage:String){
        let alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
        
    }
    
}
