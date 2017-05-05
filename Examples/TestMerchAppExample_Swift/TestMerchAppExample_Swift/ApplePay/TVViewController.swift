//
//  TVViewController.swift
//  TestWSMerchantApplication-Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 2/18/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

/*  Real SDK */

import Foundation

class TVViewController: UIViewController , UITextFieldDelegate, AuthorizationProcessDelegate,OPAYPaymentAuthorizationProcessDelegate
{
    
    @IBOutlet var payNowButton : UIButton?
    var isApplePaySupports : Bool?
    
    @IBOutlet var authrizationBtn : UIButton?
    @IBOutlet var purchaseSwitch: UISwitch?
    var isOn:Bool = false
    @IBOutlet var merchantRefField : UITextField?
    @IBOutlet var amountField : UITextField?

    
    var authorizationData: NSDictionary = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Apple Pay"
        
        if(appDelegate.PaysafeAuthController?.isApplePaySupport() == false){
            payNowButton?.setImage(UIImage(named: "payNow_img"), for: UIControlState())
            isApplePaySupports = false
        }
        else
        {
            isApplePaySupports = true
        }
        
        authrizationBtn?.isHidden = true
        
        self.merchantRefField?.delegate = self
        self.amountField?.delegate = self
        
    }
    
    /*
 
     -(BOOL)validateCredentials {
     
     NSString *path = [[NSBundle mainBundle] pathForResource:@"MerchantRealConfiguration" ofType:@"plist"];
     NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
     NSString *merchantUserID = [myDictionary objectForKey:@"OptiMerchantID-Client"];
     
     if ([merchantUserID isEqualToString:@"Single Use API Key ID"]) {
     return NO;
     }
     
     return YES;
     }
     
     
 */
    
@IBAction func tvPayNowSelected(_ sender:UIButton) {
    
        let amount: String! = amountField?.text
    
    
        func validateCredentials() -> Bool {
            let path: String = Bundle.main.path(forResource: "MerchantRealConfiguration", ofType: "plist")!
            let myDictionary: NSMutableDictionary!
            
            myDictionary = NSMutableDictionary.init(contentsOfFile: path)
            
            let merchantID: String = myDictionary["OptiMerchantID-Client"]! as! String
            
            if merchantID.isEqual("Single Use API Key ID") {
                return false
            }
            
            return true
        }
    
    if !validateCredentials() {
        showAlertView("PaySafe", errorMessage: "Please enter valid merchant credentials")
        return;
    }
    
    
    
        if (amount == "" || amount == nil )
        {
             showAlertView("Alert", errorMessage: "Amount should not be empty or zero.")
            return;
        }
        
#if (arch(i386) || arch(x86_64)) && os(iOS)
// Running on simulator
    if #available(iOS 9, *) {
        appDelegate.PaysafeAuthController?.authDelegate = self
        appDelegate.PaysafeAuthController?.beginPayment(self, withRequestData: createDataDictionary(), withCartData: createCartData())
    }
    else {
        showAlertView("Alert", errorMessage: "Device does not support Apple Pay!")
        //callNonApplePayFlow()
    }
    
#else
    
    if(appDelegate.PaysafeAuthController?.isApplePaySupport() == true)
    {
        appDelegate.PaysafeAuthController?.authDelegate = self
        appDelegate.PaysafeAuthController?.beginPayment(self, withRequestData: createDataDictionary(), withCartData: createCartData())
    }
    else
    {
        showAlertView("Alert", errorMessage: "Device does not support Apple Pay!")
        //callNonApplePayFlow()
    }
#endif
}
    
    @IBAction func authorizeBtnSelected(_ sender:UIButton) {
        let authObj:OPTAuthorizationProcess = OPTAuthorizationProcess()
        authObj.processDelegate = self
        authObj.prepareRequest(forAuthorization: createAuthDataDictonary())
    }
    
    /* -------------Delegate method called when webservice call completion from OPAYPaymentAuthorizationProcess------------*/
    func callBackResponse(fromOPTSDK response: [AnyHashable: Any]!) {
        
        if (response != nil){
            //if let nameObject: AnyObject = response["error"] as! NSDictionary {
            if let nameObject = response["error"] as? NSDictionary {
                var errorCode: String = String()
                var errorMsg: String = String()
                if let errCode: AnyObject = nameObject["code"] as! NSString {
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
                
                if let errCode: AnyObject = nameObject["message"] as! NSString {
                    if let nameString = errCode as? String {
                        errorMsg = nameString
                    }
                }
                
                self .showAlertView(errorCode, errorMessage: errorMsg)
                
                
            }
            else{
                authorizationData = response as NSDictionary
                
                authrizationBtn?.isHidden = false
                
                let tokenData: AnyObject = response["paymentToken"]! as AnyObject
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
    }
    
    func callBackResponseFromOptimalRequest(_ response: [AnyHashable: Any]!) {
        print("callBackResponseFromOptimalRequest")
        print(response)
      //  let jsonResult = response as? Dictionary<String, AnyObject>
    }
    
    
    /*
    func callBackAuthorizationProcess(_ dictonary: [AnyHashable: Any]!) {
        var errorCode: String = String()
        var errorMsg: String = String()
        
        if(dictonary != nil)
        {
            if let nameObject: AnyObject = dictonary["error"] as? NSDictionary {
                if let errCode: AnyObject = nameObject["code"] as! NSString {
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
                
                if let errCode: AnyObject = nameObject["message"] as! NSString {
                    if let nameString = errCode as? String {
                        errorMsg = nameString
                    }
                }
                
                self .showAlertView(errorCode, errorMessage: errorMsg) // on 23-02-2017
                
            }else if let nameObject: AnyObject = dictonary["status"] as? NSDictionary {
                if let nameString = nameObject as? String {
                    if nameString == "COMPLETED"{
                        errorCode = nameString
                        
                    }
                    if let nameObject: AnyObject = dictonary["settleWithAuth"] as! NSDictionary {
                        if let nameString = nameObject as? Int {
                            if nameString == 0{
                                errorMsg = "Authorization completed, please proceed for settlement."
                            }else{
                                errorMsg = "Settlement got completed, please check your order history."
                            }
                        }
                    }
                }
                
                self .showAlertView(errorCode, errorMessage: errorMsg)  // on 23-02-2017
                
            }
            else{
                
                //print(dictonary) // on 23-02-2017
                
                if let string = dictonary["id"] {
                    print(string)
                    
                    let tobePrinted = string as! String
                    
                    self .showAlertView(errorCode, errorMessage:tobePrinted)
                    
                }
                
            }
            
            //self .showAlertView(errorCode, errorMessage: errorMsg) //commented on //23-02-2017
       
        }
    }
    */

    func callBackAuthorizationProcess(_ dictonary: [AnyHashable: Any]!) {
        var errorCode: String = String()
        var errorMsg: String = String()
        
        if(dictonary != nil)
        {
            if let nameObject: AnyObject = dictonary["error"] as? NSDictionary {
                if let errCode: AnyObject = nameObject["code"] as! NSString {
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
                
                if let errMsg: AnyObject = nameObject["message"] as! NSString {
                    if let nameString = errMsg as? String {
                        errorMsg = nameString
                    }
                }
                
                self .showAlertView(errorCode, errorMessage: errorMsg)
                
            }else if let nameObject: AnyObject = dictonary["status"] as? NSString {
                if let nameString = nameObject as? String {
                    if nameString == "COMPLETED"{
                        //errorCode = nameString
                        
                        if let nameObject: AnyObject = dictonary["settleWithAuth"] as! NSNumber {
                            if let nameString = nameObject as? NSNumber {
                                if nameString == 0 {
                                    errorCode = "Success"
                                    errorMsg = "Authorization completed, please proceed for settlement."
                                }else{
                                    errorCode = "Success"
                                    errorMsg = "Settlement got completed, please check your order history."
                                }
                                self .showAlertView(errorCode, errorMessage: errorMsg)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func createDataDictionary() -> Dictionary<String, Dictionary <String,String>>{
        
        // Merchant shipping methods
        let shippingMethod1Dictionary: [String: String] = ["shippingName":"Llama California Shipping", "shippingAmount":"0.01", "shippingDes":"3-5 Business Days"]
        
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
    
    func showAlertView(_ errorCode:String, errorMessage:String){
        let alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
    
    @IBAction func isPurchase(_ sender:UISwitch){
        isOn = sender.isOn
        
        if(isOn){
            print("True")
        }else{
            print("False")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    func createAuthDataDictonary() -> Dictionary<String, Any>{
        
        let tokenData: AnyObject = authorizationData["paymentToken"]! as AnyObject
        let description: String = "Hand bag - Big"
        let merchantRef: String! = merchantRefField?.text
        let merchantAmt: String! = amountField?.text
        
        let cardDictonary: [String: AnyObject] = ["paymentToken":tokenData]
        let authDictonary: [String: Any] = ["merchantRefNum":merchantRef as Any, "amount":merchantAmt as Any, "card":cardDictonary as Any, "description":description as Any, "customerIp":[self .getIPAddress()], "settleWithAuth":isOn]
        
        
        return authDictonary;
    }
    
    func getIPAddress()->NSString{
        var ipAddress:NSString = ""
        
        let host = CFHostCreateWithName(nil,"www.google.com" as CFString).takeRetainedValue();
        CFHostStartInfoResolution(host, .addresses, nil);
        var success:DarwinBoolean = true;
        let addresses = CFHostGetAddressing(host, &success)!.takeUnretainedValue() as NSArray;
        if (addresses.count > 0){
            let theAddress = addresses[0] as! Data;
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo((theAddress as NSData).bytes.bindMemory(to: sockaddr.self, capacity: theAddress.count), socklen_t(theAddress.count),
                &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    if let numAddress = String(validatingUTF8: hostname) {
                        
                        ipAddress = numAddress as NSString
                    }
            }
        }
        return ipAddress
    }
    
    func callNonApplePayFlow()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SWCreditCardViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func callNonAppleFlowFromOPTSDK() {
        callNonApplePayFlow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
}
