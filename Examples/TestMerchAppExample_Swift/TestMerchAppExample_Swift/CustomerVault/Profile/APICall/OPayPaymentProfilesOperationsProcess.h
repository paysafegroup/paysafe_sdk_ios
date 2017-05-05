//
//  OPayPaymentProfilesOperationsProcess.h
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@protocol OPayPaymentProfileOperationsProcessDelegate<NSObject>

@required
- (void)callBackProfileResponseFromOPTSDK:(NSDictionary*)response;

@end;
@interface OPayPaymentProfilesOperationsProcess : NSObject
@property(nonatomic, assign)id<OPayPaymentProfileOperationsProcessDelegate>authDelegate;

/*
 Method calling for setting enviroment seetings and return OPayPaymentProfilesOperationsProcess object
 Init Method for OPayPaymentAccountOperationsProcess Class 
 Parameters 
 merchatAccountNo: Type String
 withMerchantID: Type String
 withMerchantPwd: Type String
 */
- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd;

//Profile Operations

/* Method for calling Create Profile Webservice.
 Method Name createProfile
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary

 */
-(void)createProfile:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData;


/* Method for calling Update Profile Webservice.
 Method Name updateProfile
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)updateProfile:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID;


/* Method for calling LookUp Profile Webservice.
 Method Name lookupProfile
 Parameters:
 viewController: Type ViewController
 profileID: Type String
 */
-(void)lookupProfile:(UIViewController *)viewController profileID:(NSString *) strProfile_ID;


/* Method for calling lookUp Profile using Subcomponents  Webservice.
 Method Name lookupProfileUsingSubcomponents
 Parameters:
 viewController: Type ViewController
 withSubcomponents: Type Array
 profileID: Type String
 */
-(void)lookupProfileUsingSubcomponents:(UIViewController *)viewController withSubcomponents:(NSArray *) subcomponentsData profileID:(NSString *) strProfile_ID;


/* Method for calling Delete Profile Webservice.
 Method Name deleteProfile
 Parameters:
 viewController: Type ViewController
 profileID: Type String
 */
-(void)deleteProfile:(UIViewController *)viewController profileID:(NSString *) strProfile_ID;

@end
