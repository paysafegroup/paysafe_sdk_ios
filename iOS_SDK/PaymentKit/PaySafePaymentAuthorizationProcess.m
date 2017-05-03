//
//  PaySafePaymentAuthorizationProcess.m
//  iOS_SDK
//
//  Created by Sachin Barage on 09/10/15.
//  Copyright © 2015 Paysafe. All rights reserved.
//

#import <Availability.h>
#import "PaySafePaymentAuthorizationProcess.h"
#import "PaySafePayment.h"
#import "PaySafeDef.h"
#import "PaySafeApplePayPaymentTokenInfo.h"
#import "PaySafeRequestApplePaySingleUseTokens.h"
#import "PaySafeMockPaymentAuthorizationProcess.h"
#import "PaySafeConstants.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface PaySafePaymentAuthorizationProcess ()  <UIViewControllerTransitioningDelegate,NSURLConnectionDelegate,PKPaymentAuthorizationViewControllerDelegate,PaySafeMockPaymentAuthorizationProcessDelegate>
{
    NSURLConnection *connection;
    
    NSDictionary *merchantCartDictonary;
    NSDictionary *shippingMethodData;
    BOOL isHavingStubs;
    NSDictionary *envSettingDict;
}

@property(nonatomic, assign)id<PKPaymentAuthorizationViewControllerDelegate>pkDelegate;

@property (strong) NSData *paymentTokenData;
@property (nonatomic) NSDecimalNumber *amount;


// URL ///
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSString *baseURL;
@property (retain) id requestData;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic , retain) UIView *optViewController;
@property(nonatomic, strong) PaySafeMockPaymentAuthorizationProcess *testPaymentAuthorizationProcess;

@end

@implementation PaySafePaymentAuthorizationProcess
@synthesize authDelegate,amount;
@synthesize responseData,baseURL,requestData;
@synthesize activityIndicator,optViewController,testPaymentAuthorizationProcess;


- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd withMerchantCountry:(NSString*)merchantCountry withMerchantCurrency:(NSString*)merchantCurrency
{
    // Set the data for all objects !!!
    
    PaySafeDef.merchantUserID=optiMerchantID;
    PaySafeDef.merchantPassword=optiMerchantPwd;
    
    PaySafeDef.merchantIdentifier=merchantIdentifier;
    PaySafeDef.countryCode=merchantCountry;
    PaySafeDef.currencyCode=merchantCurrency;
    
    return self;
}

- (BOOL)isApplePaySupport
{
    /* If we are running the app in Device this method retuns TRUE.
     If we are running the simulator it returns FALSE.
     */
    
    BOOL isOk = false;
#if TARGET_IPHONE_SIMULATOR
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOSSupportedVersion)) {
        isOk = false;
        isHavingStubs = true;
        
    }
    else
    {
        isHavingStubs = false;
        isOk = false;
        
        return isOk;
    }
    
#else
    
    isHavingStubs = false;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOSSupportedVersion)) {
        if ([PKPaymentAuthorizationViewController canMakePayments] && ([self canHaveValidNetworks])) {
            return true;
        }
    } else if(SYSTEM_VERSION_LESS_THAN(iOSSupportedVersion)) {
        isOk = false;
    }
    
#endif
    return isOk;
}

- (BOOL)canHaveValidNetworks{
    
    /* If we are running the app in Device & we have valid/apple verified Amex, MasterCard and
     Visa cards available in Device passbook ( for apple pay ) then this method retuns TRUE.
     If we are running the simulator it returns FALSE.
     */
    NSArray *SupportedPaymentNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    return [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:SupportedPaymentNetworks];
}

-(void)beginPayment:(UIViewController *)viewController withRequestData:(NSDictionary*)dataDictionary withCartData:(NSDictionary*)cartData
{
    optViewController=viewController.view;
    
    
#if TARGET_IPHONE_SIMULATOR
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    {
        //Call Mock Library
        self.testPaymentAuthorizationProcess=[[PaySafeMockPaymentAuthorizationProcess alloc]init];
        self.testPaymentAuthorizationProcess.authTestDelegate = self;
        
        
        [self.testPaymentAuthorizationProcess showPaymentSummeryView:viewController delgate:self.testPaymentAuthorizationProcess withIdentifier:PaySafeDef.merchantIdentifier withMerchantID:PaySafeDef.merchantUserID withMerchantPwd:PaySafeDef.merchantPassword withMerchantCountry:PaySafeDef.countryCode withMerchantCurrency:PaySafeDef.currencyCode withRequestData:dataDictionary withCartData:cartData];
    }
#else
    {
        // iOS Simulator using iOS less then 8.1 version !!!
        NSLog(@"%@:%@",MerchantAlertTitle,MerchantAlertApplePayNotAvailableMsg);
    }
#endif
#else
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    {
        
        // Placing data into SDK
        shippingMethodData = [dataDictionary objectForKey:MerchantShippingDictionary];
        envSettingDict=[dataDictionary objectForKey:MerchantEnvSettinsDictionary];
        
        merchantCartDictonary =  cartData;
        // End of Placing data
        
        //Env setting
        PaySafeDef.timeInterval=[envSettingDict valueForKey:MerchantTimeInterval];
        PaySafeDef.envType=[envSettingDict valueForKey:MerchantEnvironmentType];
        
        NSString *merchantId = PaySafeDef.merchantIdentifier ;
        
        PKPaymentRequest *paymentRequest = [PaySafePayment paymentRequestWithMerchantIdentifier:merchantId];
        
        if ( [PKPaymentAuthorizationViewController canMakePayments ])
        {
            if ([PaySafePayment canSubmitPaymentRequest:paymentRequest])
            {
                
                [paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
                [paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
                paymentRequest.merchantCapabilities=PKMerchantCapability3DS;
                
                if (shippingMethodData == nil || [shippingMethodData count]==0)
                {
                    paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod];
                } else
                {
                    paymentRequest.shippingMethods =[self getShippingMethod];
                    paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:paymentRequest.shippingMethods.firstObject];
                }
                
                PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
                auth.delegate=self;
                
                [viewController presentViewController:auth animated:YES completion:nil];
            
            }
            else
            {
                //User cannot authorize payments on these networks!!
                [self.authDelegate callNonAppleFlowFromOPTSDK];
                NSLog(@"%@:%@",MerchantAlertTitle,MerchantAlertNetworksNotAvailableMsg);
            }
        }
        else
        {
            //Device does not support making Apple Pay payments!
            [self.authDelegate callNonAppleFlowFromOPTSDK];
            NSLog(@"%@:%@",MerchantAlertTitle,MerchantAlertDeviceNotSupportMsg);
        }
    }
#else
    {
        //Device does not support Apple Pay below 8.1 iOS
        [self.authDelegate callNonAppleFlowFromOPTSDK];
        NSLog(@"%@:%@",MerchantAlertTitle,MerchantAlertDeviceNotSupportIOSMsg);
    }
#endif
#endif
}

- (NSArray *)getShippingMethod
{
    PKShippingMethod *normalItem =[PKShippingMethod summaryItemWithLabel:[shippingMethodData valueForKey:MerchantShippingName] amount:[NSDecimalNumber decimalNumberWithString:[shippingMethodData valueForKey:MerchantShippingAount]]];
    normalItem.detail = [shippingMethodData valueForKey:MerchantShippingDescription];
    normalItem.identifier = normalItem.label;
    
    return  @[normalItem];
}

- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
    
    
    self.amount=[[NSDecimalNumber alloc] initWithString:[merchantCartDictonary valueForKey:MerchantCartCost]];
    
    PKPaymentSummaryItem *summeryItem = [PKPaymentSummaryItem summaryItemWithLabel:[merchantCartDictonary valueForKey:MerchantCartTitle] amount:self.amount];
    NSDecimalNumber *total = [summeryItem.amount decimalNumberByAdding:shippingMethod.amount];
    
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:[merchantCartDictonary valueForKey:MerchantCartPayto] amount:total];
    
    return @[summeryItem,shippingMethod,totalItem];
}

- (NSArray *)summaryItemsForShippingMethod
{
    self.amount=[[NSDecimalNumber alloc] initWithString:[merchantCartDictonary valueForKey:MerchantCartCost]];
    
    PKPaymentSummaryItem *summeryItem = [PKPaymentSummaryItem summaryItemWithLabel:[merchantCartDictonary valueForKey:MerchantCartTitle] amount:self.amount];
    NSDecimalNumber *total =self.amount;
    
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:[merchantCartDictonary valueForKey:MerchantCartPayto] amount:total];
    
    return @[summeryItem,totalItem];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    PaySafeRequestApplePaySingleUseTokens *applePaySingleUseTokens=[[PaySafeRequestApplePaySingleUseTokens alloc]init];
    //Token info shoud be set here
    NSData *tokenData =payment.token.paymentData;
    
    self.paymentTokenData = [applePaySingleUseTokens prepareRequestRealToken:tokenData];
    
    completion(PKPaymentAuthorizationStatusSuccess);
    
    //Start animation
    [self showActivityViewer];
    //Customer vault server call
    [self requestServiceByName:SingleUserTokneServiceRequest];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:true completion:nil];
}

///////////// Non Apple Flow /////////////////
-(void)beginNonApplePayment:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData withEnvSettingDict:(NSDictionary*)envSettingData
{
    optViewController=viewController.view;
    
    envSettingDict=envSettingData;
    
    //Env setting
    PaySafeDef.timeInterval=[envSettingDict valueForKey:MerchantTimeInterval];
    PaySafeDef.envType=[envSettingDict valueForKey:MerchantEnvironmentType];
    
    NSError *jsonSerializationError = nil;
    self.paymentTokenData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    
    [self showActivityViewer];
    [self requestServiceByName:NonApplePaySingleUserTokneServiceRequest];
}

/////////// End ///////////////
///////////// FOR PAYSAFE VAULT CONNECTION   //////////

- (void)requestServiceByName:(NSString *)serviceName
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel=[PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:SingleUserTokneServiceRequest])
    {
        
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/customervault/v1/applepaysingleusetokens",[PaySafeDef getOptimalUrl]];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataSubmit = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataSubmit setHTTPMethod:@"POST"]; // 1
        [dataSubmit setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataSubmit setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.paymentTokenData length]] forHTTPHeaderField:@"Content-Length"];
        [dataSubmit setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataSubmit setHTTPBody:self.paymentTokenData];
        connection = [[NSURLConnection alloc]initWithRequest:dataSubmit delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:NonApplePaySingleUserTokneServiceRequest])
    {
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/customervault/v1/singleusetokens",[PaySafeDef getOptimalUrl]];
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataSubmit = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataSubmit setHTTPMethod:@"POST"]; // 1
        [dataSubmit setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataSubmit setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.paymentTokenData length]] forHTTPHeaderField:@"Content-Length"];
        [dataSubmit setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataSubmit setHTTPBody:self.paymentTokenData];
        connection = [[NSURLConnection alloc]initWithRequest:dataSubmit delegate:self];
        
        self.responseData=[NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
    
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *)response;
    [PaySafeDef OPAYLog:@"Response Headers::" returnMessage:[httpResponse allHeaderFields]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    [self hideActivityViewer];
    [self.authDelegate callBackResponseFromPaysafeSDK:res];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    [self hideActivityViewer];
    [self.authDelegate callBackResponseFromPaysafeSDK:res];
}

- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response
{
    [self.authDelegate callBackResponseFromPaysafeSDK:response];
}

//////// ANIMATION ///////////
-(void)showActivityViewer
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [optViewController addSubview:activityIndicator];
    self.activityIndicator.center = CGPointMake(optViewController.frame.size.width / 2, optViewController.frame.size.height / 2);
    [self.activityIndicator startAnimating];
}

-(void)hideActivityViewer
{
    [self.activityIndicator stopAnimating];
    activityIndicator=nil;
    optViewController=nil;
}

@end
