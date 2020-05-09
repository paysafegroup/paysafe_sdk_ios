//
//  UIViewController+Utils.h
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 2.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UtilsExtension)

- (void)displayError:(NSError *)error;
- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)registerForKeyboardNotificationsWithScrollView:(UIScrollView *)scrollView;
- (void)unregisterForKeyboardNotifications;
- (void)hideKeyboardWhenTappedAround;

@end
