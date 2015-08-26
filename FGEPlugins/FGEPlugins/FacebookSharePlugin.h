//
//  FacebookSharePlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/8/25.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "common.h"

@interface FacebookSharePlugin : NSObject<PluginProtocol, FBSDKSharingDelegate>

SHARED_INSTANCE_DEF

+(void)fbShare:(NSDictionary*)info;
@end
