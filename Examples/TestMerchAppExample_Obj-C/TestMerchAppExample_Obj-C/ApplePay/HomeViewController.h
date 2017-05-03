//
//  HomeViewController.h
//  TestQAMerchantApplication
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPTAuthorizationProcess.h"

#import <iOS_SDK/PaySafePaymentAuthorizationProcess.h>


#import "CreditCardViewController.h"


@interface HomeViewController : UIViewController <PaySafePaymentAuthorizationProcessDelegate, UITextFieldDelegate, AuthorizationProcessDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UIButton *payButton;
@property (nonatomic, retain) IBOutlet UIButton *authButton;
@property (nonatomic, retain) IBOutlet UILabel *merchantRefLbl;
@property (nonatomic, retain) IBOutlet UISwitch *settleSwitch;
@property (nonatomic, retain) IBOutlet UILabel *switchLbl;
@property (nonatomic, retain) IBOutlet UILabel *amtLbl;
@property (nonatomic, retain) IBOutlet UITextField *merchantRefTxt;
@property (nonatomic, retain) IBOutlet UITextField *amountTxt;

@property (nonatomic, retain) IBOutlet UIButton *btnBack;

@property (nonatomic, retain) PaySafePaymentAuthorizationProcess *PaysafeAuthController;
@property (nonatomic, retain) OPTAuthorizationProcess *OPTAuthObj;


-(IBAction)homePayBtnSelected:(id)sender;
-(IBAction)switchToggled:(id)sender ;
-(IBAction)authorizeBtnSelected:(id)sender;

@end
