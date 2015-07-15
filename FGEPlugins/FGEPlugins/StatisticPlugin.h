//
//  TalkingGameStatisticPlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"
#import "TalkingDataGA.h"


@interface StatisticPlugin : NSObject<PluginProtocol>

SHARED_INSTANCE_DEF

+(void)onStatisticEvent:(NSDictionary*)param;
@end
