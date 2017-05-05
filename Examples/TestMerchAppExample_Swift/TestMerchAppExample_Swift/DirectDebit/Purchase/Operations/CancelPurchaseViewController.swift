//
//  CancelPurchaseViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 28/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class CancelPurchaseViewController: UIViewController,OPayPaymentPurchaseOperationsProcessDelegate {
    
    
    var opayPaymentPurchaseOperationsProcess: OPayPaymentPurchaseOperationsProcess!
    var titleString : String!
    var purchaseBankType : Int!
    
    @IBOutlet var confirmBtn : UIButton!
    
    @IBOutlet var bankAccountIDTextField:UITextField!
    @IBOutlet var purchaseIDTextField:UITextField!
    @IBOutlet var scrollView:UIScrollView!
    
    override func viewDidLoad() 
    {
        if self.purchaseBankType == ACH_BANK_TYPE {
            self.bankAccountIDTextField.text = ACH_MerchantAccount
            self.purchaseIDTextField.text = Utils.getACH_PurchaseID() as? String
        }
        else if self.purchaseBankType == BACS_BANK_TYPE {
            self.bankAccountIDTextField.text = BACS_MerchantAccount
            self.purchaseIDTextField.text = Utils.getBACS_PurchaseID() as? String
        }
        else if self.purchaseBankType == EFT_BANK_TYPE {
            self.bankAccountIDTextField.text = EFT_MerchantAccount
            self.purchaseIDTextField.text = Utils.getEFT_PurchaseID() as? String;
        }
        else if self.purchaseBankType == SEPA_BANK_TYPE {
            self.bankAccountIDTextField.text = SEPA_MerchantAccount
            self.purchaseIDTextField.text = Utils.getSEPA_PurchaseID() as? String;
        }
        self.scrollView.contentSize=CGSizeMake(320,660)
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
       
    @IBAction func submitButtonClicked(sender:UIButton)
    {
        self.getDataFromPlist()
        
        opayPaymentPurchaseOperationsProcess.purchasesCancel(self, withRequestData: self.createDataDictionary(), purchaseID:self.purchaseIDTextField.text, merchantAccount:self.bankAccountIDTextField.text)
    }
   
    func createDataDictionary() -> Dictionary<String, AnyObject>
    {
        var dictionary = Dictionary<String, String>()
        dictionary["status"] = "CANCELLED"
        return dictionary
    }
    
     /*----------Getting HTTP Basic Authentication credentails--------------*/ 
    func getDataFromPlist()
    {
        let filepath = NSBundle.mainBundle().pathForResource("MerchantRealConfiguration", ofType: "plist")
        //var myDictionary: NSDictionary?
        let myDictionary:NSDictionary! = NSDictionary.init(contentsOfFile: filepath!)
        
        let merchantID = myDictionary.objectForKey("OptiMerchantID-Server") as! String
        let merchantPassword = myDictionary.objectForKey("OptiMerchantPassword-Server") as! String
        let appleMerchantIdentifier = myDictionary.objectForKey("merchantIdentifier") as! String
        
        opayPaymentPurchaseOperationsProcess = OPayPaymentPurchaseOperationsProcess(merchantIdentifier:appleMerchantIdentifier , withMerchantID:merchantID , withMerchantPwd: merchantPassword)
        
        opayPaymentPurchaseOperationsProcess.authDelegate = self;
    }
    func callBackPurchaseResponseFromOPTSDK(response: [NSObject : AnyObject]!)
    {
        self.callSplitResponse(response)
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
}
