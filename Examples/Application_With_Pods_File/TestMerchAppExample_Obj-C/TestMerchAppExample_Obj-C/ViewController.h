//
//  ViewController.h
//  TestMerchAppExample_Obj-C
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 4/23/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MenuScreen.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *homePayBtn;
@property (nonatomic, retain) IBOutlet UIButton *phonePayBtn;
@property (nonatomic, retain) HomeViewController *homeController;
@property (nonatomic, retain) MenuScreen *menuScreen;

-(IBAction)homeBtnSelected:(id)sender;

-(IBAction)backPressed:(UIStoryboardSegue *)seque;


@end

