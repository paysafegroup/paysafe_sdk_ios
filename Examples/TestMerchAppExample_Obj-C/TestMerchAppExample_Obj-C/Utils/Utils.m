//
//  Utils.m
//  TestMerchAppExample_Obj-C
//
//  Created by Ashish on 24/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "Utils.h"
#define Letters @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
#define Numbers @"0123456789";


@implementation Utils


//-----------------Profile ID-------------------
+(void) setProfileID: (NSString *) strProfileID
{
    [DEFAULTS setObject:strProfileID forKey:keyProfileID];
    [DEFAULTS synchronize];

}
+ (NSString *)getProfileID
{
    return [DEFAULTS objectForKey:keyProfileID];
}

//-----------------MerchantCustomer ID-------------------

+(void) setMerchantCustomerId: (NSString *) strMerchantCustomerID
{
    [DEFAULTS setObject:strMerchantCustomerID forKey:KeyMerchantCutomerID];
    [DEFAULTS synchronize];
}
+ (NSString *)getMerchantCustomerId
{
    return [DEFAULTS objectForKey:KeyMerchantCutomerID];

}

//-----------------Address ID-------------------
+(void) setAddressID: (NSString *) strAddressID
{
    [DEFAULTS setObject:strAddressID forKey:keyAddressID];
    [DEFAULTS synchronize];
}
+ (NSString *)getAddressID
{
    return [DEFAULTS objectForKey:keyAddressID];
}


//-----------------Account Number-------------------
+(void) setACH_AccountNumber: (NSString *) strAccountNumber
{
    [DEFAULTS setObject:strAccountNumber forKey:keyACH_AccountNumber];
    [DEFAULTS synchronize];
}
+ (NSString *)getACH_AccountNumber
{
    return [DEFAULTS objectForKey:keyACH_AccountNumber];
}


+(void) setBACS_AccountNumber: (NSString *) strAccountNumber
{
    [DEFAULTS setObject:strAccountNumber forKey:keyBACS_AccountNumber];
    [DEFAULTS synchronize];
}
+ (NSString *)getBACS_AccountNumber
{
    return [DEFAULTS objectForKey:keyBACS_AccountNumber];

}

+(void) setEFT_AccountNumber: (NSString *) strAccountNumber
{
    [DEFAULTS setObject:strAccountNumber forKey:keyEFT_AccountNumber];
    [DEFAULTS synchronize];
}
+ (NSString *)getEFT_AccountNumber
{
    return [DEFAULTS objectForKey:keyEFT_AccountNumber];
}

+(void) setSEPA_IBanNumber: (NSString *) strIBanNumber
{
    [DEFAULTS setObject:strIBanNumber forKey:keySEPA_IBanNumber];
    [DEFAULTS synchronize];
}
+ (NSString *)getSEPA_IBanNumber
{
    return [DEFAULTS objectForKey:keySEPA_IBanNumber];

}


//-----------------Account ID's-------------------

+(void) setACH_AccountID: (NSString *) strAccountID
{
    [DEFAULTS setObject:strAccountID forKey:keyACH_AccountID];
    [DEFAULTS synchronize];
}

+ (NSString *)getACH_AccountID;
{
    return [DEFAULTS objectForKey:keyACH_AccountID];
}

+(void) setBACS_AccountID: (NSString *) strAccountID;
{
    [DEFAULTS setObject:strAccountID forKey:keyBACS_AccountID];
    [DEFAULTS synchronize];
}
+ (NSString *)getBACS_AccountID
{
    return [DEFAULTS objectForKey:keyBACS_AccountID];
}

+(void) setEFT_AccountID: (NSString *) strAccountID
{
    [DEFAULTS setObject:strAccountID forKey:keyEFT_AccountID];
    [DEFAULTS synchronize];

}
+ (NSString *)getEFT_AccountID
{
    return [DEFAULTS objectForKey:keyEFT_AccountID];
}

+(void) setSEPA_AccountID: (NSString *) strAccountID
{
    [DEFAULTS setObject:strAccountID forKey:keySEPA_AccountID];
    [DEFAULTS synchronize];
}
+ (NSString *)getSEPA_AccountID
{
    return [DEFAULTS objectForKey:keySEPA_AccountID];
}


//-----------------Account PaymentToken-------------------
+(void) setACH_PaymentToken: (NSString *) strPaymentToken
{
    [DEFAULTS setObject:strPaymentToken forKey:keyACH_PaymentToken];
    [DEFAULTS synchronize];
}
+ (NSString *)getACH_PaymentToken
{
    return [DEFAULTS objectForKey:keyACH_PaymentToken];

}

+(void) setBACS_PaymentToken: (NSString *) strPaymentToken
{
    [DEFAULTS setObject:strPaymentToken forKey:keyBACS_PaymentToken];
    [DEFAULTS synchronize];
}

+ (NSString *)getBACS_PaymentToken
{
    return [DEFAULTS objectForKey:keyBACS_PaymentToken];
}

+(void) setEFT_PaymentToken: (NSString *) strPaymentToken
{
    [DEFAULTS setObject:strPaymentToken forKey:keyEFT_PaymentToken];
    [DEFAULTS synchronize];
}

+ (NSString *)getEFT_PaymentToken
{
    return [DEFAULTS objectForKey:keyEFT_PaymentToken];

}

+(void) setSEPA_PaymentToken: (NSString *) strPaymentToken
{
    [DEFAULTS setObject:strPaymentToken forKey:keySEPA_PaymentToken];
    [DEFAULTS synchronize];
}

+ (NSString *)getSEPA_PaymentToken
{
    return [DEFAULTS objectForKey:keySEPA_PaymentToken];

}


//*****************
// Purchases ID's
//*****************
+(void) setACH_PurchaseID: (NSString *) strPurchaseID
{
    [DEFAULTS setObject:strPurchaseID forKey:keyACH_PurchaseID];
    [DEFAULTS synchronize];
}
+ (NSString *)getACH_PurchaseID
{
    return [DEFAULTS objectForKey:keyACH_PurchaseID];
}

+(void) setBACS_PurchaseID: (NSString *) strPurchaseID
{
    [DEFAULTS setObject:strPurchaseID forKey:keyBACS_PurchaseID];
    [DEFAULTS synchronize];

}
+ (NSString *)getBACS_PurchaseID
{
    return [DEFAULTS objectForKey:keyBACS_PurchaseID];;
}

+(void) setEFT_PurchaseID: (NSString *) strPurchaseID
{
    [DEFAULTS setObject:strPurchaseID forKey:keyEFT_PurchaseID];
    [DEFAULTS synchronize];

}
+ (NSString *)getEFT_PurchaseID
{
    return [DEFAULTS objectForKey:keyEFT_PurchaseID];
}

+(void) setSEPA_PurchaseID: (NSString *) strPurchaseID
{
    [DEFAULTS setObject:strPurchaseID forKey:keySEPA_PurchaseID];
    [DEFAULTS synchronize];

}
+ (NSString *)getSEPA_PurchaseID
{
    return [DEFAULTS objectForKey:keySEPA_PurchaseID];
}



//-----------------Purchases Order ID's-------------------
+(void) setACH_PurchaseOrderID: (NSString *) strPurchaseOrderID
{
    [DEFAULTS setObject:strPurchaseOrderID forKey:keyACH_PurchaseOrderID];
    [DEFAULTS synchronize];
}
+ (NSString *)getACH_PurchaseOrderID
{
    return [DEFAULTS objectForKey:keyACH_PurchaseOrderID];
}

+(void) setBACS_PurchaseOrderID: (NSString *) strPurchaseOrderID
{
    [DEFAULTS setObject:strPurchaseOrderID forKey:keyBACS_PurchaseOrderID];
    [DEFAULTS synchronize];
}
+ (NSString *)getBACS_PurchaseOrderID
{
    return [DEFAULTS objectForKey:keyBACS_PurchaseOrderID];

}

+(void) setEFT_PurchaseOrderID: (NSString *) strPurchaseOrderID
{
    [DEFAULTS setObject:strPurchaseOrderID forKey:keyEFT_PurchaseOrderID];
    [DEFAULTS synchronize];
}
+ (NSString *)getEFT_PurchaseOrderID
{
    return [DEFAULTS objectForKey:keyEFT_PurchaseOrderID];

}

+(void) setSEPA_PurchaseOrderID: (NSString *) strPurchaseOrderID
{
    [DEFAULTS setObject:strPurchaseOrderID forKey:keySEPA_PurchaseOrderID];
    [DEFAULTS synchronize];
}
+ (NSString *)getSEPA_PurchaseOrderID
{
    return [DEFAULTS objectForKey:keySEPA_PurchaseOrderID];

}

+(NSString *)returnAuthValueString
{
    //This method returns a HTTP Basic authentication header
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MerchantRealConfiguration" ofType:@"plist"];
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *merchantPassword =[myDictionary objectForKey:@"OptiMerchantPassword-Server"];
    NSString *appleMerchantId = [myDictionary objectForKey:@"OptiMerchantID-Server"];
    
    NSString *authString = [NSString stringWithFormat:@"%@:%@",appleMerchantId,merchantPassword];
    NSData *authData = [authString dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64EncodedStringWithOptions:0];
    
    NSString *authValueString = [NSString stringWithFormat:@"Basic %@", authValue];    
    return authValueString;
}


+(NSString *) randomStringWithLength: (u_int32_t) len {
    NSString *letters = Letters;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    u_int32_t length = (u_int32_t)letters.length;
    for (int i=0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(length)]];
    }
    
    return randomString;
}

+(NSString *) randomNumberWithLength: (u_int32_t) len {
    NSString *letters = Numbers;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    u_int32_t length = (u_int32_t)letters.length;
    for (int i=0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(length)]];
    }
    
    return randomString;
}

+(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

+(BOOL)keysExist: (NSString *) strKeys
{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:strKeys]){
        return YES;
    }
    return NO;
}
@end
