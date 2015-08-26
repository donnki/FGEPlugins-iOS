//
//  common.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#ifndef FGEPlugins_common_h
#define FGEPlugins_common_h

#define AppStoreIAPPluginEnabled                    1
#define StatisticPluginEnabled                      0
#define AdmobPluginEnabled                          0
#define GameCenterServicePluginEnabled              0
#define FacebookSharePluginEnabled                  1


#define TALKINGDATA_APP_ID              @"975F36485069F0D6AC98A258DC7BC106"
#define TALKINGDATA_CHANNEL_ID          @"TEST_CHANNEL"
#define ADMOB_INTERSTITIAL_ID           @"ca-app-pub-2550536070025080/1660836858"
#define GAMECENTER_LEADERBOARD_ID       @"single_round_scores"
#define GAMECENTER_ACHIEVEMENT_IDS      @[@"com.banabala.jellyddd.achievement.bomb100"]
#define GAMECENTER_SAVED_KEY            @"savedData"

typedef void(^operationCallback)(NSDictionary *param);
@protocol PluginProtocol <NSObject>
@optional
-(void)onCreate:(id)context;
-(void)onStart;
-(void)onStop;
-(void)onDestory;
-(void)onResume;
-(void)onPause;
@end

#define SHARED_INSTANCE_DEF +(id)sharedInstance;
#define SHARED_INSTANCE_IMPL  +(id)sharedInstance{\
static dispatch_once_t once;\
static id sharedInstance;\
dispatch_once(&once, ^{\
sharedInstance = [[self alloc] init];\
});\
return sharedInstance;\
}


#endif
