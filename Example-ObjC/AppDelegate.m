//
//  AppDelegate.m
//  Example-ObjC
//
//  Created by Ivelin Davidov on 11.07.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (PaysafeSDKMerchantConfiguration *)getPaysafeSDKMerchantConfigurationFromPlist:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];

    NSString *username = [myDictionary objectForKey:@"OptiMerchantID-Client"];
    NSString *password =[myDictionary objectForKey:@"OptiMerchantPassword-Client"];
    NSString *accountIdentifier =[myDictionary objectForKey:@"merchantAccount"];

    PaysafeSDKMerchantConfiguration *result = [[PaysafeSDKMerchantConfiguration alloc] initWithUsername:username
                                                                                               password:password
                                                                                              accountId:accountIdentifier];
    return result;
}

- (PaysafeSDKApplePayMerchantConfiguration *)getPaysafeSDKApplePayMerchantConfigurationFromPlist:(NSString *)plistName {
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];

    NSString *countryCode = [myDictionary objectForKey:@"countryCode"];
    NSString *currencyCode = [myDictionary objectForKey:@"CurrencyCode"];
    NSString *appleMerchantIdentifier = [myDictionary objectForKey:@"merchantIdentifier"];

    PaysafeSDKApplePayMerchantConfiguration *result = [[PaysafeSDKApplePayMerchantConfiguration alloc]
                                                       initWithApplePayMerchantId:appleMerchantIdentifier
                                                       countryCode:countryCode
                                                       currencyCode:currencyCode];
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
