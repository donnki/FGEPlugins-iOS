//
//  AdmobPlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "AdmobPlugin.h"
@import GoogleMobileAds;

@interface AdmobPlugin ()<GADInterstitialDelegate>{
    BOOL _loadingAd;
}
@property(nonatomic,strong) GADInterstitial* interstitial;
@property(nonatomic,weak) UIViewController* rootView;

-(void)newAdRequest;
@end

@implementation AdmobPlugin
@synthesize interstitial, rootView;

SHARED_INSTANCE_IMPL

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self newAdRequest];
    return YES;
}

-(void)newAdRequest{
    _loadingAd = YES;
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_INTERSTITIAL_ID];
    self.interstitial.delegate = self;
    
    [self.interstitial loadRequest:[GADRequest request]];
}
-(void)showInterstitialAD{
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    } else {
//        [[[UIAlertView alloc] initWithTitle:@"Interstitial not ready"
//                                    message:@"The interstitial didn't finish loading or failed to load"
//                                   delegate:self
//                          cancelButtonTitle:@"Drat"
//                          otherButtonTitles:nil] show];
        NSLog(@"[Warning]Ad not loaded...");
        if (!_loadingAd) {
            [self newAdRequest];
        }
    }
}
+(void)showInterstitialAD:(NSDictionary*)info{
    [[AdmobPlugin sharedInstance] showInterstitialAD];
}

#pragma mark - GADInterstitialDelegate
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
    _loadingAd = NO;
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    NSLog(@"interstitialDidDismissScreen, load next");
    [self newAdRequest];
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"interstitialDidReceiveAd");
    _loadingAd = NO;
}


@end
