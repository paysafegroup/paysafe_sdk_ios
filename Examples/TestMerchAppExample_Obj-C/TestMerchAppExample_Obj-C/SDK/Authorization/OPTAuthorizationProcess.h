//
//  OPTAuthorizationProcess.h
//  TestQAMerchantApplication
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 2/13/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AuthorizationProcessDelegate <NSObject>

@required

-(void)callBackAuthorizationProcess:(NSDictionary*)dictonary;
//-(void)callBackWithErrorCode:(NSString*)errorCode withMessage:(NSString*)errorMessage;

@end

@interface OPTAuthorizationProcess : NSObject<NSURLConnectionDelegate, UIAlertViewDelegate>
{
    NSURLConnection *connection;
}

@property (nonatomic, retain) id <AuthorizationProcessDelegate>processDelegate;
@property (retain, nonatomic) NSMutableData *responseData;

- (instancetype)init;//:(NSDictionary*)dictionary;
- (void)prepareRequestForAuthorization:(NSDictionary *)tokenDictonary;

@end
