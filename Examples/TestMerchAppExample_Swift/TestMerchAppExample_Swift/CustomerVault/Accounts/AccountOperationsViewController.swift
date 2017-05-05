//
//  AccountOperationsViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit


class AccountOperationsViewController:UIViewController  {
    
    @IBOutlet var create_BankAccountBtn : UIButton!
    @IBOutlet var lookup_BankAccountBtn : UIButton!
    @IBOutlet var update_BankAccountBtn : UIButton!
    @IBOutlet var delete_BankAccountBtn : UIButton!
    
    var accountBankType: Int!

override func viewDidLoad() 
{
    if self.accountBankType == ACH_BANK_TYPE {
        self.title = "ACH Account"
    }
    else if self.accountBankType == BACS_BANK_TYPE {
        self.title = "BACS Account"
    }
    else if self.accountBankType == EFT_BANK_TYPE {
        self.title = "EFT Account"
    }
    else if self.accountBankType == SEPA_BANK_TYPE {
        self.title = "SEPA Account"
    }
    
    let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backButton
}

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
{
    if  segue.identifier == "lookup"
    {
        let secondVC: LookUpAccountViewController = segue.destinationViewController as! LookUpAccountViewController
       
        var array:Array = (self.title?.componentsSeparatedByString(" "))!
        secondVC.title = String(format:"Lookup %@ Account", array[0])
        secondVC.accountBankType = self.accountBankType;
    }
    else if segue.identifier == "delete"
    {
        let secondVC: DeleteAccountViewController = segue.destinationViewController as! DeleteAccountViewController
        
        var array:Array = (self.title?.componentsSeparatedByString(" "))!
        secondVC.title = String(format:"Delete %@ Account", array[0])
        secondVC.accountBankType = self.accountBankType;
    }
   }
    
    @IBAction func createAccountViewController(sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (self.accountBankType == ACH_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            
            if  profileId == nil || addressId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
            }
            else 
            {
            let achViewController = storyboard.instantiateViewControllerWithIdentifier("ACHCreateUpdateViewController")  as! ACHCreateUpdateViewController
            
            achViewController.isCreateFlage = true
            self.navigationController?.pushViewController(achViewController, animated: true)
            }
        }
        else if self.accountBankType == BACS_BANK_TYPE {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            
            if  profileId == nil || addressId == nil 
            {
                self .showAlertView( ALERT_CREATE_PROFILE_ADDRESS)
            }
            else 
            {

            let bacsViewController = storyboard.instantiateViewControllerWithIdentifier("BACSCreateUpdateViewController") as! BACSCreateUpdateViewController
            bacsViewController.isCreateFlage = true;
            self.navigationController?.pushViewController(bacsViewController, animated: true)
            }
        }
        else if (self.accountBankType == EFT_BANK_TYPE) {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            
            if  profileId == nil || addressId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
            }
            else 
            {

            let eftViewController = storyboard.instantiateViewControllerWithIdentifier("EFTCreateUpdateViewController") as! EFTCreateUpdateViewController
            eftViewController.isCreateFlage = true;
            self.navigationController?.pushViewController(eftViewController, animated: true)
            }
        }
        else if (self.accountBankType == SEPA_BANK_TYPE) 
        {
            let profileId = Utils.getProfileID() as? String
            let addressId = Utils.getAddressID() as? String
            
            if  profileId == nil || addressId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
            }
            else 
            {
            let sepaViewController = storyboard.instantiateViewControllerWithIdentifier("SEPACreateUpdateViewController") as! SEPACreateUpdateViewController
            sepaViewController.isCreateFlage = true;
            self.navigationController?.pushViewController(sepaViewController, animated: true)
            }
        }
    }
    
    @IBAction func updateAccountViewController(sender:UIButton)
    {
        if (self.accountBankType == ACH_BANK_TYPE) 
        {
                let accountId = Utils.getACH_AccountID() as? String
                if  accountId == nil
                {
                    self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
                }
                else 
                {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let achViewController = storyboard.instantiateViewControllerWithIdentifier("ACHCreateUpdateViewController") as!  ACHCreateUpdateViewController
            achViewController.isCreateFlage = false;
            self.navigationController?.pushViewController(achViewController, animated: true)
            }
        }
        else if self.accountBankType == BACS_BANK_TYPE 
            {
                let accountId = Utils.getBACS_AccountID() as? String
                if  accountId == nil
                {
                    self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
                }
                else 
                {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bacsViewController = storyboard.instantiateViewControllerWithIdentifier("BACSCreateUpdateViewController") as!  BACSCreateUpdateViewController
            bacsViewController.isCreateFlage = false;
            self.navigationController?.pushViewController(bacsViewController, animated: true)
                }
        }
        else if (self.accountBankType == EFT_BANK_TYPE) {
           
            let accountId = Utils.getEFT_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
            }
            else 
            {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let eftViewController = storyboard.instantiateViewControllerWithIdentifier("EFTCreateUpdateViewController") as!  EFTCreateUpdateViewController
            eftViewController.isCreateFlage = false;
            self.navigationController?.pushViewController(eftViewController, animated: true)
            }
        }
        else if (self.accountBankType == SEPA_BANK_TYPE) {
           
            let accountId = Utils.getSEPA_AccountID() as? String
            if accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
            }
            else 
            {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sepaViewController = storyboard.instantiateViewControllerWithIdentifier("SEPACreateUpdateViewController") as!  SEPACreateUpdateViewController
            sepaViewController.isCreateFlage = false;
            self.navigationController?.pushViewController(sepaViewController, animated: true)
            }
        }
    }    
    
    @IBAction func deleteAccountViewController(sender:UIButton)
    {
        if (self.accountBankType == ACH_BANK_TYPE) 
        {
            let accountId = Utils.getACH_AccountID() as? String            
            if  accountId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let achViewController = storyboard.instantiateViewControllerWithIdentifier("DeleteAccountViewController")  as! DeleteAccountViewController
                achViewController.accountBankType = self.accountBankType
                
             self.navigationController?.pushViewController(achViewController, animated: true)
            }
        }
        else if self.accountBankType == BACS_BANK_TYPE {
            let accountId = Utils.getBACS_AccountID() as? String            
            if  accountId == nil  
            {
                self .showAlertView( ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let bacsViewController = storyboard.instantiateViewControllerWithIdentifier("DeleteAccountViewController") as! DeleteAccountViewController
                bacsViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(bacsViewController, animated: true)
            }
        }
        else if (self.accountBankType == EFT_BANK_TYPE) {
            let accountId = Utils.getEFT_AccountID() as? String            
            if  accountId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let eftViewController = storyboard.instantiateViewControllerWithIdentifier("DeleteAccountViewController") as! DeleteAccountViewController
                eftViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(eftViewController, animated: true)
            }
        }
        else if (self.accountBankType == SEPA_BANK_TYPE) 
        {
            let accountId = Utils.getSEPA_AccountID() as? String            
            if  accountId == nil 
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sepaViewController = storyboard.instantiateViewControllerWithIdentifier("DeleteAccountViewController") as! DeleteAccountViewController
                sepaViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(sepaViewController, animated: true)
            }
        }
    }
    
    @IBAction func lookUpAccountViewController(sender:UIButton)
    {
        
        if (self.accountBankType == ACH_BANK_TYPE) 
        {
            let accountId = Utils.getACH_AccountID() as? String
            if accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let achViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpAccountViewController") as!  LookUpAccountViewController
                achViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(achViewController, animated: true)
            }
        }
        else if self.accountBankType == BACS_BANK_TYPE 
        {
            let accountId = Utils.getBACS_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let bacsViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpAccountViewController") as!  LookUpAccountViewController
                bacsViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(bacsViewController, animated: true)
            }
        }
        else if (self.accountBankType == EFT_BANK_TYPE) {
        
            let accountId = Utils.getEFT_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let eftViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpAccountViewController") as!  LookUpAccountViewController
                eftViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(eftViewController, animated: true)
            }
        }
        else if (self.accountBankType == SEPA_BANK_TYPE) {
        
            let accountId = Utils.getSEPA_AccountID() as? String
            if  accountId == nil
            {
                self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA)
            }
            else 
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sepaViewController = storyboard.instantiateViewControllerWithIdentifier("LookUpAccountViewController") as!  LookUpAccountViewController
                sepaViewController.accountBankType = self.accountBankType
                self.navigationController?.pushViewController(sepaViewController, animated: true)
            }
        }
    }    

        func showAlertView(strMessage:String){
            let alert = UIAlertView(title: nil, message: strMessage, delegate: self, cancelButtonTitle: "OK")
            alert .show()
        }
}
