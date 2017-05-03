//
//  Constant.h
//  TestMerchAppExample_Obj-C
//
//  Created by Jaydeeep Patoliya on 24/04/16.
//  Copyright © 2016 opus. All rights reserved.


#import <Foundation/Foundation.h>
#import "Utils.h"

//Bank Account Types
#define ACH_BANK_TYPE 777
#define BACS_BANK_TYPE 778
#define EFT_BANK_TYPE 779
#define SEPA_BANK_TYPE 900

#define DEFAULTS [NSUserDefaults standardUserDefaults]

#define BaseUrl @"https://api.test.paysafe.com"  //Base url
@interface Constant : NSObject


#define ProfileID1 @"0bd8883e-6294-4691-b4aa-f0ef5ec2e18a" // Default Profile ID
#define AddressID1 @"e43e0f72-1a7f-4d6f-9b62-e0472177db71" // Default Address ID

//URL's
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



// NsUser Default Keys
#define keyProfileID @"Profile_ID"
#define KeyMerchantCutomerID @"merchantCustomerId"
#define keyAddressID @"Address_ID"

#define keyACH_AccountNumber @"ACH_AccountNumber"
#define keyBACS_AccountNumber @"BACS_AccountNumber"
#define keyEFT_AccountNumber @"EFT_AccountNumber"
#define keySEPA_IBanNumber @"SEPA_IBanNumber"

#define keyACH_AccountID @"ACH_AccountID"
#define keyBACS_AccountID @"BACS_AccountID"
#define keyEFT_AccountID @"EFT_AccountID"
#define keySEPA_AccountID @"SEPA_AccountID"

#define keyACH_PurchaseID @"ACH_PurchaseID"
#define keyBACS_PurchaseID @"BACS_PurchaseID"
#define keyEFT_PurchaseID @"EFT_PurchaseID"
#define keySEPA_PurchaseID @"SEPA_PurchaseID"

#define keyACH_PurchaseOrderID @"ACH_PurchaseOrderID"
#define keyBACS_PurchaseOrderID @"BACS_PurchaseOrderID"
#define keyEFT_PurchaseOrderID @"EFT_PurchaseOrderID"
#define keySEPA_PurchaseOrderID @"SEPA_PurchaseOrderID"

#define keyACH_PaymentToken @"ACH_PaymentToken"
#define keyBACS_PaymentToken @"BACS_PaymentToken"
#define keyEFT_PaymentToken @"EFT_PaymentToken"
#define keySEPA_PaymentToken @"SEPA_PaymentToken"

//#define Default_ACH_BankAccountID @"a80e3edf-1c4f-4726-9b58-c1bcc7974288"
#define Default_BACS_BankAccountID @"5c9941e0-b30b-4cff-b7ff-eee697a76ab3"
//#define Default_EFT_BankAccountID @"1ebb7ac9-9807-4878-8568-b64eb5837f83"
//#define Default_SEPA_BankAccountID @"1ad095a3-a672-45ef-9c8c-dad652dff643"


//#define Default_ACH_BankAccountID @"a80e3edf-1c4f-4726-9b58-c1bcc7974288"
//#define Default_BACS_BankAccountID @""
//#define Default_EFT_BankAccountID @"1ebb7ac9-9807-4878-8568-b64eb5837f83"
//#define Default_SEPA_BankAccountID @"72d21d37-6606-474f-b780-f5ad3bf532b1"


#define Default_ACH_PurchaseID @"e4e9146c-95af-40bd-a6aa-99cc55c162e7"
#define Default_BACS_PurchaseID @"c7392359-df82-457e-8cf2-d05e7a5ba20c"
#define Default_EFT_PurchaseID @"4e35b1d6-149c-4269-bd99-df54b412044e"
#define Default_SEPA_PurchaseID @"d2c06201-fb90-4ad2-b679-4aaa4f014348"

#define ACH_MerchantAccount @"1001057430" // ACH Merchant Account
#define BACS_MerchantAccount @"1001057660" // BACS Merchant Account
#define EFT_MerchantAccount @"1001057670" // EFT Merchant Account
#define SEPA_MerchantAccount @"1001057620" // SEPA Merchant Account


#define BACS_PaymentToken @"MgPnKh2gGCQ6p9m"


#define key_EnrollmentAccountID @"key_EnrollmentAccountID"
#define key_EnrollmentID @"enrollmentID"
#define key_MerchantRefNo @"merchantRefNo"
#define key_paReq @"paReq"
#define key_AuthenticationID  @"authenticationID"

#define EnrollmentAccountID @"89983472"




#define MerchantTimeInterval @"TimeIntrval" // Used for connection timed out default is 30 sec's
#define MerchantEnvironmentType @"EnvType" // Used for passing environment type as PROD or TEST

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


//Alert Messages
#define ALERT_SUBMIT_ENROLLMENT @"Please first create submit enrollment request"
#define ALERT_SUBMIT_AUTHENTICATION @"Please first create submit authentications request"


#define ALERT_CREATE_PROFILE @"Please first create Profile"
#define ALERT_CREATE_PROFILE_ADDRESS @"Please first create Profile and Address"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_ACH @"Please first create Profile, Address and ACH Bank Account"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_SEPA @"Please first create Profile, Address and SEPA Bank Account"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_BACS @"Please first create Profile, Address and BACS Bank Account"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_EFT @"Please first create Profile, Address and EFT Bank Account"


#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_ACH @"Please first create Profile, Address, ACH Bank Account and  Submit Purchase"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_SEPA @"Please first create Profile, Address, SEPA Bank Account and  Submit Purchase"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_BACS @"Please first create Profile, Address, BACS Bank Account and  Submit Purchase"
#define ALERT_CREATE_PROFILE_ADDRESS_ACCOUNT_PURCHASE_EFT @"Please first create Profile, Address, EFT Bank Account and  Submit Purchase"

@end
