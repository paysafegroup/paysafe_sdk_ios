//
//  PSAddCardViewController.m
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 1.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import "PSAddCardViewController.h"
#import "PSThreeDSecureViewController.h"
#import "UIViewController+Utils.h"
#import "Example_ObjC-Swift.h"
#import "AppDelegate.h"
@import Paysafe_SDK;

const static NSInteger cardBinLength = 6;

@interface PSAddCardViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameOnCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *street1TextField;
@property (weak, nonatomic) IBOutlet UITextField *street2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MerchantSampleBackend *merchantBackend;
@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end

@implementation PSAddCardViewController

- (NSDictionary *)cards {
    return @{ @"4000000000001091": @"3DS 2",
              @"4000000000001000": @"3DS 2 Frictionless",
              @"4111111111111111": @"3DS 1.0"
              };
}

- (void)setupMerchantConfiguration {
    PaysafeSDK.currentEnvironment = PaysafeSDKEnvironmentTest;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PaysafeSDK.merchantConfiguration = [appDelegate getPaysafeSDKMerchantConfigurationFromPlist:@"PaysafeSDK-Info"];
    PaysafeSDK.uiConfiguration = [self getConfiguration];
}

- (PaysafeSDKUIConfiguration *)getConfiguration {
    PaysafeSDKUIConfiguration *sdkUIConfiguration = [PaysafeSDKUIConfiguration new];

    ToolbarConfiguration *toolBarConfiguration = [ToolbarConfiguration new];
    toolBarConfiguration.headerText = @"Checkout";
    toolBarConfiguration.buttonText = @"Cancel";
    toolBarConfiguration.textFont = [UIFont fontWithName:@"Noteworthy" size:18.0];
    toolBarConfiguration.textColor = @"#ffffff";
    toolBarConfiguration.backgroundColor = @"#080269";
    sdkUIConfiguration.toolbarConfiguration = toolBarConfiguration;

    LabelConfiguration *labelConfiguration = [LabelConfiguration new];
    labelConfiguration.headingLabel.textFont = [UIFont fontWithName:@"Noteworthy" size:24.0];
    labelConfiguration.headingLabel.textColor = @"#75a487";
    labelConfiguration.textFont = [UIFont fontWithName:@"Noteworthy" size:18.0];
    labelConfiguration.textColor = @"#75a487";
    sdkUIConfiguration.labelConfiguration = labelConfiguration;

    TextBoxConfiguration *textBoxConfiguration = [TextBoxConfiguration new];
    textBoxConfiguration.textFont = [UIFont fontWithName:@"Noteworthy" size:12.0];
    textBoxConfiguration.textColor = @"#a5d6a7";
    textBoxConfiguration.borderColor = @"#a5d6a7";
    textBoxConfiguration.borderWidth = 2.0;
    textBoxConfiguration.cornerRadius = 8.0;
    sdkUIConfiguration.textBoxConfiguration = textBoxConfiguration;

    ButtonConfiguration *buttonConfiguration = [ButtonConfiguration new];
    buttonConfiguration.textFont = [UIFont fontWithName:@"Noteworthy" size:16.0];
    buttonConfiguration.textColor = @"#222222";
    buttonConfiguration.backgroundColor = @"#a5d6a7";
    buttonConfiguration.cornerRadius = 4.0;
    [sdkUIConfiguration setupAllButtonsWithConfiguration:buttonConfiguration];

    ButtonConfiguration *cancelConfiguration = [ButtonConfiguration new];
    cancelConfiguration.textFont = [UIFont fontWithName:@"Noteworthy" size:16.0];
    cancelConfiguration.textColor = @"#ffffff";
    [sdkUIConfiguration setWithButtonConfiguration:cancelConfiguration type:PaysafeSDKButtonConfigurationTypeCancel];

    return sdkUIConfiguration;
}

- (void)setLoading:(BOOL)loading {
    if (self.isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }

    [self.activityIndicator setHidden:!loading];
    [self.submitButton setEnabled:!loading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardWhenTappedAround];
    [self setupMerchantConfiguration];
    self.merchantBackend = [[MerchantSampleBackend alloc] init];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ellipsis"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didTapPickCard)];
    self.cardNumberTextField.text = @"4000000000001091";
    self.monthTextField.text = @"01";
    self.yearTextField.text = @"2022";
    self.nameOnCardTextField.text = @"MR. JOHN SMITH";
    self.street1TextField.text = @"100 Queen Street West";
    self.street2TextField.text = @"Unit 201";
    self.cityTextField.text = @"Toronto";
    self.countryTextField.text = @"CA";
    self.stateTextField.text = @"ON";
    self.zipTextField.text = @"M5H 2N2";

    self.loading = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotificationsWithScrollView:self.scrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unregisterForKeyboardNotifications];
    [super viewDidDisappear:animated];
}

- (void)didTapPickCard {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick a card" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    NSDictionary *cards = [self cards];

    __weak typeof(self) weakSelf = self;

    for (NSString *cardNumber in cards.keyEnumerator) {
        NSString *cardName = [cards objectForKey:cardNumber];
        UIAlertAction *prefillCard = [UIAlertAction actionWithTitle:cardName
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf prefillWithCard:cardNumber];
        }];
        [alert addAction:prefillCard];
    }

    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)prefillWithCard:(NSString *)card {
    self.cardNumberTextField.text = card;
}

- (IBAction)didTapSubmit:(id)sender {
    Expiry *expiry = [[Expiry alloc] initWithMonth:self.monthTextField.text year:self.yearTextField.text];
    BillingAddress * billingAddress = [[BillingAddress alloc] initWithStreet:self.street1TextField.text
                                                                     street2:self.street2TextField.text
                                                                        city:self.cityTextField.text
                                                                     country:self.countryTextField.text
                                                                       state:self.stateTextField.text
                                                                         zip:self.zipTextField.text];
    Card *card = [[Card alloc] initWithCardNumber:self.cardNumberTextField.text
                                       cardExpiry:expiry
                                       holderName:self.nameOnCardTextField.text
                                   billingAddress:billingAddress];
    self.loading = YES;

    __weak typeof(self) weakSelf = self;
    [self.merchantBackend startTransactionWith:card
                                    completion:^(NSError * _Nullable error) {
                                        weakSelf.loading = NO;

                                        if (error != NULL) {
                                            [weakSelf displayError:error];
                                        } else {
                                            [weakSelf showThreeDSecureViewController];
                                        }
                                    }];
}

- (void)showThreeDSecureViewController {
    NSString *cardBin = [self.cardNumberTextField.text substringToIndex:cardBinLength];
    if (!cardBin) {
        [self displayAlertWithTitle:@"Invalid card" message:@"Invalid card number"];
        return;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    PSThreeDSecureViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PSThreeDSecureViewController"];
    [controller configureWithCardBin:cardBin withMerchantBackend:self.merchantBackend];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    UITextField *nextResponder = [textField.superview viewWithTag:nextTag];

    if (nextResponder != NULL) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return YES;
}

@end
