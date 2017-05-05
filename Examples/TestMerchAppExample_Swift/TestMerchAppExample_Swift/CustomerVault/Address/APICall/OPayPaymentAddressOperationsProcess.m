//
//  OPayPaymentAddressOperationsProcess.m
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "OPayPaymentAddressOperationsProcess.h"
#import "PaySafeConstants.h"
#import "PaySafeDef.h"
@interface OPayPaymentAddressOperationsProcess ()  <UIViewControllerTransitioningDelegate,NSURLConnectionDelegate>
{
    NSURLConnection *myConnection;
    NSURLConnection *deleteConnection;
    NSDictionary *merchantCartDictonary;
    NSArray *arraySubComponents;
    BOOL isHavingStubs;
    NSDictionary *envSettingDict;
}
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic , retain) UIView *optViewController;
@property (strong) NSData *accountData;
@property (retain, nonatomic) NSMutableData *responseData;

@end

@implementation OPayPaymentAddressOperationsProcess
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

-(void)createAddress:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;

    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self callAddressOperaionsByName:CREATE_Address profileID:strProfile_ID addressID:@""];
}

-(void)updateAddress:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self callAddressOperaionsByName:UPDATE_Address profileID:strProfile_ID addressID:strAddress_ID];
}

-(void)lookupAddress:(UIViewController *)viewController profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self callAddressOperaionsByName:LOOKUP_Address profileID:strProfile_ID addressID:strAddress_ID];
}

-(void)deleteAddress:(UIViewController *)viewController profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self callAddressOperaionsByName:DELETE_Address profileID:strProfile_ID addressID:strAddress_ID];
}

#pragma mark --Web Service Call Operations
- (void)callAddressOperaionsByName:(NSString *)serviceName profileID:(NSString *)strProfileID addressID:(NSString *)strAddressID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];

    double timeIntervel = [PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:CREATE_Address])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Addresses];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"POST"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.accountData length]] forHTTPHeaderField:@"Content-Length"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataRequest setHTTPBody:self.accountData];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:UPDATE_Address])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Addresses,strAddressID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"PUT"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[self.accountData length]] forHTTPHeaderField:@"Content-Length"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        [dataRequest setHTTPBody:self.accountData];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_Address])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Addresses,strAddressID];
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:DELETE_Address])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Addresses,strAddressID];
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"DELETE"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        deleteConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        self.responseData=[NSMutableData data];
    }
}

#pragma NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [self.responseData setLength:0];
    
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *)response;
    [PaySafeDef OPAYLog:@"Response Headers::" returnMessage:[httpResponse allHeaderFields]];
    
    if (connection == deleteConnection)
    {
        long statusCode = [((NSHTTPURLResponse *)response) statusCode];
        [self hideActivityViewer];
        NSMutableDictionary *dictResponse;
        NSDictionary *errorInfo;
        if (statusCode >= 400)
        {
            [connection cancel];  // stop connecting; no more delegate messages
            errorInfo = [[NSMutableDictionary alloc] init];
            [errorInfo setValue:@"Error" forKey:@"error"];
            [errorInfo setValue:[NSString stringWithFormat:@"%ld", statusCode] forKey:@"code"];
            [errorInfo setValue:@"ID not found" forKey:@"message"];
            [self.authDelegate callBackAddressResponseFromOPTSDK:errorInfo];
        }
        else
        {
            dictResponse = [[NSMutableDictionary alloc] init];
            [dictResponse setValue:[NSString stringWithFormat:@"%ld", statusCode] forKey:@"status"];
            [self.authDelegate callBackAddressResponseFromOPTSDK:dictResponse];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    [self hideActivityViewer];
    [self.authDelegate callBackAddressResponseFromOPTSDK:res];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    [self hideActivityViewer];
    if (connection != deleteConnection)
    {
        [self.authDelegate callBackAddressResponseFromOPTSDK:res];
    }
    
}

- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response
{
    [self.authDelegate callBackAddressResponseFromOPTSDK:response];
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
