//
//  AppDelegate.h
//  Example-ObjC
//
//  Created by Ivelin Davidov on 11.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Paysafe_SDK/Paysafe_SDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (PaysafeSDKMerchantConfiguration *)getPaysafeSDKMerchantConfigurationFromPlist:(NSString *)plistName;
- (PaysafeSDKApplePayMerchantConfiguration *)getPaysafeSDKApplePayMerchantConfigurationFromPlist:(NSString *)plistName;
@end

