//
//  OPayPaymentPurchaseOperationsProcess.m
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 15/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "OPayPaymentPurchaseOperationsProcess.h"
#import "PaySafeConstants.h"
#import "PaySafeDef.h"


@interface OPayPaymentPurchaseOperationsProcess ()  <UIViewControllerTransitioningDelegate,NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSDictionary *merchantCartDictonary;
    BOOL isHavingStubs;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic , retain) UIView *optViewController;
@property (strong) NSData *accountData;
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSDictionary  *lookUpMerRefDic;


@end


@implementation OPayPaymentPurchaseOperationsProcess

@synthesize responseData;
@synthesize activityIndicator,optViewController;
@synthesize authDelegate;

- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd
{
    PaySafeDef.merchantUserID=optiMerchantID;
    PaySafeDef.merchantPassword=optiMerchantPwd;
    PaySafeDef.merchantIdentifier=merchantIdentifier;
    return self;
}


-(void)purchasesSubmit:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  merchantAccount:(NSString *) strMerchantAccount
{
    optViewController=viewController.view;
   
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self requestServiceByName:SUBMIT_PurchaseRequest merchantAccount:strMerchantAccount purchaseID:@""];
    
}

-(void)purchasesCancel:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData purchaseID:(NSString *) strPurchase_ID merchantAccount:(NSString *) strMerchantAccount
{
    optViewController=viewController.view;
  
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self requestServiceByName:CANCEL_PurchaseRequest merchantAccount:strMerchantAccount purchaseID:strPurchase_ID];

}

-(void)purchasesLookup:(UIViewController *)viewController merchantAccount:(NSString *)strMerchantAccount purchaseID:(NSString *) strPurchase_ID;
{
    optViewController=viewController.view;
    
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self requestServiceByName:LOOKUP_PurchaseRequest merchantAccount:strMerchantAccount purchaseID:strPurchase_ID];
}

-(void)purchasesLookupUsingMerchantRef:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData merchantAccount:(NSString *) strMerchantAccount
{
    optViewController=viewController.view;
   
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    self.lookUpMerRefDic = requestNAPData;
    [self showActivityViewer];
    [self requestServiceByName:LOOKUP_PurchaseRequestUsingMerchantRef merchantAccount:strMerchantAccount purchaseID:@""];
}


#pragma mark --Web Service Call Operations

- (void)requestServiceByName:(NSString *)serviceName merchantAccount:(NSString *) strMerchantAccount purchaseID:(NSString *)strPurchaseID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel= [PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:SUBMIT_PurchaseRequest])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],DirectdebitAccount,strMerchantAccount,Purchases];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"POST"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.accountData length]] forHTTPHeaderField:@"Content-Length"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataRequest setHTTPBody:self.accountData];
        connection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:CANCEL_PurchaseRequest])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@%@",[PaySafeDef getOptimalUrl],DirectdebitAccount,strMerchantAccount,Purchases,strPurchaseID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"PUT"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.accountData length]] forHTTPHeaderField:@"Content-Length"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataRequest setHTTPBody:self.accountData];
        connection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_PurchaseRequest])
    {
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],DirectdebitAccount,strMerchantAccount,Purchases,strPurchaseID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        connection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        self.responseData=[NSMutableData data];

    }
    else if ([serviceName isEqualToString:LOOKUP_PurchaseRequestUsingMerchantRef])
    {        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@?merchantRefNum=%@&limit=%@&offset=%@&startDate=%@&endDate=%@",[PaySafeDef getOptimalUrl],DirectdebitAccount,strMerchantAccount,Purchases,[self.lookUpMerRefDic objectForKey:@"merchantRefNum"],[self.lookUpMerRefDic objectForKey:@"limit"],[self.lookUpMerRefDic objectForKey:@"offset"],[self.lookUpMerRefDic objectForKey:@"startDate"],[self.lookUpMerRefDic objectForKey:@"endDate"]];
    
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];

        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        connection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
}

#pragma NSURLConnection Delegate Methods
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
    [self.authDelegate callBackPurchaseResponseFromOPTSDK:res];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // convert to JSON
    NSError *myError = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    [self hideActivityViewer];
    [self.authDelegate callBackPurchaseResponseFromOPTSDK:res];
}


- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response
{
    [self.authDelegate callBackPurchaseResponseFromOPTSDK:response];
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
