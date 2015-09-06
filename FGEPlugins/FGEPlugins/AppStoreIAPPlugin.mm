//
//  AppStoreIAPPlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "AppStoreIAPPlugin.h"

#import "RMStore.h"
#import "RMStoreTransactionReceiptVerificator.h"
#import "RMStoreAppReceiptVerificator.h"
#import "RMStoreKeychainPersistence.h"

//#ifdef CC_PLATFORM_IOS
//#import "CCLuaObjcBridge.h"
//#endif

@interface AppStoreIAPPlugin(){
    id<RMStoreReceiptVerificator> _receiptVerificator;
    RMStoreKeychainPersistence *_persistence;
}
@end

@implementation AppStoreIAPPlugin

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    const BOOL iOS7OrHigher = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
    _receiptVerificator = iOS7OrHigher ? [[RMStoreAppReceiptVerificator alloc] init] : [[RMStoreTransactionReceiptVerificator alloc] init];
    [RMStore defaultStore].receiptVerificator = _receiptVerificator;
    
    _persistence = [[RMStoreKeychainPersistence alloc] init];
    [RMStore defaultStore].transactionPersistor = _persistence;
    return YES;
}

+ (id)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+(void)requestProuducts:(NSDictionary*)info{
    NSArray *_products = [info objectForKey:@"products"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:_products] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", products);
        id successCallback = [info objectForKey:@"successCallback"];
        if (successCallback != nil){
            ((operationCallback)successCallback)(@{@"response":@"Buy item success..."});
        }

        
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Products Request Failed", @"")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
        id failedCallback = [info objectForKey:@"failedCallback"];
        if (failedCallback != nil){
            ((operationCallback)failedCallback)(@{@"response":@"Buy item failed..."});
        }

    }];

}
+(void)payForProduct:(NSDictionary*)info{
    if (![RMStore canMakePayments]) return;
    
    NSString *productID = [info objectForKey:@"productID"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] addPayment:productID success:^(SKPaymentTransaction *transaction) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        id successCallback = [info objectForKey:@"successCallback"];
        if (successCallback != nil){
            ((operationCallback)successCallback)(@{
                                                   @"responseText":@"success!",
                                                   @"productID":productID,
                                                   @"success":[NSNumber numberWithBool:YES]});
        }
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Payment Transaction Failed", @"")
                                                           message:error.localizedDescription
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                 otherButtonTitles:nil];
        [alerView show];
        id failedCallback = [info objectForKey:@"failedCallback"];
        if (failedCallback != nil){
            ((operationCallback)failedCallback)(@{
                                                   @"responseText":@"Payment Transaction Failed!",
                                                   @"productID":productID,
                                                   @"success":[NSNumber numberWithBool:NO]});
        }
    }];
}


@end
