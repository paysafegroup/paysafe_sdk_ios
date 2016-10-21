//
//  OPTAuthorizationProcess.m
//  TestQAMerchantApplication
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 2/13/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

#import "OPTAuthorizationProcess.h"
#import "Constant.h"
@interface OPTAuthorizationProcess()
{
    
}

@property (nonatomic, retain) UIAlertController *alertCntrl;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSData *jsonData;

@end
@implementation OPTAuthorizationProcess
@synthesize responseData;

- (instancetype)init{
    
    return self;
}

//- (instancetype)init:(NSDictionary*)dictionary{
//    
//    id dataObject = [NSDictionary dictionaryWithDictionary:dictionary];
//    
//    return [[[self class] alloc] init];
//}

- (void)prepareRequestForAuthorization:(NSDictionary *)dictionary{
    
    id dataObject = [NSDictionary dictionaryWithDictionary:dictionary];
    
    NSError *jsonSerializationError = nil;
    _jsonData = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    
    if(!jsonSerializationError) {
        //NSString *serJSON = [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
        
        [self requestServiceRequestData:_jsonData];
    } else {
    
    }
}

- (void)requestServiceRequestData:(NSData*)requestData{
    
    [self callWaitingAlertViewTitle:@"" withMessage:nil withOkBtn:NO];
    
    NSURL *projectsUrl;
    
    if (connection != nil) {
        connection = nil;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MerchantRealConfiguration" ofType:@"plist"];
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/merchantcardtestapp/v1/accounts/%@/authorizations",BaseUrl,[myDictionary objectForKey:@"merchantAccount"]];
    
        
    projectsUrl = [NSURL  URLWithString:urlString];
    
    NSString *userIDPassword= [NSString stringWithFormat:@"%@:%@", [myDictionary objectForKey:@"OptiMerchantID"], [myDictionary objectForKey:@"OptiMerchantPassword"]];
    NSData *plainData = [userIDPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    NSString *authorizationField= [NSString stringWithFormat: @"Basic %@", base64String];
    
    
    NSMutableURLRequest *dataSubmit = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [dataSubmit setHTTPMethod:@"POST"]; // 1
    [dataSubmit setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [dataSubmit setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"]; // 3
    [dataSubmit setValue:authorizationField forHTTPHeaderField:@"Authorization"];
    [dataSubmit setHTTPBody: requestData];
    
    connection = [[NSURLConnection alloc]initWithRequest:dataSubmit delegate:self];
    self.responseData=[NSMutableData data];
    
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.responseData setLength:0];
    NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"Response Error::%@",res);
    [self removeAlertView:_alertCntrl];
    [self callWaitingAlertViewTitle:@"Alert" withMessage:@"Network connection error, please try again." withOkBtn:YES];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    [self removeAlertView:_alertCntrl];
    [self.processDelegate callBackAuthorizationProcess:res];
    
}


- (void)callWaitingAlertViewTitle:(NSString *)title withMessage:(NSString*)message withOkBtn:(BOOL)isOkBtn{

    
    _alertCntrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (isOkBtn) {
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [_alertCntrl dismissViewControllerAnimated:YES completion:nil];
                                                           [self callRetryRequest];
                                                       }];
        
        [_alertCntrl addAction:cancel];
        
    } else {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake((_alertCntrl.view.bounds.size.width/2.0)-45.00, _indicator.frame.size.height);
        [_indicator startAnimating];
        [_alertCntrl.view addSubview:_indicator];
    }
        
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    [topController presentViewController:_alertCntrl animated:YES completion:nil];
    
}

- (void)removeAlertView:(UIAlertController *)alert{
    if (_indicator !=nil) {
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        _indicator = nil;
    }
    
    [_alertCntrl dismissViewControllerAnimated:YES completion:nil];
}

- (void)callRetryRequest{
    
    [self requestServiceRequestData:_jsonData];
}

@end
