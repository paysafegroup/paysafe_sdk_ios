//
//  HomeViewController.m
//  TestQAMerchantApplication
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuScreen.h"
#import "CreditCardViewController.h"

@interface HomeViewController ()

{
    NSDictionary *tokenResponse;
    BOOL isSwitchOn;
}


@end

@implementation HomeViewController
@synthesize authButton,merchantRefLbl,merchantRefTxt,switchLbl,amountTxt,amtLbl,settleSwitch,btnBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    btnBack.layer.cornerRadius = 10;
    
    [self getDataFromPlist];
    
    if (!([self.OPAYAuthController isApplePaySupport])) {
        [self.payButton setImage:[UIImage imageNamed:@"payNow_img.png"] forState:UIControlStateNormal];
    }
    
    merchantRefTxt.text = @"test_2015_323_sdfa";
    merchantRefTxt.delegate = self;
    amountTxt.delegate = self;
    
    authButton.hidden = true;
    
}

- (void)getDataFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MerchantRealConfiguration" ofType:@"plist"];
    
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *merchantUserID = [myDictionary objectForKey:@"OptiMerchantID"];
    
    NSString *merchantPassword =[myDictionary objectForKey:@"OptiMerchantPassword"];
    
    NSString *merchantCountryCode = [myDictionary objectForKey:@"countryCode"];
    
    NSString *merchantCurrencyCode = [myDictionary objectForKey:@"CurrencyCode"];
    
    NSString *appleMerchantIdentifier = [myDictionary objectForKey:@"merchantIdentifier"];
    
    self.OPAYAuthController = [[OPAYPaymentAuthorizationProcess alloc] initWithMerchantIdentifier:appleMerchantIdentifier withMerchantID:merchantUserID withMerchantPwd:merchantPassword withMerchantCountry:merchantCountryCode withMerchantCurrency:merchantCurrencyCode];
}


/* ---------------------- pay button ----------------------- */


-(IBAction)homePayBtnSelected:(id)sender{
    
    if([amountTxt.text isEqualToString:@""] || [amountTxt.text isEqualToString:nil]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Amount should not be empty/zero." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
#if TARGET_IPHONE_SIMULATOR
    
    self.OPAYAuthController.authDelegate = self;
    [self.OPAYAuthController beginPayment:self withRequestData:[self createDataDictionary] withCartData:[self cartData]];
    
    
#else
    if([self.OPAYAuthController isApplePaySupport]==false)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Device does not support Apple Pay!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        [self callNonApplePayFlow];

    } else
    {
        
        self.OPAYAuthController.authDelegate = self;
       [self.OPAYAuthController beginPayment:self withRequestData:[self createDataDictionary] withCartData:[self cartData]];
                
    }

    
#endif
    
}

-(IBAction)authorizeBtnSelected:(id)sender{
    
    self.OPTAuthObj = [[OPTAuthorizationProcess alloc] init];
    self.OPTAuthObj.processDelegate = self;
    [self.OPTAuthObj prepareRequestForAuthorization:[self createAuthDataDictonary]];
    
    
}
/* --------------- Creating data dictionaries -------------- */


-(NSMutableDictionary *)createDataDictionary{
    // Merchant shipping methods
    NSString *shippingMethodName = @"Llma California Shipping";
    NSString *shippingMethodAmount = @"1.00";
    NSString *shippingMethodDescription = @"3-5 Business Days";
    
    NSDictionary *shippingMethod = [NSDictionary dictionaryWithObjectsAndKeys:shippingMethodName,@"shippingName",shippingMethodAmount,@"shippingAmount", shippingMethodDescription,@"shippingDes", nil];
    
    
    NSString *envType = @"TEST_ENV";  //PROD_ENV TEST_ENV
    NSString *timeIntrval = @"30.0";
    
    NSDictionary *envSettingDict = [NSDictionary dictionaryWithObjectsAndKeys:envType,@"EnvType",timeIntrval,@"TimeIntrval",nil];
    
    NSMutableDictionary *finalDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:shippingMethod, @"ShippingMethod",envSettingDict,@"EnvSettingDict", nil ];
    
    
    return finalDataDictionary;
}

-(NSDictionary*)cartData{
    
    // Merchant Cart data
    
    NSString *cartID =@"123423";
    NSString *cartTitle = @"TShirt";
    NSString *cartCost = amountTxt.text;
    NSString *cartDiscount = @"3";
    NSString *cartShippingCost =@"2";
    NSString *payTo =@"Llama Services, Inc.";
    
    NSDictionary *cartDictonary = [NSDictionary dictionaryWithObjectsAndKeys:cartID,@"CartID",cartTitle,@"CartTitle",cartCost,@"CartCost",cartDiscount, @"CartDiscount", cartShippingCost,@"CartShippingCost" , payTo, @"PayTo", nil];

    
    return cartDictonary;
}


/* ----- OPTPaymentAuthorizationViewControllerDelegate ---- */
#pragma mark OPTPaymentAuthorizationViewControllerDelegate
 
-(void)callBackResponseFromOPTSDK:(NSDictionary*)response
{

    if(response)
    {
        NSDictionary *errorDict=[response objectForKey:@"error"];
        
        NSString *code;
        NSString *message;
        
        if(errorDict){
            code=[errorDict objectForKey:@"code"];
            message=[errorDict objectForKey:@"message"];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:code message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            tokenResponse = [NSDictionary dictionaryWithDictionary:response];
            
            
            NSString *message = [NSString stringWithFormat:@"Your Payment Token is :: %@", [response objectForKey:@"paymentToken"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            authButton.hidden = false;
            
            
        }
    }else{
        //Error handling
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Error message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)callNonAppleFlowFromOPTSDK
{
    [self callNonApplePayFlow];

}


-(void)callBackAuthorizationProcess:(NSDictionary*)dictonary{
    
    NSDictionary *errorDict=[dictonary objectForKey:@"error"];
    
    NSString *code;
    NSString *message;
    
    if(errorDict){
        code=[errorDict objectForKey:@"code"];
        message=[errorDict objectForKey:@"message"];
        
        [self showAlert:code message:message];
    }
    else if([([dictonary objectForKey:@"status"]) isEqualToString:@"COMPLETED"])
    {
        NSNumber* authObject =[dictonary objectForKey:@"settleWithAuth"];
        
        if([authObject boolValue]== 0)
        {
            code=@"Success";
            message=@"Authorization completed, please proceed for settlement.";
            [self showAlert:code message:message];
        }else{
            code=@"Success";
            message=@"Settlement got completed, please check your order history.";
            [self showAlert:code message:message];
            
        }
    }
}
-(void)showAlert:(NSString*)code message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:code
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];

}
-(NSDictionary *)createAuthDataDictonary{
    
    NSDictionary *txnDic = tokenResponse[@"transaction"];
    NSString *amount = [txnDic valueForKey:@"amount"];
    
    NSDictionary *cardDictonary = [NSDictionary dictionaryWithObjectsAndKeys:[tokenResponse valueForKey:@"paymentToken"],@"paymentToken", nil];
    
    NSMutableDictionary *authDictonary =[[NSMutableDictionary alloc]init];
    [authDictonary setObject:merchantRefTxt.text forKey:@"merchantRefNum"];
     [authDictonary setObject:amount forKey:@"amount"];
     [authDictonary setObject:cardDictonary forKey:@"card"];
     [authDictonary setObject:@"Hand bag - Big" forKey:@"description"];
     [authDictonary setObject:@"10.10.345.114" forKey:@"customerIp"];
    if(isSwitchOn){
        [authDictonary setObject:@"true" forKey:@"settleWithAuth"];
    }else{
        [authDictonary setObject:@"false" forKey:@"settleWithAuth"];
    }
        
    return authDictonary;
}


- (IBAction)switchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn])
    {
        isSwitchOn = true;
    } else
    {
        isSwitchOn = false;
    }
}

// became first responder
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return false;
}

#pragma mark End

/* --------------------------------------------------------- */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callNonApplePayFlow
{
    
    CreditCardViewController *creditCardViewController=[[CreditCardViewController alloc]init];
    creditCardViewController.amount=amountTxt.text;
    creditCardViewController.OPAYAuthPaymentController=self.OPAYAuthController;
    UIStoryboard *storyboard = self.storyboard;
    creditCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    [self presentViewController:creditCardViewController animated:YES completion:nil];
}

-(void)getTokenUseingCard:(NSDictionary *)response
{
    [self callBackResponseFromOPTSDK:response];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
