//
//  OPayPaymentPurchaseOperationsProcess.h
//  TestMerchAppExample_Swift
//
//  Created by Jaydeep.Patoliya on 15/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@protocol OPayPaymentPurchaseOperationsProcessDelegate<NSObject>

@required
- (void)callBackPurchaseResponseFromOPTSDK:(NSDictionary*)response;

@end;

@interface OPayPaymentPurchaseOperationsProcess : NSObject <NSURLConnectionDelegate>

@property(nonatomic, assign)id<OPayPaymentPurchaseOperationsProcessDelegate>authDelegate;

- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd;

/* 
 Method calling for setting enviroment seetings and return OPayPaymentPurchaseOperationsProcess object
 Method for calling Submit Purchase Webservice.
 Method Name purchasesSubmit
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 MerchantAccount: Type String
 */
-(void)purchasesSubmit:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  merchantAccount:(NSString *) strMerchantAccount;


/* Method for calling Cancel Purchase Webservice.
 Method Name purchasesCancel
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 purchaseID: Type String
 merchantAccount: Type String
 */
-(void)purchasesCancel:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData  purchaseID:(NSString *) strPurchase_ID merchantAccount:(NSString *) strMerchantAccount;


/* Method for calling LooUp Purchases Webservice.
 Method Name purchasesLookup
 Parameters:
 viewController: Type ViewController
 merchantAccount: Type String
 purchaseID: Type String
 */
-(void)purchasesLookup:(UIViewController *)viewController merchantAccount:(NSString *)strMerchantAccount purchaseID:(NSString *) strPurchase_ID;


/* Method for calling LookUp Purchases using Merchant Ref no Webservice.
 Method Name purchasesLookupUsingMerchantRef
 Parameters:
 viewController: Type ViewController
 withRequestData: Type Dictionary
 merchantAccount: Type String
 */
-(void)purchasesLookupUsingMerchantRef:(UIViewController *)viewController withRequestData:(NSDictionary*)requestNAPData merchantAccount:(NSString *) strMerchantAccount;


@end
