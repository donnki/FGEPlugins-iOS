//
//  AdmobPlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface AdmobPlugin : NSObject

SHARED_INSTANCE_DEF
-(void)showInterstitialAD;
+(void)showInterstitialAD:(NSDictionary*)info;
@end
