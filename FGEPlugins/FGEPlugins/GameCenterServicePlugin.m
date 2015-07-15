//
//  GameCenterServicePlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "GameCenterServicePlugin.h"

#import "GameCenterManager.h"

@interface GameCenterServicePlugin()<GameCenterManagerDelegate>
- (void)showAchievements;
@end

@implementation GameCenterServicePlugin

SHARED_INSTANCE_IMPL

-(void)onCreate:(id)context{
    [[GameCenterManager sharedManager] setDelegate:self];
    [[GameCenterManager sharedManager] setupManager];
}

- (void)showAchievements {
    [[GameCenterManager sharedManager] presentAchievementsOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)showLeaderboards {
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

#pragma mark - Lua interfaces

+(void)showAchievements:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] showAchievements];
}


+(void)showLeaderboards:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] showLeaderboards];
}

#pragma mark -  GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    NSLog(@"Finished Presenting Authentication Controller");
}

- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    GKLocalPlayer *player = [[GameCenterManager sharedManager] localPlayerData];
    if (player) {
        NSLog(@"Hello, %@", player.displayName);
    }else{
        NSLog(@"No GameCenter player found.");
    }
    
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    NSLog(@"GCM Error: %@", error);
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Achievement: %@", achievement);
    } else {
        NSLog(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Score: %@", score);
    } else {
        NSLog(@"GCM Error while reporting score: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
    NSLog(@"Saved GCM Score with value: %lld", score.value);
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
    NSLog(@"Saved GCM Achievement: %@", achievement);
}
@end
