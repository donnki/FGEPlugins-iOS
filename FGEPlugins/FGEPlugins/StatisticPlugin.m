//
//  TalkingGameStatisticPlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "StatisticPlugin.h"
#import <UIKit/UIKit.h>
@implementation StatisticPlugin

SHARED_INSTANCE_IMPL

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [TalkingDataGA onStart:TALKINGDATA_APP_ID withChannelId:TALKINGDATA_CHANNEL_ID];
    return YES;
}

+(void)onStatisticEvent:(NSDictionary *)param{
    NSString *eventId = [param objectForKey:@"eventId"];
    NSString *data = [param objectForKey:@"data"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    [TalkingDataGA onEvent:eventId eventData:dic];
}
@end
