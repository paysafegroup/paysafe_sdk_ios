
#import <Availability.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@protocol OPTTestPaymentSummaryViewControllerDelegate<NSObject>

@required
@end;

@interface PaySafeMockPaymentSummaryViewController : UIViewController 

@property(nonatomic, assign)id<OPTTestPaymentSummaryViewControllerDelegate>summeryDelegate;

- (instancetype)initWithPaymentRequest:(PKPaymentRequest *)paymentRequest;
@property(nonatomic, assign)id<PKPaymentAuthorizationViewControllerDelegate>delegate;

@end

#endif