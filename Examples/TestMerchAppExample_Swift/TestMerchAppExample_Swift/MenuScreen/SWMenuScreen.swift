//
//  MenuScreen.swift
//  TestMerchAppExample_Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/17/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import Foundation
import UIKit

class SWMenuScreen :UIViewController
{
        @IBOutlet var applePayBtn : UIButton!
        @IBOutlet var nonApplePayBtn : UIButton!
        @IBOutlet var threeDSBtn : UIButton!
        @IBOutlet var customerVaultPayBtn : UIButton! 
        @IBOutlet var ddBtn : UIButton!
        
    override func viewDidLoad()
    {
        self.title = "PaySafe"
    }
    
    @IBAction func applePayBtnSelected(sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Tvviewcontroller") 
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func nonApplePayBtnSelected(sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SWCreditCardViewController") 
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backPressed(x:UIStoryboardSegue) 
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
