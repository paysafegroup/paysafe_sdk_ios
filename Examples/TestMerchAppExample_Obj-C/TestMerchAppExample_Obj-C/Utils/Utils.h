//
//  Utils.h
//  TestMerchAppExample_Obj-C
//
//  Created by Jaydeep Patoliya on 24/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
//        

@interface Utils : NSObject

//-----------------Profile ID-------------------
+(void) setProfileID: (NSString *) strAccountID;
+ (NSString *)getProfileID;
//-----------------MerchantCustomer ID-------------------
+(void) setMerchantCustomerId: (NSString *) strAccountID;
+ (NSString *)getMerchantCustomerId;
//
//-----------------Address ID-------------------
+(void) setAddressID: (NSString *) strAccountID;
+ (NSString *)getAddressID;

//-----------------Account Number-------------------
+(void) setACH_AccountNumber: (NSString *) strAccountNumber;
+ (NSString *)getACH_AccountNumber;

+(void) setBACS_AccountNumber: (NSString *) strAccountNumber;
+ (NSString *)getBACS_AccountNumber;

+(void) setEFT_AccountNumber: (NSString *) strAccountNumber;
+ (NSString *)getEFT_AccountNumber;

+(void) setSEPA_IBanNumber: (NSString *) strIBanNumber;
+ (NSString *)getSEPA_IBanNumber;


//-----------------Account ID's-------------------
+(void) setACH_AccountID: (NSString *) strAccountID;
+ (NSString *)getACH_AccountID;

+(void) setBACS_AccountID: (NSString *) strAccountID;
+ (NSString *)getBACS_AccountID;

+(void) setEFT_AccountID: (NSString *) strAccountID;
+ (NSString *)getEFT_AccountID;

+(void) setSEPA_AccountID: (NSString *) strAccountID;
+ (NSString *)getSEPA_AccountID;


//-----------------Account PaymentToken-------------------
+(void) setACH_PaymentToken: (NSString *) strPaymentToken;
+ (NSString *)getACH_PaymentToken;

+(void) setBACS_PaymentToken: (NSString *) strPaymentToken;
+ (NSString *)getBACS_PaymentToken;

+(void) setEFT_PaymentToken: (NSString *) strPaymentToken;
+ (NSString *)getEFT_PaymentToken;

+(void) setSEPA_PaymentToken: (NSString *) strPaymentToken;
+ (NSString *)getSEPA_PaymentToken;


//-----------------Purchases ID's-------------------
+(void) setACH_PurchaseID: (NSString *) strPurchaseID;
+ (NSString *)getACH_PurchaseID;

+(void) setBACS_PurchaseID: (NSString *) strPurchaseID;
+ (NSString *)getBACS_PurchaseID;

+(void) setEFT_PurchaseID: (NSString *) strPurchaseID;
+ (NSString *)getEFT_PurchaseID;

+(void) setSEPA_PurchaseID: (NSString *) strPurchaseID;
+ (NSString *)getSEPA_PurchaseID;

//-----------------Purchases Order ID's-------------------
+(void) setACH_PurchaseOrderID: (NSString *) strPurchaseOrderID;
+ (NSString *)getACH_PurchaseOrderID;

+(void) setBACS_PurchaseOrderID: (NSString *) strPurchaseOrderID;
+ (NSString *)getBACS_PurchaseOrderID;

+(void) setEFT_PurchaseOrderID: (NSString *) strPurchaseOrderID;
+ (NSString *)getEFT_PurchaseOrderID;

+(void) setSEPA_PurchaseOrderID: (NSString *) strPurchaseOrderID;
+ (NSString *)getSEPA_PurchaseOrderID;

//Return Auth Sftring
+(NSString *)returnAuthValueString;

//Random generate string
+(NSString *) randomStringWithLength: (u_int32_t) len;
+(NSString *) randomNumberWithLength: (u_int32_t) len;

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(BOOL)keysExist: (NSString *) strKeys;
@end
