//
//  TagManagerPlugin.h
//  FGEPlugins
//
//  Created by Loy Liu on 15/9/6.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"
#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGLogger.h"
#import "TAGManager.h"
#import "TAGDataLayer.h"
@interface TagManagerPlugin : NSObject<PluginProtocol,TAGContainerOpenerNotifier>
@property(nonatomic, retain) TAGManager *tagManager;
@property(nonatomic, retain) TAGContainer *container;
SHARED_INSTANCE_DEF


-(void)refreshData;
-(void)pushEvent:(NSString*)event;
-(void)pushData:(NSDictionary*)dic;

+(void)refresh;
@end
