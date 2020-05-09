//
//  PSApplePayViewController.m
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 16.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import "PSApplePayViewController.h"
#import "UIViewController+Utils.h"
#import "Example_ObjC-Swift.h"
#import <PassKit/PassKit.h>
#import "AppDelegate.h"
@import Paysafe_SDK;

static NSString * const unsupportedConfiguration = @"Device does not support Apple Pay or some restrictions are set";
static NSString * const successfulTransactionMessage = @"Successfully completed transaction! ";
static NSString * const successfulTransactionTitle = @"Success";
static NSString * const invalidAmountMessage = @"You've entered an invalid amount or price";
static NSString * const invalidAmountTitle = @"Invalid data";
static NSString * const simulatorNotSupportedMessage = @"Apple Pay transactions are not supported in simulator. Use real device instead.";

@interface PSApplePayViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *singleItemPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) MerchantSampleBackend *merchantBackend;
@property (strong, nonatomic) ApplePayService *applePayService;
@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end

@implementation PSApplePayViewController

- (NSArray *)shippingMethodOptions {
    return @[
             [[ShippingMethod alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:@"5.00"] title:@"Carrier Pigeon" description:@"You'll get it someday."],
             [[ShippingMethod alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:@"100.00"] title:@"Racecar" description:@"Vrrrroom! Get it by tomorrow!"],
             [[ShippingMethod alloc] initWithPrice:[NSDecimalNumber decimalNumberWithString:@"90000.00"] title:@"Rocket Ship" description:@"Look out your window!"]
             ];
}

- (void)setLoading:(BOOL)loading {
    if (self.isLoading) {
        [self.errorMessageLabel setHidden:YES];
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }

    [self.activityIndicator setHidden:!loading];
    [self.applePayButton setEnabled:!loading];
}

- (void)setupMerchantConfiguration {
    PaysafeSDK.currentEnvironment = PaysafeSDKEnvironmentTest;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PaysafeSDK.merchantConfiguration = [appDelegate getPaysafeSDKMerchantConfigurationFromPlist:@"PaysafeSDK_ApplePay-Info"];
    PaysafeSDK.applePayMerchantConfiguration = [appDelegate getPaysafeSDKApplePayMerchantConfigurationFromPlist:@"PaysafeSDK_ApplePay-Info"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardWhenTappedAround];
    [self setupMerchantConfiguration];

    self.merchantBackend = [[MerchantSampleBackend alloc] init];
    self.applePayService = [[ApplePayService alloc] init];

    [self.applePayButton setHidden:![self.applePayService isApplePaySupported]];

    if (self.applePayButton.isHidden) {
        self.errorMessageLabel.text = unsupportedConfiguration;
        [self.errorMessageLabel setHidden:NO];
    }

    self.amountTextField.text = @"20";
    self.singleItemPriceTextField.text = @"0.01";
    self.currencyLabel.text = PaysafeSDK.applePayMerchantConfiguration.currencyCode;
    self.loading = NO;
}

- (BOOL)isNumber:(NSString *)input {
    NSString *decimalSeparator;

    if (@available(iOS 10.0, *)) {
        decimalSeparator = [NSLocale currentLocale].decimalSeparator;
    } else {
        decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    }

    NSString *regularExpression = [@"0123456789" stringByAppendingString:decimalSeparator];
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:regularExpression];
    BOOL isNumber = [input stringByTrimmingCharactersInSet:characterSet].length == 0;
    return isNumber;
}

- (BOOL)isAmountOrPriceInvalid {
    BOOL priceIsNumber = [self isNumber:self.singleItemPriceTextField.text];
    BOOL amountIsNumber = [self isNumber:self.amountTextField.text];

    if (!priceIsNumber || !amountIsNumber) {
        [self displayAlertWithTitle:invalidAmountTitle message:invalidAmountMessage];
        return YES;
    }

    return NO;
}

- (IBAction)startApplePayPayment:(id)sender {
    __weak typeof(self) weakSelf = self;

    if ([self isAmountOrPriceInvalid] == YES) {
        return;
    }

    Merchandise *product = [[Merchandise alloc] initWithImage:NULL
                                                        title:@"Llama California Shipping"
                                                        price:[NSDecimalNumber decimalNumberWithString:self.singleItemPriceTextField.text]
                                                       amount:self.amountTextField.text.doubleValue
                                               shippingMethod:[self shippingMethodOptions].firstObject
                                                  description:@"3-5 Business Days"];

    CartDetails *cartData = [[CartDetails alloc] initWithCartId:@"123423"
                                                          payTo:@"Llama Services, Inc."
                                                shippingOptions:[self shippingMethodOptions]];

    self.loading = YES;
    [self.applePayService beginPayment:product
                           cartDetails:cartData
                            completion:^(PKPayment * _Nullable payment, NSError * _Nullable error) {
                                weakSelf.loading = NO;

                                if (error) {
                                    [weakSelf displayError:error];
                                } else {
                                    [weakSelf storeToBackendWithPayment:payment];
                                }
                            }];
}

- (ApplePayTokenWrapper *)createTokenWithPayment:(PKPayment *)payment {
    NSData *paymentData = payment.token.paymentData;
    return [ApplePayTokenWrapper createFrom:paymentData];
}

- (void)storeToBackendWithPayment:(PKPayment *)payment {
    ApplePayTokenWrapper *applePayInfo = [self createTokenWithPayment:payment];

    if (!applePayInfo) {
        [self displayAlertWithTitle:NULL message:simulatorNotSupportedMessage];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.merchantBackend sendApplePay:applePayInfo
                            completion:^(ApplePaySingleUseToken * _Nullable info, NSError * _Nullable error) {

                                if (error) {
                                    [weakSelf displayError:error];
                                } else {
                                    NSString *successMessage = [successfulTransactionMessage stringByAppendingString:info.id];
                                    [weakSelf displayAlertWithTitle:successfulTransactionTitle message:successMessage];
                                }
                            }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.amountTextField isFirstResponder]) {
        [self.singleItemPriceTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
