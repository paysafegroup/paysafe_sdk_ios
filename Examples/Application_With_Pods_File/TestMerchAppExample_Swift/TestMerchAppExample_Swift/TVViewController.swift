//
//  TVViewController.swift
//  TestWSMerchantApplication-Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 2/18/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

/*  Real SDK */

import Foundation

class TVViewController: UIViewController , UITextFieldDelegate, AuthorizationProcessDelegate,PaysafePaymentAuthorizationProcessDelegate
{
    
    @IBOutlet var payNowButton : UIButton?
    var isApplePaySupports : Bool?
    
    @IBOutlet var authrizationBtn : UIButton?
    @IBOutlet var purchaseSwitch: UISwitch?
    var isOn:Bool = false
    @IBOutlet var merchantRefField : UITextField?
    @IBOutlet var amountField : UITextField?

    
    var authorizationData: NSDictionary = NSDictionary()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Apple Pay"
        
        if(appDelegate.PaysafeAuthController?.isApplePaySupport() == false){
            payNowButton?.setImage(UIImage(named: "payNow_img"), forState: .Normal)
            isApplePaySupports = false
        }
        else
        {
            isApplePaySupports = true
        }
        
        authrizationBtn?.hidden = true
        
        self.merchantRefField?.delegate = self
        self.amountField?.delegate = self
        
    }
    
@IBAction func tvPayNowSelected(sender:UIButton) {
    
        let amount: String! = amountField?.text
        if (amount == "" || amount == nil )
        {
             showAlertView("Alert", errorMessage: "Amount should not be empty or zero.")
            return;
        }
        
#if (arch(i386) || arch(x86_64)) && os(iOS)
    
      appDelegate.PaysafeAuthController?.authDelegate = self
      appDelegate.PaysafeAuthController?.beginPayment(self, withRequestData: createDataDictionary(), withCartData: createCartData())
    
#else
    
    if(appDelegate.PaysafeAuthController?.isApplePaySupport() == true)
    {
        appDelegate.PaysafeAuthController?.authDelegate = self
        appDelegate.PaysafeAuthController?.beginPayment(self, withRequestData: createDataDictionary(), withCartData: createCartData())
    }
    else
    {
        showAlertView("Alert", errorMessage: "Device does not support Apple Pay!")
        callNonApplePayFlow()
    }
#endif
}
    
    @IBAction func authorizeBtnSelected(sender:UIButton) {
        let authObj:OPTAuthorizationProcess = OPTAuthorizationProcess()
        authObj.processDelegate = self
        authObj.prepareRequestForAuthorization(createAuthDataDictonary())
    }
    
    
    func callBackResponseFromOPTSDK(response: [NSObject : AnyObject]!) {
        
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
                authorizationData = response
                
                
                authrizationBtn?.hidden = false
                
                
                let tokenData: AnyObject = response["paymentToken"]!
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
    }
    
    func callBackResponseFromOptimalRequest(response: [NSObject : AnyObject]!) {
        print("callBackResponseFromPaysafeRequest")
        print(response)
      //  let jsonResult = response as? Dictionary<String, AnyObject>
    }
    
    func callBackAuthorizationProcess(dictonary: [NSObject : AnyObject]!) {
        var errorCode: String = String()
        var errorMsg: String = String()
        
        if(dictonary != nil)
        {
            if let nameObject: AnyObject = dictonary["error"] {
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
                
            }else if let nameObject: AnyObject = dictonary["status"]{
                if let nameString = nameObject as? String {
                    if nameString == "COMPLETED"{
                        errorCode = nameString
                    }
                    if let nameObject: AnyObject = dictonary["settleWithAuth"]{
                        if let nameString = nameObject as? Int {
                            if nameString == 0{
                                errorMsg = "Authorization completed, please proceed for settlement."
                            }else{
                                errorMsg = "Settlement got completed, please check your order history."
                            }
                        }
                    }
                }
            }
            else{
                print(dictonary)
            }
            
            
            self .showAlertView(errorCode, errorMessage: errorMsg)
       
        }
    }
    
    
    func createDataDictionary() -> Dictionary<String, Dictionary <String,String>>{
        
        // Merchant shipping methods
        let shippingMethod1Dictionary: [String: String] = ["shippingName":"Llama California Shipping", "shippingAmount":"1.00", "shippingDes":"3-5 Business Days"]
        
        let envType:String = "TEST_ENV";  //PROD_ENV TEST_ENV
        
        let timeIntrval:String = "30.0";  //Time interval for connection to Optimal server
        
        
        let enviDictionary: [String: String] = ["EnvType":envType, "TimeIntrval":timeIntrval]
        
        let dataDictonary: [String: Dictionary<String, String>] = ["ShippingMethod": shippingMethod1Dictionary,"EnvSettingDict": enviDictionary]
        
        return dataDictonary
    }
    
    
    func createCartData() -> Dictionary<String, String>{
        let amount: String! = amountField?.text
        let cartDictonary: [String: String] = ["CartID":"123423", "CartTitle":"TShirt", "CartCost":amount, "CartDiscount":"3", "CartShippingCost":"2","PayTo":"Llama Services, Inc."]
        
        return cartDictonary;
    }
    
    func createFakeTokenDataDictonary() -> Dictionary<String, String>{
        let dataDictonary: [String: String] = ["applicationPrimaryAccountNumber": "4111111111111111", "applicationExpirationDate":"181231" ,  "transactionAmount":"1499", "cardholderName":"Bill Gates"]
        
        return dataDictonary
    }
    
    func showAlertView(errorCode:String, errorMessage:String){
        let alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
    
    @IBAction func isPurchase(sender:UISwitch){
        isOn = sender.on
        
        if(isOn){
            print("True")
        }else{
            print("False")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    func createAuthDataDictonary() -> Dictionary<String, AnyObject>{
        
        let tokenData: AnyObject = authorizationData["paymentToken"]!
        let description: String = "Hand bag - Big"
        let merchantRef: String! = merchantRefField?.text
        let merchantAmt: String! = amountField?.text
        
        let cardDictonary: [String: AnyObject] = ["paymentToken":tokenData]
        let authDictonary: [String: AnyObject] = ["merchantRefNum":merchantRef, "amount":merchantAmt, "card":cardDictonary, "description":description, "customerIp":[self .getIPAddress()], "settleWithAuth":isOn]
        return authDictonary;
    }
    
    func getIPAddress()->NSString{
        var ipAddress:NSString = ""
        
        let host = CFHostCreateWithName(nil,"www.google.com").takeRetainedValue();
        CFHostStartInfoResolution(host, .Addresses, nil);
        var success:DarwinBoolean = true;
        let addresses = CFHostGetAddressing(host, &success)!.takeUnretainedValue() as NSArray;
        if (addresses.count > 0){
            let theAddress = addresses[0] as! NSData;
            var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
            if getnameinfo(UnsafePointer(theAddress.bytes), socklen_t(theAddress.length),
                &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    if let numAddress = String.fromCString(hostname) {
                        
                        ipAddress = numAddress
                    }
            }
        }
        return ipAddress
    }
    
    func callNonApplePayFlow()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SWCreditCardViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func callNonAppleFlowFromOPTSDK() {
        callNonApplePayFlow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
}