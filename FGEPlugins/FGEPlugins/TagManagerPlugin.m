//
//  TagManagerPlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/9/6.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "TagManagerPlugin.h"
#import <UIKit/UIKit.h>


@implementation CustomTagHandler
-(id)initWithCallback:(id)callback{
    if (self = [super init]) {
        self.callback = callback;
    }
    return self;
}
- (void)execute:(NSString *)tagName parameters:(NSDictionary *)parameters {
    NSLog(@"Custom function call tag :%@ is fired", tagName);
    // Other code firing this custom tag.
    if (self.callback) {
        self.callback(tagName, parameters);
    }
}
@end
@interface CustomMacroHandler : NSObject <TAGFunctionCallMacroHandler>
@property(nonatomic) NSUInteger numOfCalls;
@end

@implementation CustomMacroHandler
- (id)valueForMacro:(NSString *)macroName
         parameters:(NSDictionary *)parameters {
    if ([macroName isEqual:@"increment"]) {
        self.numOfCalls++;
        return [NSString stringWithFormat:@"%d", self.numOfCalls];
    } else if ([macroName isEqual:@"mod"]) {
        NSString *value1 = parameters[@"key1"];
        NSString *value2 = parameters[@"key2"];
        return [NSNumber numberWithInt:([value1 intValue] % [value2 intValue])];
    } else {
        NSString *message =
        [NSString stringWithFormat:@"Custom macro name: %@ is not supported", macroName];
        @throw [NSException exceptionWithName:@"IllegalArgumentException"
                                       reason:message
                                     userInfo:nil];
    }
}

@end


@interface TagManagerPlugin()
@property(nonatomic) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(TAGDispatchResult result);
@end

@implementation TagManagerPlugin
@synthesize tagManager = _tagManager;
@synthesize container = _container;
SHARED_INSTANCE_IMPL

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.tagManager = [TAGManager instance];
    
    // Modify the log level of the logger to print out not only
    // warning and error messages, but also verbose, debug, info messages.
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    // Following provides ability to support preview from Tag Manager.
    // You need to make these calls before opening a container to make
    // preview works.
    NSURL *url = [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil) {
        [self.tagManager previewWithUrl:url];
    }
    
    // Open a container.
    [TAGContainerOpener openContainerWithId:GTM_CONTAINER_ID
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferNonDefault
                                    timeout:nil
                                   notifier:self];
    return YES;
}

- (void)containerAvailable:(TAGContainer *)container {
        // Important note: containerAvailable may be called from a different thread, marshall the
    // notification back to the main thread to avoid a race condition with viewDidAppear.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
        self.isContainnerAvailable = YES;
        // Register two custom function call macros to the container.
//        for (NSString *callback in GTM_MACRO_CALLBACKS) {
//            [self.container registerFunctionCallMacroHandler:[[CustomMacroHandler alloc] init]
//                                                    forMacro:callback];
//            
//        }
        
//        for (NSString *callback in GTM_TAG_CALLBACKS) {
//            [self.container registerFunctionCallTagHandler:[[CustomTagHandler alloc] init]
//                                                    forTag:callback];
//            
//        }
    });
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([self.tagManager previewWithUrl:url]) {
        return YES;
    }
    
    // Code to handle other urls.
    
    return NO;
}

// In case the app was sent into the background when there was no network connection, we will use
// the background data fetching mechanism to send any pending Google Analytics data.  Note that
// this app has turned on background data fetching in the capabilities section of the project.
-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self sendHitsInBackground];
    completionHandler(UIBackgroundFetchResultNewData);
}

// We'll try to dispatch any hits queued for dispatch as the app goes into the background.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self sendHitsInBackground];
}

- (void)sendHitsInBackground {
    self.okToWait = YES;
    __weak TagManagerPlugin *weakSelf = self;
    __block UIBackgroundTaskIdentifier backgroundTaskId =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        weakSelf.okToWait = NO;
    }];
    
    if (backgroundTaskId == UIBackgroundTaskInvalid) {
        return;
    }
    
    self.dispatchHandler = ^(TAGDispatchResult result) {
        // If the last dispatch succeeded, and we're still OK to stay in the background then kick off
        // again.
        if (result == kTAGDispatchGood && weakSelf.okToWait ) {
            [[TAGManager instance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
        }
    };
    [[TAGManager instance] dispatchWithCompletionHandler:self.dispatchHandler];
}

-(void)refreshData{
    [self.container refresh];
    
}

-(void)pushEvent:(NSString*)event{
    [self.tagManager.dataLayer pushValue:event forKey:@"event"];
}

-(void)pushData:(NSDictionary*)dic{
    [self.tagManager.dataLayer push:dic];
}

+(void)refresh{
    [[TagManagerPlugin sharedInstance] refresh];
}

+(void)pushEvent:(NSDictionary*)info{
    NSString* event = [info objectForKey:@"eventId"];
    NSString* data = [info objectForKey:@"data"];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (dic.count > 0) {
        [dic setObject:event forKey:@"event"];
        [[TagManagerPlugin sharedInstance] pushData:dic];
    }else{
        [[TagManagerPlugin sharedInstance] pushEvent:event];
    }
}
@end
