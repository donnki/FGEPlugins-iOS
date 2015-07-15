//
//  FGEPlugins.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/11.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdmobPlugin.h"
#import "CommonHelper.h"
#import "StatisticPlugin.h"
#import "AppStoreIAPPlugin.h"
#import "GameCenterServicePlugin.h"

@interface FGEPlugins : NSObject

+(void)onCreate:(id)context;
+(void)onStart;
+(void)onStop;
+(void)onDestory;
+(void)onResume;
+(void)onPause;
@end
