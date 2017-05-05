//
//  OPayPaymentAddressOperationsProcess.h
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 02/05/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@protocol OPayPaymentAddressOperationsProcessDelegate<NSObject>

@required
- (void)callBackAddressResponseFromOPTSDK:(NSDictionary*)response;

@end;

@interface OPayPaymentAddressOperationsProcess : NSObject
@property(nonatomic, assign)id<OPayPaymentAddressOperationsProcessDelegate>authDelegate;
/*
 Method calling for setting enviroment seetings and return OPayPaymentAddressOperationsProcess object
 Parameters
 merchatAccountNo: Type String
 withMerchantID: Type String
 withMerchantPwd: Type String
 */
- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd;


/* Method for calling Create Address Webservice.
 Method Name createAddress
 Parameters:
 viewController: Type ViewController
  withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)createAddress:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID;


/* Method for calling Update Address Webservice.
 Method Name updateAddress
 Parameters:
 viewController: Type ViewController
  withRequestData: Type Dictionary
 profileID: Type String
 addressID: Type String
 */
-(void)updateAddress:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID;


/* Method for calling Lookup Address Webservice.
 Method Name lookupAddress
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 addressID: Type String
 */
-(void)lookupAddress:(UIViewController *)viewController profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID;


/* Method for calling Deleting Address Webservice.
 Method Name deleteAddress
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 addressID: Type String
 */
-(void)deleteAddress:(UIViewController *)viewController profileID:(NSString *) strProfile_ID addressID:(NSString *) strAddress_ID;

@end
