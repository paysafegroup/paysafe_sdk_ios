//
//  UIViewController+Utils.m
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 2.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+Utils.h"
#import "UIResponder+FirstResponder.h"

@interface UIViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation UIViewController (UtilsExtension)

- (void)displayError:(NSError *)error {
    [self displayAlertWithTitle:@"Error" message:error.localizedDescription];
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)hideKeyboardWhenTappedAround {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer: tapGesture];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setScrollView:(UIScrollView *)object {
    objc_setAssociatedObject(self, @selector(scrollView), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)scrollView {
    return objc_getAssociatedObject(self, @selector(scrollView));
}

- (void)registerForKeyboardNotificationsWithScrollView:(UIScrollView *)scrollView {
    self.scrollView = scrollView;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(adjustForKeyboardWithNotification:) name:UIKeyboardWillHideNotification object:NULL];
    [notificationCenter addObserver:self selector:@selector(adjustForKeyboardWithNotification:) name:UIKeyboardWillChangeFrameNotification object:NULL];
}

- (void)unregisterForKeyboardNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:NULL];
    [notificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:NULL];
}

- (void)adjustForKeyboardWithNotification:(NSNotification *)notification {
    NSValue *keyboardValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (!keyboardValue) {
        return;
    }

    CGRect keyboardScreenEndFrame = keyboardValue.CGRectValue;
    CGRect keyboardViewEndFrame = [self.view convertRect:keyboardScreenEndFrame fromView:self.view.window];

    UITextField *activeTextfield = (UITextField *)[UIResponder currentFirstResponder];

    if (notification.name == UIKeyboardWillHideNotification) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    } else {
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardViewEndFrame.size.height - self.view.safeAreaInsets.bottom, 0);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardViewEndFrame.size.height, 0);
        }
    }

    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    [self.scrollView scrollRectToVisible:activeTextfield.frame
                                animated:YES];
}

@end
