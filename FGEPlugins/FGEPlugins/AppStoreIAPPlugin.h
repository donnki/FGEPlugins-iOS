//
//  AppStoreIAPPlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface AppStoreIAPPlugin : NSObject<PluginProtocol>


+(id)sharedInstance;
+(void)requestProuducts:(NSDictionary*)info;
+(void)payForProduct:(NSDictionary*)info;

@end
