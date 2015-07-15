//
//  GameCenterServicePlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface GameCenterServicePlugin : NSObject<PluginProtocol>

SHARED_INSTANCE_DEF

+(void)showAchievements:(NSDictionary*)info;
+(void)showLeaderboards:(NSDictionary*)info;
@end
