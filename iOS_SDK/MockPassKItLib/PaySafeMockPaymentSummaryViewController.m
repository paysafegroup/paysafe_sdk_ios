

#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import "PaySafeMockPaymentSummaryViewController.h"
#import "PaySafeMockDataTableViewController.h"
#import "PaySafeMockCardStore.h"
#import "PaySafeMockAddressStore.h"
#import "PaySafeMockShippingMethodStore.h"
#import "PKPayment+OPAYMockKeys.h"
#import "PaySafeMockApplePayDef.h"

NSString *const OPTTestPaymentAuthorizationSummaryItemIdentifier = @"OPTTestPaymentAuthorizationSummaryItemIdentifier";
NSString *const OPTTestPaymentAuthorizationTestDataIdentifier = @"OPTTestPaymentAuthorizationTestDataIdentifier";

NSString *const OPTTestPaymentSectionTitleCards = @"Credit Card";
NSString *const OPTTestPaymentSectionTitleBillingAddress = @"Billing Address";
NSString *const OPTTestPaymentSectionTitleShippingAddress = @"Shipping Address";
NSString *const OPTTestPaymentSectionTitleShippingMethod = @"Shipping Method";
NSString *const OPTTestPaymentSectionTitlePayment = @"Payment";

@interface OPTTestPaymentSummaryItemCell : UITableViewCell
@end

@interface OPTPTestPaymentDataCell : UITableViewCell
@end

@interface OPTTestPaymentPresentationController : UIPresentationController
@end

@interface PaySafeMockPaymentSummaryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) PKPaymentRequest *paymentRequest;
@property (nonatomic) NSArray *summaryItems;
@property (nonatomic) PaySafeMockCardStore *cardStore;
@property (nonatomic) PaySafeMockAddressStore *billingAddressStore;
@property (nonatomic) PaySafeMockAddressStore *shippingAddressStore;
@property (nonatomic) PaySafeMockShippingMethodStore *shippingMethodStore;
@property (nonatomic) NSArray *sectionTitles;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation PaySafeMockPaymentSummaryViewController
@synthesize summeryDelegate,cancelButton;

- (instancetype)initWithPaymentRequest:(PKPaymentRequest *)paymentRequest {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _paymentRequest = paymentRequest;
        _summaryItems = paymentRequest.paymentSummaryItems;
        _cardStore = [PaySafeMockCardStore new];
        _billingAddressStore = [PaySafeMockAddressStore new];
        _shippingAddressStore = [PaySafeMockAddressStore new];
        _shippingMethodStore = [[PaySafeMockShippingMethodStore alloc] initWithShippingMethods:paymentRequest.shippingMethods];
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    }
    return self;
}

- (void)updateSectionTitles {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:OPTTestPaymentSectionTitleCards];
    if (self.paymentRequest.requiredBillingAddressFields != PKAddressFieldNone) {
        [array addObject:OPTTestPaymentSectionTitleBillingAddress];
    }
    if (self.paymentRequest.requiredShippingAddressFields != PKAddressFieldNone) {
        [array addObject:OPTTestPaymentSectionTitleShippingAddress];
    }
    if (self.shippingMethodStore.allItems.count)
    {
        [array addObject:OPTTestPaymentSectionTitleShippingMethod];
    }
    [array addObject:OPTTestPaymentSectionTitlePayment];
    self.sectionTitles = [array copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSectionTitles];
    [self.tableView registerClass:[OPTTestPaymentSummaryItemCell class] forCellReuseIdentifier:OPTTestPaymentAuthorizationSummaryItemIdentifier];
    [self.tableView registerClass:[OPTPTestPaymentDataCell class] forCellReuseIdentifier:OPTTestPaymentAuthorizationTestDataIdentifier];
    if (self.paymentRequest.requiredShippingAddressFields != PKAddressFieldNone) {
        [self didSelectShippingAddress];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)makePayment:(id)sender {
   // self.payButton.hidden = YES;
    //[self.activityIndicator startAnimating];

    PKPayment *payment = [PKPayment new];
    NSDictionary *card = self.cardStore.selectedItem;

    //payment.opt_testCardNumber = card[@"number"];
    PaySafeMockApplePayDef.selectedCardNumber=[card objectForKey:@"number"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([payment respondsToSelector:@selector(setShippingMethod:)] && self.shippingMethodStore.selectedItem)
    {
        [payment performSelector:@selector(setShippingMethod:) withObject:self.shippingMethodStore.selectedItem];
    }
    CNContact *shippingRecord = [self.shippingAddressStore contactForSelectedItemObscure:NO];
   if ([payment respondsToSelector:@selector(setShippingAddress:)] && shippingRecord) {
       [payment performSelector:@selector(setShippingAddress:) withObject:shippingRecord];
    }
    CNContact *billingRecord = [self.billingAddressStore contactForSelectedItemObscure:NO];
    if ([payment respondsToSelector:@selector(setBillingAddress:)] && billingRecord) {
        [payment performSelector:@selector(setBillingAddress:) withObject:billingRecord];
    }
 
#pragma clang diagnostic pop

    PKPaymentAuthorizationViewController *auth = (PKPaymentAuthorizationViewController *)self;

  //  [self.activityIndicator startAnimating];
    [self.delegate paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)auth
                                  didAuthorizePayment:payment
                                           completion:^(PKPaymentAuthorizationStatus status) {
                                              // [self.activityIndicator stopAnimating];
                                               [self.delegate paymentAuthorizationViewControllerDidFinish:auth];
                                           }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
   
      [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = self.sectionTitles[section];
    if ([title isEqualToString:OPTTestPaymentSectionTitlePayment])
    {
        return self.summaryItems.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    NSString *identifier = [title isEqualToString:OPTTestPaymentSectionTitlePayment] ? OPTTestPaymentAuthorizationTestDataIdentifier :
                                                                                       OPTTestPaymentAuthorizationSummaryItemIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    if ([title isEqualToString:OPTTestPaymentSectionTitlePayment]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        PKPaymentSummaryItem *item = self.summaryItems[indexPath.row];
        NSString *text = [item.label uppercaseString];
        if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
            if (text == nil) {
                text = @"";
            }
            text = [@"PAY " stringByAppendingString:text];
        }
        cell.textLabel.text = text;

        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item.amount.stringValue, self.paymentRequest.currencyCode];
        return;
    }

    id<PaySafeMockDataStore> store = [self storeForSection:title];
    NSArray *descriptions = [store descriptionsForItem:store.selectedItem];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = descriptions[0];
    cell.detailTextLabel.text = descriptions[1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.sectionTitles[indexPath.section];
    if ([title isEqualToString:OPTTestPaymentSectionTitlePayment])
    {
        return 20.0f;
    }

    return 44.0f;
}



- (id<PaySafeMockDataStore>)storeForSection:(NSString *)section {
    id<PaySafeMockDataStore> store;
    if ([section isEqualToString:OPTTestPaymentSectionTitleCards]) {
        store = self.cardStore;
    }
    if ([section isEqualToString:OPTTestPaymentSectionTitleShippingAddress]) {
        store = self.shippingAddressStore;
    }
    if ([section isEqualToString:OPTTestPaymentSectionTitleBillingAddress]) {
        store = self.billingAddressStore;
    }
    if ([section isEqualToString:OPTTestPaymentSectionTitleShippingMethod]) {
        store = self.shippingMethodStore;
    }
    return store;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != [tableView numberOfSections] - 1;
}

- (void)didSelectShippingAddress {
    if ([self.delegate respondsToSelector:@selector(paymentAuthorizationViewController:didSelectShippingAddress:completion:)]) {
        [self.activityIndicator startAnimating];
        self.payButton.enabled = NO;
        self.tableView.userInteractionEnabled = NO;
   
        CNContact *record = [self.shippingAddressStore contactForSelectedItemObscure:YES];
        [self.delegate paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)self
                                 didSelectShippingContact:record
                                               completion:^(PKPaymentAuthorizationStatus status, NSArray *shippingMethods, NSArray *summaryItems) {
                                                   if (status == PKPaymentAuthorizationStatusFailure) {
                                                       [self.delegate paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)self];
                                                       return;
                                                   }
                                                   self.summaryItems = summaryItems;
                                                   [self.shippingMethodStore setShippingMethods:shippingMethods];
                                                   [self updateSectionTitles];
                                                   [self.tableView reloadData];
                                                   self.payButton.enabled = YES;
                                                   self.tableView.userInteractionEnabled = YES;
                                                   [self.activityIndicator stopAnimating];
                                               }];
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<PaySafeMockDataStore> store = [self storeForSection:self.sectionTitles[indexPath.section]];
    PaySafeMockDataTableViewController *controller = [[PaySafeMockDataTableViewController alloc] initWithStore:store];
    if (store == self.shippingAddressStore) {
        controller.callback = ^void(id item) { [self didSelectShippingAddress]; };
    }
    if (store == self.shippingMethodStore) {
        controller.callback = ^void(id item) {
            if ([self.delegate respondsToSelector:@selector(paymentAuthorizationViewController:didSelectShippingMethod:completion:)]) {
                [self.activityIndicator startAnimating];
                self.payButton.enabled = NO;
                self.tableView.userInteractionEnabled = NO;
                PKPaymentAuthorizationViewController *vc = (PKPaymentAuthorizationViewController *)self;
                [self.delegate paymentAuthorizationViewController:vc
                                          didSelectShippingMethod:item
                                                       completion:^(PKPaymentAuthorizationStatus status, NSArray *summaryItems) {
                                                           if (status == PKPaymentAuthorizationStatusFailure) {
                                                               [self.delegate paymentAuthorizationViewControllerDidFinish:vc];
                                                               return;
                                                           }
                                                           self.summaryItems = summaryItems;
                                                           [self updateSectionTitles];
                                                           [self.tableView reloadData];
                                                           self.payButton.enabled = YES;
                                                           self.tableView.userInteractionEnabled = YES;
                                                           [self.activityIndicator stopAnimating];
                                                       }];
            }
        };
    }
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[OPTTestPaymentPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

@implementation OPTTestPaymentPresentationController
- (CGRect)frameOfPresentedViewInContainerView 
{
    CGRect rect = [super frameOfPresentedViewInContainerView];
    rect.origin.y += 30;
    rect.size.height -= 30;
    return rect;
}

@end

@implementation OPTTestPaymentSummaryItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation OPTPTestPaymentDataCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    }
    return self;
}

@end

#endif
