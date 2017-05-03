//
//  Utils.h
//  TestMerchAppExample_Obj-C
//
//  Created by Ashish on 24/04/16.
//  Copyright © 2016 opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
//        

@interface Utils : NSObject

//Random generate string
+(NSString *) randomStringWithLength: (u_int32_t) len;
+(NSString *) randomNumberWithLength: (u_int32_t) len;

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(BOOL)keysExist: (NSString *) strKeys;
@end
