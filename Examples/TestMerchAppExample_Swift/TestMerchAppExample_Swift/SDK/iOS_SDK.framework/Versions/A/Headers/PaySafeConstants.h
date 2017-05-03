//
//  OPAYConstants.h
//  iOS_SDK
//
//  Created by Sachin Barage on 09/10/15.
//  Copyright © 2015 Paysafe. All rights reserved.
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

#define iOSSupportedVersion @"8.1"  // Used for iOS supported version for Apple Pay
#define MerchantAlertTitle @"Alert" // Used to show title when Apple Pay not available OPAYPaymentAuthorizationProcess

// Below are the messages, which we are showing in various scenarios of Alert's
#define MerchantAlertApplePayNotAvailableMsg @"iOS Simulator using iOS less then 8.1 version does not support Apple Pay mock library for making payments!"
#define MerchantAlertNetworksNotAvailableMsg @"User cannot authorize payments on these networks or user is restricted from authorizing payments!"
#define MerchantAlertDeviceNotSupportMsg @"Device does not support making Apple Pay payments!"
#define MerchantAlertDeviceNotSupportIOSMsg @"Device does not support Apple Pay below 8.1 iOS version for making payments!"
#define MerchantAlertOKBtn @"OK"

#define SingleUserTokneServiceRequest @"ApplePaySingleUseTokens" // Used for paysafe's single use token service name
#define NonApplePaySingleUserTokneServiceRequest @"NonApplePaySingleUseTokens" // Used for paysafe's Non apple pay single use token service name

//Enrollment Operations
#define Enrollment_LookUP @"enrollment_lookup"
#define Enrollment_LookUP_UsingID @"enrollment_lookup_using_id"

//URL's
#define ThreeDSecure @"threedsecure/v1/accounts"
#define EnrollmentCheck @"enrollmentchecks"


@interface PaySafeConstants : NSObject
{
    
}



@end
