//
//  PSThreeDSecureViewController.m
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 1.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import "PSThreeDSecureViewController.h"
#import "UIViewController+Utils.h"
#import "Example_ObjC-Swift.h"
@import Paysafe_SDK;

@interface PSThreeDSecureViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) MerchantSampleBackend *merchantBackend;
@property (strong, nonatomic) ThreeDSecureService *threeDSecureService;
@property (assign, nonatomic, getter=isLoading) BOOL loading;
@property (strong, nonatomic) NSString *cardBin;

@end

@implementation PSThreeDSecureViewController

- (void)setLoading:(BOOL)loading {
    if (self.isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }

    [self.activityIndicator setHidden:!loading];
    [self.submitButton setEnabled:!loading];
}

- (void)configureWithCardBin:(NSString *)cardBin withMerchantBackend:(MerchantSampleBackend *)merchantBackend {
    self.cardBin = cardBin;
    self.merchantBackend = merchantBackend;
    self.threeDSecureService = [[ThreeDSecureService alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardWhenTappedAround];

    self.amountTextField.text = @"20";
    self.loading = NO;
}

- (BOOL)isAmountInvalid {
    NSInteger amount = self.amountTextField.text.integerValue;

    if (amount == 0) {
        [self displayAlertWithTitle:@"Invalid amount" message:@"You've entered an invalid amount"];
        return YES;
    }

    return NO;
}

- (IBAction)startThreeDSecurePayment:(id)sender {
    self.loading = YES;

    __weak typeof(self) weakSelf = self;

    if ([self isAmountInvalid] == YES) {
        return;
    }

    [self.threeDSecureService startWithCardBin:self.cardBin
                                    completion:^(NSString * _Nullable deviceFingerprintId, NSError * _Nullable error) {
                                        weakSelf.loading = NO;
                                        NSInteger amount = weakSelf.amountTextField.text.integerValue;

                                        if (error) {
                                            [weakSelf displayError:error];
                                        } else if(deviceFingerprintId) {
                                            [weakSelf.merchantBackend getChallengePayloadFor:amount
                                                                                        with:deviceFingerprintId
                                                                                  completion:^(AuthenticationResponse * _Nullable response, NSError * _Nullable error) {
                                                                                      weakSelf.loading = NO;
                                                                                      [weakSelf didGetChallengePayloadResult:response withError:error];
                                                                                  }];
                                        }
                                    }];
}

- (void)didGetChallengePayloadResult:(AuthenticationResponse *)challengePayload withError:(NSError *)error {
    if (error) {
        [self displayError:error];
    } else if (challengePayload) {
        NSString *sdkChallengePayload = challengePayload.sdkChallengePayload;

        if (sdkChallengePayload) {
            __weak typeof(self) weakSelf = self;
            [self.threeDSecureService challengeWithSdkChallengePayload:sdkChallengePayload
                                                            completion:^(NSString * _Nullable authenticationId, NSError * _Nullable error) {
                                                                [weakSelf onChallengeCompletedWithAuthenticationId:authenticationId error:error];
                                                            }];
        } else {
            [self displayAlertWithTitle:@"Success!" message:@"No challenge, successfully completed transaction!"];
        }
    }
}

- (void)didGetAuthenticationResult:(AuthenticationIdResponse *)idResponse withError:(NSError *)error {
    if (error) {
        [self displayError:error];
    } else if (idResponse) {
        if (idResponse.status == ResponseStatusCompleted) {
            [self displayAlertWithTitle:@"Success!" message:@"Successfully completed transaction!"];
        } else {
            NSString *failedMessage = [@"Transaction completed with status: " stringByAppendingString:[idResponse stringValueForCurrentStatus]];
            [self displayAlertWithTitle:NULL message:failedMessage];
        }
    }
}

- (void)onChallengeCompletedWithAuthenticationId:(NSString * _Nullable)authenticationId
                                           error:(NSError * _Nullable)error {

    if (error) {
        [self displayError:error];
    } else {
        __weak typeof(self) weakSelf = self;

        [self.merchantBackend authenticate:authenticationId
                                completion:^(AuthenticationIdResponse * _Nullable result, NSError * _Nullable error) {
                                    weakSelf.loading = NO;
                                    [weakSelf didGetAuthenticationResult:result withError:error];
                                }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
