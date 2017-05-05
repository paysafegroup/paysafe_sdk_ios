//
//  OPAYConstants.h
//  TestMerchAppExample_Swift
//
//  Created by Sachin Barage on 09/10/15.
//  Copyright © 2015 PaySafe. All rights reserved.
//

#import <Foundation/Foundation.h>



#define MerchantShippingDictionary @"ShippingMethod" // Used for getting shipping method values dictionary
#define MerchantShippingName @"shippingName" // Used for shipping method name
#define MerchantShippingAount @"shippingAmount" // Used for shipping method amount
#define MerchantShippingDescription @"shippingDes" // Used for shipping method description

#define MerchantCartCost @"CartCost" // Used for Summenry item amount for request.summeryItem
#define MerchantCartTitle @"CartTitle" // Used for Summenry item label for request.summeryItem
#define MerchantCartPayto @"PayTo" // Used for Summenry item payto for request.summeryItem

#define MerchantEnvSettinsDictionary @"EnvSettingDict" // Used for getting Enviroment variable values dictionary
#define MerchantTimeInterval @"TimeIntrval" // Used for connection timed out default is 30 sec's
#define MerchantEnvironmentType @"EnvType" // Used for passing environment type as PROD or TEST
#define TimeOutIntrval @"30.0"
#define EnviornmentType @"TEST_ENV"

#define iOSSupportedVersion @"8.1"  // Used for iOS supported version for Apple Pay
#define MerchantAlertTitle @"Alert" // Used to show title when Apple Pay not available OPAYPaymentAuthorizationProcess

// Below are the messages, which we are showing in various scenarios of Alert's
#define MerchantAlertApplePayNotAvailableMsg @"iOS Simulator using iOS less then 8.1 version does not support Apple Pay mock library for making payments!"
#define MerchantAlertNetworksNotAvailableMsg @"User cannot authorize payments on these networks or user is restricted from authorizing payments!"
#define MerchantAlertDeviceNotSupportMsg @"Device does not support making Apple Pay payments!"
#define MerchantAlertDeviceNotSupportIOSMsg @"Device does not support Apple Pay below 8.1 iOS version for making payments!"
#define MerchantAlertOKBtn @"OK"



#define SingleUserTokneServiceRequest @"ApplePaySingleUseTokens" // Used for optimal's single use token service name
#define NonApplePaySingleUserTokneServiceRequest @"NonApplePaySingleUseTokens" // Used for optimal's Non apple pay single use token service name

//URL's'
#define ThreeDSecure @"threedsecure/v1/accounts"
#define EnrollmentCheck @"enrollmentchecks"
#define Authentications @"authentications"
#define CustomerVault @"customervault/v1"
#define Profile @"profiles"

#define CustomerValtProfile @"customervault/v1/profiles"
#define Addresses @"addresses"

#define Achbankaccounts @"achbankaccounts"
#define Bacsbankaccounts @"bacsbankaccounts"
#define Eftbankaccounts @"eftbankaccounts"
#define Sepabankaccounts @"sepabankaccounts"

#define DirectdebitAccount @"directdebit/v1/accounts"
#define Purchases @"purchases"


// Account Operations
#define CREATE_ACHBankAccounts @"create_achbankaccounts"
#define CREATE_BACSBankAccounts @"create_bacsbankaccounts"
#define CREATE_EFTBankAccounts @"create_eftbankaccounts"
#define CREATE_SEPABankAccounts @"create_sepabankaccounts"

#define LOOKUP_ACHBankAccounts @"lookup_achbankaccounts"
#define LOOKUP_BACSBankAccounts @"lookup_bacsbankaccounts"
#define LOOKUP_EFTBankAccounts @"lookup_eftbankaccounts"
#define LOOKUP_SEPABankAccounts @"lookup_sepabankaccounts"

#define UPDATE_ACHBankAccounts @"update_achbankaccounts"
#define UPDATE_BACSBankAccounts @"update_bacsbankaccounts"
#define UPDATE_EFTBankAccounts @"update_eftbankaccounts"
#define UPDATE_SEPABankAccounts @"update_sepabankaccounts"

#define DELETE_ACHBankAccounts @"delete_achbankaccounts"
#define DELETE_BACSBankAccounts @"delete_bacsbankaccounts"
#define DELETE_EFTBankAccounts @"delete_eftbankaccounts"
#define DELETE_SEPABankAccounts @"delete_sepabankaccounts"



// Purchase Operations
#define SUBMIT_PurchaseRequest @"submit_purchase"
#define CANCEL_PurchaseRequest @"cancel_purchase"
#define LOOKUP_PurchaseRequest @"lookup_purchase"
#define LOOKUP_PurchaseRequestUsingMerchantRef @"lookup_merchant_ref_purchase"

//Enrollment Operations
#define Enrollment_LookUP @"enrollment_lookup"
#define Enrollment_LookUP_UsingID @"enrollment_lookup_using_id"
#define Enrollment_Authentication @"enrollment_authentication"
#define Enrollment_Authentication_UsingID @"enrollment_using_id"
#define Enrollment_LookUP_Authentication @"enrollment_lookup_authentication"


// Profiles Operations
#define CREATE_Profile @"create_profile"
#define UPDATE_Profile @"update_profile"
#define LOOKUP_Profile @"lookup_profile"
#define LOOKUP_SUB_Profile @"lookup_sub_profile"
#define DELETE_Profile @"delete_profile"


//Address Operaions
#define CREATE_Address @"create_profile"
#define UPDATE_Address @"update_profile"
#define DELETE_Address @"delete_profile"
#define LOOKUP_Address @"lookup_profile"

@interface PaySafeConstants : NSObject
{
    
}



@end
