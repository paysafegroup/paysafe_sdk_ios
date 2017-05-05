//
//  AddressesOperationsViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class AddressesOperationsViewController: UIViewController 
{
    @IBOutlet var createAddressBtn : UIButton!
    @IBOutlet var updateAddressBtn : UIButton!
    @IBOutlet var lookUpAddressBtn : UIButton!
    @IBOutlet var deleteAddressBtn : UIButton!
    
    override func viewDidLoad() 
    {
        self.title = "Addresses"
        
        let backButton : UIBarButtonItem  = UIBarButtonItem.init(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) 
    {
        if  segue.identifier == "lookup"
        {
            let secondVC: AddressLookUpViewController = segue.destinationViewController as! AddressLookUpViewController            
            secondVC.title = "LookUp Profile"
            
        }
        else if segue.identifier == "delete"
        {
            let secondVC: AddressDeleteViewController = segue.destinationViewController as! AddressDeleteViewController
            secondVC.title = "Delete Profile"
        }
    }
    
     @IBAction func createAddressButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        if profileId == nil
        {
            self .showAlertView(ALERT_CREATE_PROFILE)
        }
        else 
        {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("AddressCreateUpdateViewController")  as! AddressCreateUpdateViewController
        
        achViewController.isCreateFlage = true
        self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }
    
    @IBAction func updateAddressButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        let addressId = Utils.getAddressID() as? String
        if profileId == nil || addressId == nil
        {
            self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
        }
        else 
        {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("AddressCreateUpdateViewController")  as! AddressCreateUpdateViewController
        achViewController.isCreateFlage = false
        self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }
    
    @IBAction func lookUpAddressButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        let addressId = Utils.getAddressID() as? String
        if profileId == nil || addressId == nil
        {
            self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
        }
        else 
        {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("AddressLookUpViewController")  as! AddressLookUpViewController
        self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }

    @IBAction func deleteAddressButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        let addressId = Utils.getAddressID() as? String
        if profileId == nil || addressId == nil
        {
            self .showAlertView(ALERT_CREATE_PROFILE_ADDRESS)
        }
        else 
        {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("AddressDeleteViewController")  as! AddressDeleteViewController
        self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }
    
    func showAlertView(strMessage:String)
    {
        let alert = UIAlertView(title: nil, message: strMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
}
