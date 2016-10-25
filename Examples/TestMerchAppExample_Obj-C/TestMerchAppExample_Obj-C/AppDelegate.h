//
//  AppDelegate.h
//  TestMerchAppExample_Obj-C
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 4/23/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuScreen.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MenuScreen *rootViewController;
@property (strong, nonatomic) UINavigationController *navController;

@end

