//
//  CreditCardViewController.h
//  TestMerchAppExample_Obj-C
//
//  Created by sachin on 21/05/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <Foundation/Foundation.h>
#import <iOS_SDK/PaySafePaymentAuthorizationProcess.h>


@interface CreditCardViewController : UIViewController <UITextFieldDelegate,PaysafePaymentAuthorizationProcessDelegate>
{

}


@property(retain,nonatomic) IBOutlet  UIScrollView *scrollView;
@property(retain,nonatomic) IBOutlet UITextField *txtCardNo;
@property(retain,nonatomic) IBOutlet UITextField *txtCvv;
@property(retain,nonatomic) IBOutlet UITextField *txtExpMonth;
@property(retain,nonatomic) IBOutlet UITextField *txtExpYear;
@property(retain,nonatomic) IBOutlet UITextField *txtNameOnCard;
@property(retain,nonatomic) IBOutlet UITextField *txtStreet1;
@property(retain,nonatomic) IBOutlet UITextField *txtStreet2;
@property(retain,nonatomic) IBOutlet UITextField *txtCity;
@property(retain,nonatomic) IBOutlet UITextField *txtCountry;
@property(retain,nonatomic) IBOutlet UITextField *txtState;
@property(retain,nonatomic) IBOutlet UITextField *txtZip;
@property(retain,nonatomic) IBOutlet UIButton *btnConfirm;
@property(retain,nonatomic) IBOutlet UIButton *btnCancel;
@property(retain,nonatomic) IBOutlet UIButton *btnBack;

@property(retain,nonatomic) NSString *amount;                     
@property (nonatomic, retain) PaySafePaymentAuthorizationProcess *PaysafeAuthPaymentController;
@property (nonatomic, retain) NSDictionary *tokenResponse;

-(IBAction)callToSDKforSIngleUseToken:(id)sender;

@end
