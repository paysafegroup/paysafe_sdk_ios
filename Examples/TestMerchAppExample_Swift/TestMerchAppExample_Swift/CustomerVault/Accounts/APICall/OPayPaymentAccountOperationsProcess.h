//
//  OPayPaymentAccountOperationsProcess.h
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 13/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>


@protocol OPayPaymentAccountOperationsProcessDelegate<NSObject>

@required
- (void)callBackAccountResponseFromOPTSDK:(NSDictionary*)response;

@end;


@interface OPayPaymentAccountOperationsProcess : NSObject <NSURLConnectionDelegate>
@property(nonatomic, assign)id<OPayPaymentAccountOperationsProcessDelegate>authDelegate;
/*
 Method calling for setting enviroment seetings and return OPayPaymentAccountOperationsProcess object
 Init Method for OPayPaymentAccountOperationsProcess Class 
 Parameters 
 merchatAccountNo: Type String
 withMerchantID: Type String
 withMerchantPwd: Type String
 */
- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd;


/*Create Bank Accounts*/

/* Method for calling Creating ACH Bank Account Webservice.
 Method Name createACHBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)createACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID;


/* Method for calling Creating BACS Bank Account Webservice.
 Method Name createBACSBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)createBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID;


/* Method for calling Creating EFT Bank Account Webservice.
 Method Name createEFTBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)createEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID;

/* Method for calling Creating SEPA Bank Account Webservice.
 Method Name createSEPABankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)createSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID ;
/**********************/


/*LookUp Bank Accounts*/

/* Method for calling Lookup ACH Bank Account Webservice.
 Method Name lookUpACHBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)lookUpACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling Lookup BACS Bank Account Webservice.
 Method Name lookUpBACSBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)lookUpBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling Lookup EFT Bank Account Webservice.
 Method Name lookUpEFTBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)lookUpEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling Lookup SEPA Bank Account Webservice.
 Method Name lookUpSEPABankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)lookUpSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;
/**********************/


/*Update Bank Accounts*/
/* Method for calling updating ACH Bank Account Webservice.
 Method Name updateACHBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)updateACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling updating BACS Bank Account Webservice.
 Method Name updateBACSBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)updateBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling updating EFT Bank Account Webservice.
 Method Name updateEFTBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)updateEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling updating SEPA Bank Account Webservice.
 Method Name updateSEPABankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 bankAccountID: Type String
 */
-(void)updateSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;
/**********************/



/*Delete Bank Accounts*/

/* Method for calling Deleting ACH Bank Account Webservice.
 Method Name deleteACHBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)deleteACHBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;

/* Method for calling Creating BACS Bank Account Webservice.
 Method Name deleteBACSBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)deleteBACSBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling Deleting EFT Bank Account Webservice.
 Method Name deleteEFTBankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)deleteEFTBankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;


/* Method for calling Deleting SEPA Bank Account Webservice.
 Method Name deleteSEPABankAccount
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 profileID: Type String
 */
-(void)deleteSEPABankAccount:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData profileID:(NSString *) strProfile_ID bankAccountID:(NSString *) strBankAccount_ID;
/**********************/

@end
