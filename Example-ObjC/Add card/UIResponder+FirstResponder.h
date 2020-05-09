//
//  UIResponder+FirstResponder.h
//  Example-ObjC
//
//  Created by Tsvetelina Stoyanova on 5.08.19.
//  Copyright © 2019 Paysafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (FirstResponder)

+ (id)currentFirstResponder;

@end
