//
//  Utils.m
//  TestMerchAppExample_Obj-C
//
//  Created by Ashish on 24/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import "Utils.h"
#define Letters @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
#define Numbers @"0123456789";


@implementation Utils
//-------------------Return Random string with length------------------------

+(NSString *) randomStringWithLength: (u_int32_t) len {
    NSString *letters = Letters;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    u_int32_t length = (u_int32_t)letters.length;
    for (int i=0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(length)]];
    }
    
    return randomString;
}

//-------------------Return Random number with length------------------------
+(NSString *) randomNumberWithLength: (u_int32_t) len {
    NSString *letters = Numbers;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    u_int32_t length = (u_int32_t)letters.length;
    for (int i=0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(length)]];
    }
    
    return randomString;
}

//-------------------Check string nill or empty------------------------
+(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}
//-------------------Check key exist or not------------------------
+(BOOL)keysExist: (NSString *) strKeys
{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:strKeys]){
        return YES;
    }
    return NO;
}
@end
