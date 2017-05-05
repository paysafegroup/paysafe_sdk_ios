//
//  PurchaseViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 29/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class PurchaseViewController: UIViewController {
    
    @IBOutlet var ACH_PurchaseBtn : UIButton!
    @IBOutlet var BACS_PurchaseBtn : UIButton!
    @IBOutlet var EFT_PurchaseBtn : UIButton!
    @IBOutlet var SEPA_PurchaseBtn : UIButton!
    
    override func viewDidLoad() {
   super.viewDidLoad()
    self.title = "Purchase";
    // Do any additional setup after loading the view.
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
       let senderBtn:UIButton = sender as! UIButton
    
        let secondVC:PurchaseOperationsViewController  =  segue.destinationViewController as! PurchaseOperationsViewController;
    
        if senderBtn.tag == 111
        {
            secondVC.purchaseBankType = ACH_BANK_TYPE
        }
        else if senderBtn.tag == 222
        {
            secondVC.purchaseBankType = BACS_BANK_TYPE
        }
        else if senderBtn.tag == 333
        {
            secondVC.purchaseBankType = EFT_BANK_TYPE
        }
        else if senderBtn.tag == 444
        {
            secondVC.purchaseBankType = SEPA_BANK_TYPE
        }
    }
}
