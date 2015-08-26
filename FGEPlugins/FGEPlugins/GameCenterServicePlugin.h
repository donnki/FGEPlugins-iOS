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

/*
 显示成就列表
 */
+(void)showAchievements:(NSDictionary*)info;

/*
 显示排行榜
 */
+(void)showLeaderboards:(NSDictionary*)info;

/**
 提交排行榜分数：
 参数: info = @{
            @"leaderboardID":XXXX,
            @"score": XXXX
        }
 */
+(void)submitLeaderboardScore:(NSDictionary*)info;

/*
 解锁成就
 参数： info = @{
            @"achievementID":XXXX,
            @"progress":XXX
        }
 */
+(void)unlockAchievement:(NSDictionary*)info;


+(void)loadLeaderboardScore:(NSDictionary*)info;

+(void)loadGame:(NSDictionary*)info;
+(void)saveGame:(NSDictionary*)info;
@end
