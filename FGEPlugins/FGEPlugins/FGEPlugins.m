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
    BOOL ret = YES;
#ifdef AppStoreIAPPluginEnabled
    [[AppStoreIAPPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif

#ifdef StatisticPluginEnabled
    [[StatisticPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif

#ifdef AdmobPluginEnabled
    [[AdmobPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif
    
#ifdef GameCenterServicePluginEnabled
    [[GameCenterServicePlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif
    
#ifdef FacebookSharePluginEnabled
    ret = ret && [[FacebookSharePlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif
    
#ifdef TagManagerPluginEnabled
    ret = ret &&  [[TagManagerPlugin sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#endif
    return ret;
}

+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
#ifdef FacebookSharePluginEnabled
    return [[FacebookSharePlugin sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
#endif
    return YES;
}
@end
