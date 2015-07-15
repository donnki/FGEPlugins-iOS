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
    if([[AppStoreIAPPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]){
        [[AppStoreIAPPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    };
    
    if ([[StatisticPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[StatisticPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
    
    if ([[AdmobPlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[AdmobPlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
    }
    
    if ([[GameCenterServicePlugin sharedInstance] respondsToSelector:@selector(onCreate:)]) {
        [[GameCenterServicePlugin sharedInstance] performSelector:@selector(onCreate:) withObject:context];
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
