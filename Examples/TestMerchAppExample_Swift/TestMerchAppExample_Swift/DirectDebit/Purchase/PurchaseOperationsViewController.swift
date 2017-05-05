//
//  PurchaseOperationsViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 27/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class PurchaseOperationsViewController: UIViewController {
    
    @IBOutlet var submitPurchaseBtn : UIButton!
    @IBOutlet var cancel_PurchaseBtn : UIButton!
    @IBOutlet var lookUp_PurchaseBtn : UIButton!
    @IBOutlet var lookUp_merchantId_PurchaseBtn : UIButton!
    
    var purchaseBankType: Int!
    
    override func viewDidLoad() 
    {
        if self.purchaseBankType == ACH_BANK_TYPE {
            self.title = "ACH Purchase";
        }
        else if self.purchaseBankType == BACS_BANK_TYPE {
            self.title = "BACS Purchase";
        }
        else if self.purchaseBankType == EFT_BANK_TYPE {
            self.title = "EFT Purchase";
        }
        else if self.purchaseBankType == SEPA_BANK_TYPE {
            self.title = "SEPA Purchase";
        }
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

    }
    @IBAction func submitPurchaseButtonClicked(sender:UIButton)
    {        
        if (self.purchaseBankType == ACH_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let ach_AccountId = Utils.getACH_AccountID() as? String
            
            if  profileId == nil || addressId == nil || ach_AccountId == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
            }
            else 
            {
                self.navigateSubmitPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == BACS_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let bacs_AccountId = Utils.getBACS_AccountID() as? String
            if  profileId == nil || addressId == nil || bacs_AccountId == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
            }
            else 
            {
                self.navigateSubmitPurchaseVC()  
            }
        }
        else  if (self.purchaseBankType == EFT_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let eft_AccountId = Utils.getEFT_AccountID() as? String
            if  profileId == nil || addressId == nil || eft_AccountId == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
            }
            else 
            {
                self.navigateSubmitPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == SEPA_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let sepa_AccountId = Utils.getSEPA_AccountID() as? String
            if  profileId == nil || addressId == nil || sepa_AccountId == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
            }
            else 
            {
                self.navigateSubmitPurchaseVC()  
            }
        }
    }
    
    
    @IBAction func cancelPurchaseButtonClicked(sender:UIButton)
    {        
        if (self.purchaseBankType == ACH_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let ach_AccountId = Utils.getACH_AccountID() as? String
            let purchaseID = Utils.getACH_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || ach_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_ACH)
            }
            else 
            {
                self.navigateCancelPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == BACS_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let bacs_AccountId = Utils.getBACS_AccountID() as? String
            let purchaseID = Utils.getBACS_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || bacs_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_BACS)
            }
            else 
            {
                self.navigateCancelPurchaseVC()  
            }
        }
        else  if (self.purchaseBankType == EFT_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let eft_AccountId = Utils.getEFT_AccountID() as? String
            let purchaseID = Utils.getEFT_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || eft_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_EFT)
            }
            else 
            {
                self.navigateCancelPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == SEPA_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let sepa_AccountId = Utils.getSEPA_AccountID() as? String
            let purchaseID = Utils.getSEPA_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || sepa_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_SEPA)
            }
            else 
            {
                self.navigateCancelPurchaseVC()  
            }
        }
    }
    
    
    @IBAction func lookUpPurchaseButtonClicked(sender:UIButton)
    {        
        if (self.purchaseBankType == ACH_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let ach_AccountId = Utils.getACH_AccountID() as? String
            let purchaseID = Utils.getACH_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || ach_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_ACH)
            }
            else 
            {
                self.navigateLookUpPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == BACS_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let bacs_AccountId = Utils.getBACS_AccountID() as? String
            let purchaseID = Utils.getBACS_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || bacs_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_BACS)
            }
            else 
            {
                self.navigateLookUpPurchaseVC()  
            }
        }
        else  if (self.purchaseBankType == EFT_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let eft_AccountId = Utils.getEFT_AccountID() as? String
            let purchaseID = Utils.getEFT_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || eft_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_EFT)
            }
            else 
            {
                self.navigateLookUpPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == SEPA_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let sepa_AccountId = Utils.getSEPA_AccountID() as? String
            let purchaseID = Utils.getSEPA_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || sepa_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_SEPA)
            }
            else 
            {
                self.navigateLookUpPurchaseVC()  
            }
        }
    }
    
    @IBAction func lookUpPurchaseUsingMerRefNumButtonClicked(sender:UIButton)
    {        
        if (self.purchaseBankType == ACH_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let ach_AccountId = Utils.getACH_AccountID() as? String
            let purchaseID = Utils.getACH_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || ach_AccountId == nil || purchaseID == nil
            {
                self.showAlertView( ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_ACH)
            }
            else 
            {
                self.navigateLookUpMerRefNumPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == BACS_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let bacs_AccountId = Utils.getBACS_AccountID() as? String
            let purchaseID = Utils.getBACS_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || bacs_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_BACS)
            }
            else 
            {
                self.navigateLookUpMerRefNumPurchaseVC()  
            }
        }
        else  if (self.purchaseBankType == EFT_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let eft_AccountId = Utils.getEFT_AccountID() as? String
            let purchaseID = Utils.getEFT_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || eft_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_EFT)
            }
            else 
            {
                self.navigateLookUpMerRefNumPurchaseVC()  
            }
        }
            
        else  if (self.purchaseBankType == SEPA_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            let sepa_AccountId = Utils.getSEPA_AccountID() as? String
            let purchaseID = Utils.getSEPA_PurchaseID() as? String
            
            if  profileId == nil || addressId == nil || sepa_AccountId == nil || purchaseID == nil
            {
                self.showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_SEPA)
            }
            else 
            {
                self.navigateLookUpMerRefNumPurchaseVC()  
            }
        }
    }
    
    func navigateSubmitPurchaseVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let submitViewController = storyboard.instantiateViewControllerWithIdentifier("SubmitPurchaseViewController")  as! SubmitPurchaseViewController
        let array:Array = (self.title?.componentsSeparatedByString(" "))!
        submitViewController.title = String(format: "Submit %@ Purchase", array[0])
        submitViewController.purchaseBankType = self.purchaseBankType;
        self.navigationController?.pushViewController(submitViewController, animated: true)
        
    }
    
    func navigateCancelPurchaseVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cancelViewController = storyboard.instantiateViewControllerWithIdentifier("CancelPurchaseViewController")  as! CancelPurchaseViewController
        let array:Array = (self.title?.componentsSeparatedByString(" "))!
        cancelViewController.title = String(format: "Cancel %@ Purchase", array[0])
        cancelViewController.purchaseBankType = self.purchaseBankType;
        self.navigationController?.pushViewController(cancelViewController, animated: true)
        
    }
    func navigateLookUpPurchaseVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lookUpViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpPurchaseIDViewController")  as! LookUpPurchaseIDViewController
        let array:Array = (self.title?.componentsSeparatedByString(" "))!
        lookUpViewController.title = String(format: "LookUP %@ Purchase", array[0])
        lookUpViewController.purchaseBankType = self.purchaseBankType;
        self.navigationController?.pushViewController(lookUpViewController, animated: true)
    }
    
    func navigateLookUpMerRefNumPurchaseVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lookUpViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpPurchaseMerchantRefViewController")  as! LookUpPurchaseMerchantRefViewController
        let array:Array = (self.title?.componentsSeparatedByString(" "))!
        lookUpViewController.title = String(format: "LookUpMerID %@ Purchase", array[0])
        lookUpViewController.purchaseBankType = self.purchaseBankType;
        self.navigationController?.pushViewController(lookUpViewController, animated: true)
    }
    
    func showAlertView(strMessage:String){
        let alert = UIAlertView(title: nil, message: strMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
}
