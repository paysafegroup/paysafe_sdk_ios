//
//  OPAYMockPaymentAuthorizationProcess.h
//
//  Created by sachin on 26/02/15.
//  Copyright (c) 2015 PaySafe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@protocol OPAYMockPaymentAuthorizationProcessDelegate<NSObject>

@required
/* This method will return the Customer vault Payment token
 to the app.
 Need to implment this method by declaring this delegate (where ever we are using this class).
 */
- (void)callBackResponseFromOPAYMockSDK:(NSDictionary*)response;
@end;

@interface PaySafeMockPaymentAuthorizationProcess : NSObject<PKPaymentAuthorizationViewControllerDelegate>

@property(nonatomic, assign)id<OPAYMockPaymentAuthorizationProcessDelegate>authTestDelegate;

-(BOOL)isHavingStub;


- (void)showPaymentSummeryView:(UIViewController *)viewController delgate:(id<PKPaymentAuthorizationViewControllerDelegate>) pDelegate withIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd withMerchantCountry:(NSString*)merchantCountry withMerchantCurrency:(NSString*)merchantCurrency withRequestData:(NSDictionary*)dataDictionary withCartData:(NSDictionary*)cartData;


@end

