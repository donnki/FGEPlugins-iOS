//
//  FGEPlugins.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/11.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "common.h"
#import "AdmobPlugin.h"
#import "CommonHelper.h"
#import "StatisticPlugin.h"
#import "AppStoreIAPPlugin.h"
#import "GameCenterServicePlugin.h"
#import "FacebookSharePlugin.h"
#import "TagManagerPlugin.h"


@interface FGEPlugins : NSObject

+(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
