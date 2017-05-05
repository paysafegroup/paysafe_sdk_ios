//
//  AccountsViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit


class AccountsViewController: UIViewController {
    
   @IBOutlet var ach_BanksAccountBtn : UIButton!
   @IBOutlet var bacs_BanksAccountBtn : UIButton!
   @IBOutlet var eft_BanksAccountBtn : UIButton!
   @IBOutlet var sepa_BanksAccountBtn : UIButton!
    
   override func viewDidLoad() 
   {
    super.viewDidLoad()
    self.title = "Accounts";
     
    let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = backButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        let senderBtn:UIButton = sender as! UIButton
    
        let secondVC:AccountOperationsViewController  = segue.destinationViewController as! AccountOperationsViewController
    
        if(senderBtn.tag == 111) 
        {
            secondVC.accountBankType = ACH_BANK_TYPE;
        }
        else if(senderBtn.tag == 222)
        {
            secondVC.accountBankType = BACS_BANK_TYPE;
        }
        else if(senderBtn.tag == 333)
        {
            secondVC.accountBankType = EFT_BANK_TYPE;
        }
        else if(senderBtn.tag == 444)
        {
            secondVC.accountBankType = SEPA_BANK_TYPE;
        }
    }
}
