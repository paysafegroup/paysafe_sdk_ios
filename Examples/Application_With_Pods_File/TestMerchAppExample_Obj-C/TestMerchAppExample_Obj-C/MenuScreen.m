//
//  MenuScreen.m
//  TestMerchAppExample_Obj-C
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/3/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import "MenuScreen.h"
#import "CreditCardViewController.h"



@implementation MenuScreen
@synthesize btnApplePay,btnNonApplePay;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    btnApplePay.layer.cornerRadius = 10;
    btnNonApplePay.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)startApplePayFlow:(id)sender
{
      _homeController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
     UIStoryboard *storyboard = self.storyboard;
     _homeController = [storyboard instantiateViewControllerWithIdentifier:@"HomeviewController"];
     [self presentViewController:_homeController animated:YES completion:nil];
}
-(IBAction)startNonApplePayFlow:(id)sender
{
    CreditCardViewController *creditCardViewController=[[CreditCardViewController alloc]initWithNibName:nil bundle:nil];
    UIStoryboard *storyboard = self.storyboard;
    creditCardViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    [self presentViewController:creditCardViewController animated:YES completion:nil];
}

-(IBAction)backPressed:(UIStoryboardSegue *)seque{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
