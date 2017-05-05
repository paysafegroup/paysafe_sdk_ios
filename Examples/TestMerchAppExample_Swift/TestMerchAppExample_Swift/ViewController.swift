//
//  ViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 4/23/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        var dataDictonary: [String: String] = ["applicationPrimaryAccountNumber": "4111111111111111", "applicationExpirationDate":"181231" ,  "transactionAmount":"1499", "cardholderName":"Bill Gates"]
        //
        //
        //        var optTokenObj:OPTestFakeAppleToken = OPTestFakeAppleToken()
        //        optTokenObj.prepareRequestFakeApplePayToken(dataDictonary)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ x:UIStoryboardSegue) {
        self.navigationController?.popViewController(animated: true)
    }
}
