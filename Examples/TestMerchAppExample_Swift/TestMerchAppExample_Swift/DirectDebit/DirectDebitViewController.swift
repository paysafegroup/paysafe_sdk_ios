//
//  DirectDebitViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 28/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class DirectDebitViewController: UIViewController {
    
    @IBOutlet var purchaseOperationsBtn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.title = "Direct Debit"
    }
}