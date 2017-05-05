//
//  OPayPaymentProfilesOperationsProcess.m
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "OPayPaymentProfilesOperationsProcess.h"
#import "PaySafeConstants.h"
#import "PaySafeDef.h"

@interface OPayPaymentProfilesOperationsProcess ()  <UIViewControllerTransitioningDelegate,NSURLConnectionDelegate>
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
@property (nonatomic,retain) NSMutableArray *arraySubcomponents;

@end

@implementation OPayPaymentProfilesOperationsProcess

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

//Profile Operations
-(void)createProfile:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self callProfileOperaionsByName:CREATE_Profile profileID:@""];
}

-(void)updateProfile:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    NSError *jsonSerializationError = nil;
    self.accountData = [NSJSONSerialization dataWithJSONObject:requestNAPData options:NSUTF8StringEncoding error:&jsonSerializationError];
    [self showActivityViewer];
    [self callProfileOperaionsByName:UPDATE_Profile profileID:strProfile_ID];
}

-(void)lookupProfile:(UIViewController *)viewController profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self callProfileOperaionsByName:LOOKUP_Profile profileID:strProfile_ID];
    
}

-(void)lookupProfileUsingSubcomponents:(UIViewController *)viewController withSubcomponents:(NSArray *) subcomponentsData profileID:(NSString *) strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    arraySubComponents = subcomponentsData;
    [self showActivityViewer];
    [self callProfileOperaionsByName:LOOKUP_SUB_Profile profileID:strProfile_ID];
}

-(void)deleteProfile:(UIViewController *)viewController profileID:(NSString *)strProfile_ID
{
    optViewController=viewController.view;
    PaySafeDef.timeInterval = TimeOutIntrval;
    PaySafeDef.envType = EnviornmentType;
    [self showActivityViewer];
    [self callProfileOperaionsByName:DELETE_Profile profileID:strProfile_ID];
}

#pragma mark --Web Service Call Operations
- (void)callProfileOperaionsByName:(NSString *)serviceName profileID:(NSString *)strProfileID
{
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", PaySafeDef.merchantUserID, PaySafeDef.merchantPassword];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    double timeIntervel= [PaySafeDef.timeInterval doubleValue];
    if ([serviceName isEqualToString:CREATE_Profile])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerVault,Profile];
        
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
    else if ([serviceName isEqualToString:UPDATE_Profile])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerVault,Profile,strProfileID];
        
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
    else if ([serviceName isEqualToString:LOOKUP_Profile])
    {
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerVault,Profile,strProfileID];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:LOOKUP_SUB_Profile])
    {
        NSString *strSubComp =@"";
        if ([self.arraySubcomponents count]>0)
            strSubComp = [self.arraySubcomponents componentsJoinedByString:@","];
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@?fields=%@",[PaySafeDef getOptimalUrl],CustomerVault,Profile,strProfileID,strSubComp];
        
        NSURL *projectsUrl = [NSURL  URLWithString:urlString];
        NSMutableURLRequest *dataRequest = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeIntervel];
        [dataRequest setHTTPMethod:@"GET"]; // 1
        [dataRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [dataRequest setValue:authorizationField forHTTPHeaderField:@"Authorization"];
        myConnection = [[NSURLConnection alloc]initWithRequest:dataRequest delegate:self];
        self.responseData=[NSMutableData data];
    }
    else if ([serviceName isEqualToString:DELETE_Profile])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",[PaySafeDef getOptimalUrl],CustomerVault,Profile,strProfileID];
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
            [self.authDelegate callBackProfileResponseFromOPTSDK:errorInfo];
            
        }
        else
        {
            dictResponse = [[NSMutableDictionary alloc] init];
            [dictResponse setValue:[NSString stringWithFormat:@"%ld", statusCode] forKey:@"status"];
            [self.authDelegate callBackProfileResponseFromOPTSDK:dictResponse];
        }
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    [self hideActivityViewer];
    [self.authDelegate callBackProfileResponseFromOPTSDK:res];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    [self hideActivityViewer];
    if (connection != deleteConnection)
    {
        [self.authDelegate callBackProfileResponseFromOPTSDK:res];
    }
}

- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response
{
    [self.authDelegate callBackProfileResponseFromOPTSDK:response];
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
