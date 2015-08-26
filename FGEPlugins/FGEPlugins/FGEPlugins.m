//
//  FGEPlugins.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/11.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "FGEPlugins.h"



@implementation FGEPlugins

+(void)onCreate:(id)context{
    if(AppStoreIAPPluginEnabled &&[[AppStoreIAPPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]){
        [[AppStoreIAPPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    };
    
    if (StatisticPluginEnabled && [[StatisticPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[StatisticPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
    
    if (AdmobPluginEnabled && [[AdmobPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[AdmobPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
    
    if (GameCenterServicePluginEnabled && [[GameCenterServicePlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[GameCenterServicePlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
    
    if (FacebookSharePluginEnabled && [[FacebookSharePlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[FacebookSharePlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
}
+(void)onStart{
    
}
+(void)onStop{
    
}
+(void)onDestory{
    
}
+(void)onResume{
    
}
+(void)onPause{
    
}


@end
