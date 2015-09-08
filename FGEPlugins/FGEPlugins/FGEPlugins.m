//
//  FGEPlugins.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/11.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "FGEPlugins.h"



@implementation FGEPlugins

+(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if(AppStoreIAPPluginEnabled &&[[AppStoreIAPPlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]){
        [[AppStoreIAPPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    };
    
    if (StatisticPluginEnabled && [[StatisticPlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        [[StatisticPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    if (AdmobPluginEnabled && [[AdmobPlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        [[StatisticPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    if (GameCenterServicePluginEnabled && [[GameCenterServicePlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        [[GameCenterServicePlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    if (FacebookSharePluginEnabled && [[FacebookSharePlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        return [[FacebookSharePlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
    
    if (TagManagerPluginEnabled && [[TagManagerPlugin sharedInstance] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        return [[TagManagerPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if (FacebookSharePluginEnabled && [[FacebookSharePlugin sharedInstance] respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
        return [[FacebookSharePlugin sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}
@end
