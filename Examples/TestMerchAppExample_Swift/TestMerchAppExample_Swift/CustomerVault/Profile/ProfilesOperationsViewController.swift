//
//  ProfilesOperationsViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by Opus on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

import Foundation
import UIKit

class ProfilesOperationsViewController: UIViewController 
{
    @IBOutlet var confirmBtn : UIButton!
    @IBOutlet var createProfileBtn : UIButton!
    @IBOutlet var updateProfileBtn : UIButton!
    @IBOutlet var lookProfileSubcomponentsBtn : UIButton!
    @IBOutlet var lookUpProfileBtn : UIButton!
    @IBOutlet var deleteProfileBtn : UIButton!
    
    override func viewDidLoad() 
    {
        self.title = "Profile"
    
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
        else if segue.identifier == "lookupSub"
        {
            let secondVC: ProfileLookUpWithSubComponentsViewController = segue.destinationViewController as! ProfileLookUpWithSubComponentsViewController
            secondVC.title = "LookUp SubComponents Profile"
        }
    }
    
    @IBAction func createProfileButtonClicked(sender:UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileCreateUpdateViewController")  as! ProfileCreateUpdateViewController
        
        achViewController.isCreateFlage = true
        self.navigationController?.pushViewController(achViewController, animated: true)
    }
    
    @IBAction func updateProfileButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        if  profileId == nil 
        {
            self .showAlertView(ALERT_CREATE_PROFILE)
        }
        else {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let achViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileCreateUpdateViewController")  as! ProfileCreateUpdateViewController
        achViewController.isCreateFlage = false
        self.navigationController?.pushViewController(achViewController, animated: true)
    }
    }    
    
    @IBAction func lookupProfileButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        if  profileId == nil 
        {
            self .showAlertView(ALERT_CREATE_PROFILE)
        }
        else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let achViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileLookUpViewController")  as! ProfileLookUpViewController
            self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }

    @IBAction func lookupSubProfileButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        if  profileId == nil 
        {
            self .showAlertView(ALERT_CREATE_PROFILE)
        }
        else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let achViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileLookUpWithSubComponentsViewController")  as! ProfileLookUpWithSubComponentsViewController
            self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }
    
    @IBAction func deleteProfileButtonClicked(sender:UIButton)
    {
        let profileId = Utils.getProfileID() as? String
        if  profileId == nil 
        {
            self .showAlertView(ALERT_CREATE_PROFILE)
        }
        else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let achViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileDeleteViewController")  as! ProfileDeleteViewController
            self.navigationController?.pushViewController(achViewController, animated: true)
        }
    }
    
    func showAlertView(strMessage:String)
    {
        let alert = UIAlertView(title: nil, message: strMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
    }
}

    
   