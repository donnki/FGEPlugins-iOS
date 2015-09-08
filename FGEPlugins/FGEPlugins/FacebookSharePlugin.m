//
//  FacebookSharePlugin.m
//  FGEPlugins
//
//  Created by Loy Liu on 15/8/25.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "FacebookSharePlugin.h"

@implementation FacebookSharePlugin

SHARED_INSTANCE_IMPL

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FBSDKLikeControl class];
    [FBSDKLoginButton class];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

+(void)fbShare:(NSDictionary*)info{
    /*
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:[info objectForKey:@"image"] userGenerated:YES];
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    content.contentURL = [NSURL URLWithString:@"http://www.luciolagames.com/"];
     */
     /*
    NSDictionary *properties = @{
                                 @"og:type": @"game",
                                 @"og:title": @"Sample Game",
                                 @"og:description": @"Sample Game Description",
                                 @"og:url": @"http://www.luciolagames.com",
                                 @"og:image": @[photo]
                                 };
    FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];

    
    // Create an action
    FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
    action.actionType = @"luciola_games:share";
    [action setObject:object forKey:@"game"];
    
    FBSDKShareOpenGraphContent *content = [[FBSDKShareOpenGraphContent alloc] init];
    content.action = action;
    content.previewPropertyName = @"game";
      
      FBSDKShareDialog *dialog = [FBSDKShareDialog showFromViewController:[info objectForKey:@"viewController"]
      withContent:content
      delegate:[FacebookSharePlugin sharedInstance]];
      */
 
    FBSDKShareLinkContent *content2 = [[FBSDKShareLinkContent alloc] init];
    content2.imageURL = [NSURL URLWithString:[info objectForKey:@"imageURL"]];
    content2.contentURL = [NSURL URLWithString:[info objectForKey:@"contentURL"]];
    content2.contentTitle = [info objectForKey:@"title"];
    content2.contentDescription = [info objectForKey:@"desc"];
    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.shareContent = content2;
//    dialog.delegate = [FacebookSharePlugin sharedInstance];
//    dialog.fromViewController = [info objectForKey:@"viewController"];
//    dialog.mode = FBSDKShareDialogModeShareSheet;
//    [dialog show];
    
    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
    
    [dialog setShareContent:content2];
    [dialog setDelegate:[FacebookSharePlugin sharedInstance]];
    [dialog setFromViewController:[info objectForKey:@"viewController"]];
//    [dialog setMode:FBSDKShareDialogModeShareSheet];
    [dialog show];
    

}
/*
- (void)share:(id)sender
{
    UIActionSheet *shareActionSheet = self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                          delegate:self
                                                                                 cancelButtonTitle:nil
                                                                            destructiveButtonTitle:nil
                                                                                 otherButtonTitles:nil];
    
    if ([MFMailComposeViewController canSendMail]) {
        [shareActionSheet addButtonWithTitle:@"Mail"];
    }
    
    if ([MFMessageComposeViewController canSendAttachments]) {
        [shareActionSheet addButtonWithTitle:@"Message"];
    }
    
    FBSDKShareDialog *facebookShareDialog = [self getShareDialogWithContentURL:[self _currentPhoto].objectURL];
    if ([facebookShareDialog canShow]) {
        [shareActionSheet addButtonWithTitle:@"Share on Facebook"];
    }
    FBSDKMessageDialog *messengerShareDialog = [self getMessageDialogWithContentURL:[self _currentPhoto].objectURL];
    if ( [messengerShareDialog canShow]) {
        [shareActionSheet addButtonWithTitle:@"Send with Messenger"];
    }
    
    [shareActionSheet addButtonWithTitle:@"Cancel"];
    shareActionSheet.cancelButtonIndex = shareActionSheet.numberOfButtons - 1;
    [shareActionSheet showInView:self.view];
}
*/
#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"completed share:%@", results);
    if (self.callback) {
        self.callback(YES, @"success");
        self.callback = nil;
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"There was a problem sharing, please try again later.";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (self.callback) {
        self.callback(NO, [title stringByAppendingString:message]);
        self.callback = nil;
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"share cancelled");
    if (self.callback) {
        self.callback(NO, @"USER CANNCEL");
        self.callback = nil;
    }
}


@end
