//
//  PSThreeDSecureViewController.h
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 1.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MerchantSampleBackend;

@interface PSThreeDSecureViewController: UIViewController

- (void)configureWithCardBin:(NSString *)cardBin withMerchantBackend:(MerchantSampleBackend *)merchantBackend;

@end
