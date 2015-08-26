//
//  GameCenterServicePlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "GameCenterServicePlugin.h"
#import "GameCenterManager.h"

@interface GameCenterManager (DataLoader)
-(void)loadLeaderboard:(NSString*)identifier WithCompletionHandler:(void (^)(NSArray *scores))completionHandler;
@end

@implementation GameCenterManager (DataLoader)

-(void)loadLeaderboard:(NSString*)identifier
 WithCompletionHandler:(void (^)(NSArray *scores))completionHandler{
    if (self.isGameCenterAvailable) {
        GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayers:[NSArray arrayWithObject:[self localPlayerData]]];
        
        [leaderboardRequest setTimeScope:GKLeaderboardTimeScopeAllTime];
        [leaderboardRequest setPlayerScope:GKLeaderboardPlayerScopeGlobal];
        [leaderboardRequest setIdentifier:identifier];
        
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if (error == nil) {
                completionHandler(scores);
            }
        }];
         
    }
}

-(void)saveGameData:(NSDictionary*)dic
           withName:(NSString*) name
  completionHandler:(void (^)(GKSavedGame *savedGame, NSError *error))handler{
    if (self.isGameCenterAvailable) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[self localPlayerData] saveGameData:data withName:name completionHandler:handler];
    }
}

- (void)loadGameData:(void (^)(NSArray *savedGames,
                                                       NSError *error))handler{
    if (self.isGameCenterAvailable) {
        [[self localPlayerData] fetchSavedGamesWithCompletionHandler:handler];
    }
    
}

@end

@interface GameCenterServicePlugin()<GameCenterManagerDelegate>
- (void)showAchievements;
@end

@implementation GameCenterServicePlugin

SHARED_INSTANCE_IMPL

-(void)onCreate:(id)context{
    [[GameCenterManager sharedManager] setDelegate:self];
    NSLog(@"%@", [GameCenterManager sharedManager].delegate);
    [[GameCenterManager sharedManager] setupManager];
}

- (void)showAchievements {
    [[GameCenterManager sharedManager] presentAchievementsOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)showLeaderboards {
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)submitScore:(int)score forLeaderboard:(NSString*)leaderboardID{
    [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:leaderboardID sortOrder:GameCenterSortOrderHighToLow];
}

- (void)unlockAchievement:(NSString*)achievementID withProgress:(int)percent{
    [[GameCenterManager sharedManager] saveAndReportAchievement:achievementID percentComplete:percent shouldDisplayNotification:percent>=100];
}

#pragma mark - Lua interfaces

+(void)showAchievements:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] showAchievements];
}


+(void)showLeaderboards:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] showLeaderboards];
}

+(void)submitLeaderboardScore:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] submitScore:[[info objectForKey:@"score"] intValue] forLeaderboard:[info objectForKey:@"leaderboardID"]];
}

+(void)unlockAchievement:(NSDictionary*)info{
    [[GameCenterServicePlugin sharedInstance] unlockAchievement:[info objectForKey:@"achievementID"] withProgress:[[info objectForKey:@"percent"] intValue]];
}

+(void)loadLeaderboardScore:(NSDictionary*)info{
    [[GameCenterManager sharedManager] loadLeaderboard:[info objectForKey:@"leaderboardID"] WithCompletionHandler:^(NSArray *data) {
        NSLog(@"%@", data);
    }];
}

+(void)saveGame:(NSDictionary*)info{
    NSDictionary *data = [info objectForKey:@"data"];
    id callback = [info objectForKey:@"callback"];

    [[GameCenterManager sharedManager] saveGameData:data withName:GAMECENTER_SAVED_KEY completionHandler:callback];
}


+(void)loadGame:(NSDictionary*)info{
    id callback = [info objectForKey:@"callback"];
    [[GameCenterManager sharedManager] loadGameData:callback];
}

#pragma mark -  GameCenter Manager Delegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
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
