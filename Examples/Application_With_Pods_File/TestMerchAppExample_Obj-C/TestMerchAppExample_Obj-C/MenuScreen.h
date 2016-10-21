//
//  MenuScreen.h
//  TestMerchAppExample_Obj-C
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/3/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface MenuScreen : UIViewController 

@property(retain,nonatomic) IBOutlet UIButton *btnApplePay;
@property(retain,nonatomic) IBOutlet UIButton *btnNonApplePay;

@property (nonatomic, retain) HomeViewController *homeController;

@property (nonatomic, retain) NSMutableData *responseData;

- (IBAction)btnAccountOperationsAction:(id)sender;

- (IBAction)btnPurchaseOperationsAction:(id)sender;

@end
