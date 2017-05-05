//
//  CustomerVaultViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class CustomerVaultViewController: UIViewController {
    
    @IBOutlet var profileBtn : UIButton!
    @IBOutlet var addressesBtn : UIButton!
    @IBOutlet var accountsBtn : UIButton!
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        self.title = "Customer Vault";
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
}
