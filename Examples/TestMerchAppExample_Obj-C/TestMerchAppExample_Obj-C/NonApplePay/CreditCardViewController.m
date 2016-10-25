//
//  CreditCardViewController.m
//  TestMerchAppExample_Obj-C
//
//  Created by sachin on 21/05/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import "CreditCardViewController.h"
#import "Constant.h"

@interface CreditCardViewController ()

@property (retain,nonatomic) NSMutableDictionary *responseData;
@end

@implementation CreditCardViewController


@synthesize scrollView;
@synthesize txtCardNo,txtCity,txtCountry,txtCvv,txtExpYear,txtNameOnCard,txtState,txtStreet1,txtStreet2,txtZip,txtExpMonth,btnBack,btnCancel,btnConfirm,amount,tokenResponse;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Non Apple Pay";

    // Do any additional setup after loading the view.

    
    scrollView.contentSize=CGSizeMake(320,1500);
    txtCardNo.delegate=self;
    txtCity.delegate=self;
    txtCountry.delegate=self;
    txtExpYear.delegate=self;
    txtNameOnCard.delegate=self;
    txtState.delegate=self;
    txtStreet1.delegate=self;
    txtStreet2.delegate=self;
    txtZip.delegate=self;
    txtExpMonth.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return false;
}

-(NSMutableDictionary *)createDataDictionary
{
    NSMutableDictionary *cardExpData= [[NSMutableDictionary alloc]init];
    [cardExpData setValue:txtExpMonth.text forKey:@"month"];
    [cardExpData setValue:txtExpYear.text forKey:@"year"];
    
    NSMutableDictionary *cardBillingAddress= [[NSMutableDictionary alloc]init];
    
    [cardBillingAddress setValue:txtStreet1.text forKey:@"street"];
    [cardBillingAddress setValue:txtStreet2.text forKey:@"street2"];
    [cardBillingAddress setValue:txtCity.text forKey:@"city"];
    [cardBillingAddress setValue:txtCountry.text forKey:@"country"];
    [cardBillingAddress setValue:txtState.text forKey:@"state"];
    [cardBillingAddress setValue:txtZip.text forKey:@"zip"];
    
    NSMutableDictionary *cardData= [[NSMutableDictionary alloc]init];
    [cardData setValue:txtCardNo.text forKey:@"cardNum"];
    [cardData setValue:txtNameOnCard.text forKey:@"holderName"];
    [cardData setValue:cardExpData forKey:@"cardExpiry"];
    [cardData setValue:cardBillingAddress forKey:@"billingAddress"];
    
    NSMutableDictionary *cardDataDetails= [[NSMutableDictionary alloc]init];
    [cardDataDetails setValue:cardData forKey:@"card"];
    
    return cardDataDetails;
}

-(IBAction)callToSDKforSIngleUseToken:(id)sender
{
    [self getDataFromPlist];
    
    NSString *envType = @"TEST_ENV";  //PROD_ENV TEST_ENV
    NSString *timeIntrval = @"30.0";
    
    NSMutableDictionary *envSettingDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:envType,@"EnvType",timeIntrval,@"TimeIntrval",nil];
    
    self.PaysafeAuthPaymentController.authDelegate = self;
    if([self.PaysafeAuthPaymentController respondsToSelector:@selector(beginNonApplePayment:withRequestData:withEnvSettingDict:)])
    {
        [self.PaysafeAuthPaymentController beginNonApplePayment:self withRequestData:[self createDataDictionary] withEnvSettingDict:envSettingDict];
    }
}

- (void)getDataFromPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MerchantRealConfiguration" ofType:@"plist"];
    
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *merchantUserID = [myDictionary objectForKey:@"MerchantID"];
    NSString *merchantPassword =[myDictionary objectForKey:@"MerchantPassword"];
    NSString *merchantCountryCode = [myDictionary objectForKey:@"countryCode"];
    NSString *merchantCurrencyCode = [myDictionary objectForKey:@"CurrencyCode"];
    NSString *appleMerchantIdentifier = [myDictionary objectForKey:@"merchantIdentifier"];
    
    self.PaysafeAuthPaymentController = [[PaySafePaymentAuthorizationProcess alloc] initWithMerchantIdentifier:appleMerchantIdentifier withMerchantID:merchantUserID withMerchantPwd:merchantPassword withMerchantCountry:merchantCountryCode withMerchantCurrency:merchantCurrencyCode];
}

-(void)callBackResponseFromOPTSDK:(NSDictionary *)response
{
    [self callSplitResponse:response];
}

-(void)callSplitResponse:(NSDictionary*)response
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
        }
    }
    else
    {
        //Error handling
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Error message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)backPressed:(UIStoryboardSegue *)seque
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callNonAppleFlowFromOPTSDK
{
    
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
