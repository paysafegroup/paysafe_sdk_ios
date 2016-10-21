//
//  Constant.h
//  TestMerchAppExample_Obj-C
//
//  Created by Ashish on 24/04/16.
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

#define KeyMerchantCutomerID @"merchantCustomerId"


#define ACH_MerchantAccount @"1001057430" // ACH Merchant Account
#define BACS_MerchantAccount @"1001057660" // BACS Merchant Account
#define EFT_MerchantAccount @"1001057670" // EFT Merchant Account
#define SEPA_MerchantAccount @"1001057620" // SEPA Merchant Account


#define BACS_PaymentToken @"MPYuiNEUsKG5Y3A"

// NsUser Default Keys
#define key_EnrollmentAccountID @"key_EnrollmentAccountID"
#define key_EnrollmentID @"enrollmentID"
#define key_MerchantRefNo @"merchantRefNo"
#define key_paReq @"paReq"
#define key_AuthenticationID  @"authenticationID"


//Alert Messages
#define ALERT_SUBMIT_ENROLLMENT @"Please first create submit enrollment request"


@end
