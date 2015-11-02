//
//  FGEPluginsIOSWapper.m
//  RunPuppyRunGoogle
//
//  Created by Loy Liu on 15/7/14.
//
//

#import "FGEPluginsIOSWapper.h"
#import "CCLuaObjcBridge.h"
#import <GameKit/GameKit.h>

@interface FGEPluginsIOSWapper(){
    
}
@end

@implementation FGEPluginsIOSWapper
SHARED_INSTANCE_IMPL

static BOOL _productRequested = false;
static int successCallback, failedCallback, gtmRefreshedCallback;

-(void)onAdStateChanged:(NSNotification*)notification{
    NSString *state = [notification object];
    if([state isEqualToString:@"AD_DISMISSED"]){
        cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("EventAdClosed");
    }else if ([state isEqualToString:@"AD_LOADED"]){
        cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("EventAdLoaded");
    }else if ([state isEqualToString:@"AD_FAILED"]){
        cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("EventLoadAdFailed");
    }
}

-(void)onTagManagerInit:(NSNotification*)notification{
    NSDictionary *dict = [notification object];
    NSLog(@"%@", dict);
    
//    void *param = (void*)"test~~~~~~";
//    cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("EventGTMRefreshed", param);
    if(gtmRefreshedCallback != 0){
        cocos2d::LuaObjcBridge::pushLuaFunctionById(gtmRefreshedCallback);
        cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::dictValue(nsDictionary2LuaValueDict(dict)));
        cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
        cocos2d::LuaObjcBridge::releaseLuaFunctionById(gtmRefreshedCallback);
        gtmRefreshedCallback = 0;
    }
}

+(void)onInit{
#ifdef GameCenterServicePluginEnabled
    [[GameCenterServicePlugin sharedInstance] setCallback:^(NSString* playerID){
        cocos2d::Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("EventGameCenterLoginSuccess");
    }];
#endif
    
#ifdef TagManagerPluginEnabled
    [[NSNotificationCenter defaultCenter] addObserver:[FGEPluginsIOSWapper sharedInstance] selector:@selector(onTagManagerInit:) name:GTM_CONTAINER_REFRESHED object:nil];
#endif

#ifdef AdmobPluginEnabled
    [[NSNotificationCenter defaultCenter] addObserver:[FGEPluginsIOSWapper sharedInstance] selector:@selector(onAdStateChanged:) name:@"OnAdStateChanged" object:nil];
#endif
//#ifdef AppStoreIAPPluginEnabled
//    [FGEPluginsIOSWapper requestProducts];
//#endif
}


+(void)requestProducts:(NSDictionary* )productsDic{
//    NSArray *products = @[@"com.luciolagames.stutterrapper.diamond10"];
    
    NSMutableArray *products = [NSMutableArray array];
    for (NSString *key in productsDic.allKeys) {
        [products addObject:[productsDic objectForKey:key]];
    }
    [AppStoreIAPPlugin requestProuducts:@{@"products": products, @"successCallback":(^(NSDictionary* response){
        CCLOG("product request finished");
        _productRequested = true;
    })}];
}

void calliAPResponseFunc(int handler, NSDictionary *response){
    BOOL b = [[response objectForKey:@"success"] boolValue];
    if(b){
        cocos2d::LuaObjcBridge::pushLuaFunctionById(successCallback);
    }else{
        cocos2d::LuaObjcBridge::pushLuaFunctionById(failedCallback);

    }
    cocos2d::LuaValueDict item;
    item["responseText"] =  cocos2d::LuaValue::stringValue([[response objectForKey:@"responseText"] UTF8String]);
    item["productID"] =  cocos2d::LuaValue::stringValue([[response objectForKey:@"productID"] UTF8String]);
    item["success"] =  cocos2d::LuaValue::booleanValue(b);
    cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
    cocos2d::LuaObjcBridge::releaseLuaFunctionById(successCallback);
    cocos2d::LuaObjcBridge::releaseLuaFunctionById(failedCallback);
    successCallback = 0;
    failedCallback = 0;
}

cocos2d::LuaValueDict nsDictionary2LuaValueDict(NSDictionary *dic){
    cocos2d::LuaValueDict dict;
    for (NSString *key in [dic allKeys]) {
        id item = [dic objectForKey:key];
        if ([item isKindOfClass:[NSNumber class]]) {
            dict[[key UTF8String]] = cocos2d::LuaValue::intValue([item intValue]);
        }else if([item isKindOfClass:[NSString class]]){
            dict[[key UTF8String]] = cocos2d::LuaValue::stringValue([item UTF8String]);
        }else if ([item isKindOfClass:[NSDictionary class]]){
            dict[[key UTF8String]] = cocos2d::LuaValue::dictValue(nsDictionary2LuaValueDict(item));
        }else{
            NSLog(@"Unkown value type, ignored...");
        }
    }
    
    return dict;
}

+(void)payForProduct:(NSDictionary*)info{
    if (_productRequested) {
        successCallback = [[info objectForKey:@"successCallback"] intValue];
        failedCallback = [[info objectForKey:@"failedCallback"] intValue];
        NSDictionary *newInfoDic = @{
                                     @"productID":[info objectForKey:@"productID"],
                                     @"successCallback": (^(NSDictionary* response){
                                         calliAPResponseFunc(successCallback, response);
                                     }),
                                     @"failedCallback":(^(NSDictionary* response){
                                         calliAPResponseFunc(failedCallback, response);
                                     })};
        
        [AppStoreIAPPlugin payForProduct:newInfoDic];
    }else{
        calliAPResponseFunc(failedCallback, @{
                                              @"productID":[info objectForKey:@"productID"],
                                              @"success": [NSNumber numberWithBool:NO],
                                              @"responseText": @"NO_INTERNET"
                                              });
    }
    
    
}

+(void)saveGame:(NSDictionary*)info{

    int successCallback = [[info objectForKey:@"successCallback"] intValue];
    int failedCallback = [[info objectForKey:@"failedCallback"] intValue];
    NSDictionary *newinfo = @{
                              @"data":[info objectForKey:@"saveJson"],
                              @"callback":  (^(GKSavedGame *savedGame, NSError *error){
                                  if (!error) {
                                      [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                          [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                              if (successCallback != 0) {
                                                  NSString *jsonString = (NSString*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                                  //cocos2d::LuaValueDict luaDict = nsDictionary2LuaValueDict(dic);
                                                  cocos2d::LuaObjcBridge::pushLuaFunctionById(successCallback);
                                                  cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([jsonString UTF8String]));
                                                  cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
                                                  cocos2d::LuaObjcBridge::releaseLuaFunctionById(successCallback);
                                                  cocos2d::LuaObjcBridge::releaseLuaFunctionById(failedCallback);
                                              }
                                              
                                          }];
                                      }];
                                      
                                  }else{
                                      NSLog(@"error: %@", error);
                                      if(failedCallback != 0){
                                          NSString *jsonString = [error description];
                                          //cocos2d::LuaValueDict luaDict = nsDictionary2LuaValueDict(dic);
                                          cocos2d::LuaObjcBridge::pushLuaFunctionById(failedCallback);
                                          cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([jsonString UTF8String]));
                                          cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
                                          cocos2d::LuaObjcBridge::releaseLuaFunctionById(failedCallback);
                                          cocos2d::LuaObjcBridge::releaseLuaFunctionById(successCallback);
                                      }
                                  }
                              })
                              
                              };
#ifdef GameCenterServicePluginEnabled
    [GameCenterServicePlugin saveGame:newinfo];
#endif
}

+(void)loadGame:(NSDictionary*)info{

    int callback = [[info objectForKey:@"successCallback"] intValue];
    NSDictionary *newinfo = @{
                              @"callback":  (^(NSArray *savedGames, NSError *error){
                                  if (!error) {
                                      for (GKSavedGame *savedGame in savedGames) {
                                          [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                              [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                                  if (successCallback != 0) {
                                                      NSString *jsonString = (NSString*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                                      //cocos2d::LuaValueDict luaDict = nsDictionary2LuaValueDict(dic);
                                                      cocos2d::LuaObjcBridge::pushLuaFunctionById(callback);
                                                      cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([jsonString UTF8String]));
                                                      cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
                                                      cocos2d::LuaObjcBridge::releaseLuaFunctionById(callback);
                                                  }
                                                  
                                              }];
                                          }];
                                      }
                                      
                                      
                                  }else{
                                      NSLog(@"error: %@", error);
                                  }
                              })
                              
                              };
#ifdef GameCenterServicePluginEnabled
    [GameCenterServicePlugin loadGame:newinfo];
#endif
}

+(void)fbShare:(NSDictionary*)info{
    int callback = [[info objectForKey:@"callback"] intValue];
    [[FacebookSharePlugin sharedInstance] setCallback:^(BOOL success, NSString* response){
        cocos2d::LuaObjcBridge::pushLuaFunctionById(callback);
        cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::booleanValue(success));
        cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([response UTF8String]));
        cocos2d::LuaObjcBridge::getStack()->executeFunction(2);
        cocos2d::LuaObjcBridge::releaseLuaFunctionById(callback);
    }];
    [FacebookSharePlugin fbShare:info];
}

+(void)initGTMWithRefreshCallback:(NSDictionary*)info{
    gtmRefreshedCallback = [[info objectForKey:@"callback"] intValue];
    [[TagManagerPlugin sharedInstance] doInit:@[@"activity_id", @"button_word", @"description", @"gift_type", @"gift_amount", @"user_id"]];
}

+(void)registerGTMFunctionCall:(NSDictionary*)info{
    NSString *key = [info objectForKey:@"key"];
    int callback = [[info objectForKey:@"callback"] intValue];
    id isMacroCall = [info objectForKey:@"isMacro"];
    CCLOG("registerGTMFunctionCall: %s, %d", [key UTF8String], callback);
    TagManagerPlugin *gtm = [TagManagerPlugin sharedInstance];
    if (gtm.isContainnerAvailable) {
        if (isMacroCall) {
//            [gtm.container registerFunctionCallMacroHandler:(id<TAGFunctionCallMacroHandler>) forMacro:key]
        }else{
            [gtm.container registerFunctionCallTagHandler:[[CustomTagHandler alloc] initWithCallback:
                                                           ^(NSString* tag, NSDictionary* params){
                                                               NSString *jsonString = @"";
                                                               NSError *error;
                                                               NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                                                                                  options:NSJSONWritingPrettyPrinted
                                                                                                                    error:&error];
                                                               
                                                               if (! jsonData) {
                                                                   NSLog(@"Got an error: %@", error);
                                                               } else {
                                                                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                                               }
                                                               cocos2d::LuaObjcBridge::pushLuaFunctionById(callback);
                                                               cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([tag UTF8String]));
                                                               cocos2d::LuaObjcBridge::getStack()->pushLuaValue(cocos2d::LuaValue::stringValue([jsonString UTF8String]));
                                                               cocos2d::LuaObjcBridge::getStack()->executeFunction(2);
                                                               cocos2d::LuaObjcBridge::releaseLuaFunctionById(callback);
                                                           }] forTag:key];
        }
        
        
    }
    
}

@end
