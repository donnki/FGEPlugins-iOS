//
//  FGEPluginsIOSWapper.h
//  RunPuppyRunGoogle
//
//  Created by Loy Liu on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "FGEPlugins.h"

@interface FGEPluginsIOSWapper : NSObject
SHARED_INSTANCE_DEF
+(void)onInit;
+(void)requestProducts:(NSDictionary* )productsDic;
+(void)payForProduct:(NSDictionary*)info;

+(void)saveGame:(NSDictionary*)info;
+(void)loadGame:(NSDictionary*)info;

+(void)fbShare:(NSDictionary*)info;

+(void)registerGTMFunctionCall:(NSDictionary*)info;
+(void)initGTMWithRefreshCallback:(NSDictionary*)info;
@end
