//
//  OPayPaymentAccountOperationsProcess.m
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 13/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "OPayPaymentAccountOperationsProcess.h"
#import "PaySafeConstants.h"
#import "PaySafeDef.h"


@interface OPayPaymentAccountOperationsProcess ()  <UIViewControllerTransitioningDelegate,NSURLConnectionDelegate>
{
    NSURLConnection *myConnection;
    NSURLConnection *deleteConnection;
    NSDictionary *merchantCartDictonary;
    BOOL isHavingStubs;
    NSDictionary *envSettingDict;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic , retain) UIView *optViewController;
@property (strong) NSData *accountData;
@property (retain, nonatomic) NSMutableData *responseData;

@end

@implementation OPayPaymentAccountOperationsProcess 

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

// Create ACH Bank Account
-(void)createACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self createBankAccountsByName:CREATE_ACHBankAccounts profileID:strProfile_ID];
}

// Create BACS Bank Account
-(void)createBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *)strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    
    [self showActivityViewer];
    [self createBankAccountsByName:CREATE_BACSBankAccounts profileID:strProfile_ID];
}

// Create EFT Bank Account
-(void)createEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    
    [self showActivityViewer];
    [self createBankAccountsByName:CREATE_EFTBankAccounts profileID:strProfile_ID];
}

// Create SEPA Bank Account
-(void)createSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    
    [self showActivityViewer];
    [self createBankAccountsByName:CREATE_SEPABankAccounts profileID:strProfile_ID];
}

-(void)lookUpACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self lookUpBankAccountsByName:LOOKUP_ACHBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)lookUpBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self lookUpBankAccountsByName:LOOKUP_BACSBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)lookUpEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self lookUpBankAccountsByName:LOOKUP_EFTBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)lookUpSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;    
    [self showActivityViewer];
    [self lookUpBankAccountsByName:LOOKUP_SEPABankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)updateACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self updateBankAccountsByName:UPDATE_ACHBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)updateBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self updateBankAccountsByName:UPDATE_BACSBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)updateEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self updateBankAccountsByName:UPDATE_EFTBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)updateSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self updateBankAccountsByName:UPDATE_SEPABankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)deleteACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self deleteBankAccountsByName:DELETE_ACHBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)deleteBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self deleteBankAccountsByName:DELETE_BACSBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)deleteEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self deleteBankAccountsByName:DELETE_EFTBankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

-(void)deleteSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self deleteBankAccountsByName:DELETE_SEPABankAccounts profileID:strProfile_ID bankAccountID:strBankAccount_ID];
}

#pragma mark --Web Service Call Operations
- (void)createBankAccountsByName:(NSString *)serviceName profileID:(NSString *)strProfileID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel= [PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:CREATE_ACHBankAccounts])
    {
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Achbankaccounts];
        
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
    else if ([serviceName isEqualToString:CREATE_BACSBankAccounts])
    {
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Bacsbankaccounts];
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
    else if ([serviceName isEqualToString:CREATE_EFTBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Eftbankaccounts];
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
    else if ([serviceName isEqualToString:CREATE_SEPABankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Sepabankaccounts];
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
}

- (void)lookUpBankAccountsByName:(NSString *)serviceName profileID:(NSString *)strProfileID bankAccountID:(NSString *) strBankAccount_ID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel=[PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:LOOKUP_ACHBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Achbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_BACSBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Bacsbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_EFTBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Eftbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_SEPABankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Sepabankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
}

- (void)updateBankAccountsByName:(NSString *)serviceName profileID:(NSString *)strProfileID bankAccountID:(NSString *) strBankAccount_ID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel=[PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:UPDATE_ACHBankAccounts])
    {
        
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Achbankaccounts,strBankAccount_ID];
        
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
    else if ([serviceName isEqualToString:UPDATE_BACSBankAccounts])
    {
        // JSON POST TO SERVER
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Bacsbankaccounts,strBankAccount_ID];
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
    else if ([serviceName isEqualToString:UPDATE_EFTBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Eftbankaccounts,strBankAccount_ID];
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
    else if ([serviceName isEqualToString:UPDATE_SEPABankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Sepabankaccounts,strBankAccount_ID];
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
}

- (void)deleteBankAccountsByName:(NSString *)serviceName profileID:(NSString *)strProfileID bankAccountID:(NSString *) strBankAccount_ID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel= [PaySafeDef.timeInterval doubleValue];
    
    if ([serviceName isEqualToString:DELETE_ACHBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Achbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"DELETE"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        deleteConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:DELETE_BACSBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Bacsbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"DELETE"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        deleteConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:DELETE_EFTBankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Eftbankaccounts,strBankAccount_ID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"DELETE"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        deleteConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:DELETE_SEPABankAccounts])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerValtProfile,strProfileID,Sepabankaccounts,strBankAccount_ID];
        
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
    
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *)response;
    [PaySafeDef OPAYLog:@"Response Headers::" returnMessage:[httpResponse allHeaderFields]];
    [self hideActivityViewer];
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
            NSMutableDictionary *error = [[NSMutableDictionary alloc] init];
            [error setValue:[NSString stringWithFormat:@"%ld", statusCode] forKey:@"code"];
            [error setValue:@"ID not found" forKey:@"message"];
            [errorInfo setValue:error forKey:@"error"];
            [self.authDelegate callBackAccountResponseFromOPTSDK:errorInfo];
        }
        else
        {
            dictResponse = [[NSMutableDictionary alloc] init];
            [dictResponse setValue:[NSString stringWithFormat:@"%ld", statusCode] forKey:@"status"];
            [self.authDelegate callBackAccountResponseFromOPTSDK:dictResponse];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    [self hideActivityViewer];
    [self.authDelegate callBackAccountResponseFromOPTSDK:res];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    [self hideActivityViewer];
    if (connection != deleteConnection)
    {
        [self.authDelegate callBackAccountResponseFromOPTSDK:res];
    }
}

- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response
{
    [self.authDelegate callBackAccountResponseFromOPTSDK:response];
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
