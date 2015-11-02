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

typedef void(^TagCallback)(NSString* tagName, NSDictionary *param);

@interface CustomTagHandler : NSObject <TAGFunctionCallTagHandler>
@property(nonatomic, strong) TagCallback callback;

-(id)initWithCallback:(id)callback;
@end

@interface TagManagerPlugin : NSObject<PluginProtocol,TAGContainerOpenerNotifier,TAGContainerCallback>
@property(nonatomic, retain) TAGManager *tagManager;
@property(nonatomic, retain) TAGContainer *container;
@property(nonatomic, strong, readonly) NSArray *containerKeys;
@property(nonatomic) BOOL isContainnerAvailable;
SHARED_INSTANCE_DEF


-(void)refreshData;
-(void)pushEvent:(NSString*)event;
-(void)pushData:(NSDictionary*)dic;
-(void)doInit:(NSArray*)keys;

+(void)refresh;
+(void)pushEvent:(NSDictionary*)info;
@end
