//
//  GCFeatureViewController.m
//  FGEPluginsDemo
//
//  Created by Loy Liu on 15/8/24.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "GCFeatureViewController.h"
#import "GameCenterManager.h"
#import "GameCenterServicePlugin.h"
#import "FacebookSharePlugin.h"
@interface GCFeatureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;

@end

@implementation GCFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.imgeView setImage:];
    NSLog(@"%@", [UIImage imageNamed:@"ui_button_checkout_press"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (!available) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Game Center"
                                  message:@"If Game Center is disabled try logging in through the Game Center app"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:@"Open Game Center", nil];
        [alertView show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}
- (IBAction)doSaveGame:(id)sender {
    id callback = (^(GKSavedGame *savedGame, NSError *error){
        if (!error) {
            [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                NSDictionary *dic = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
                NSLog(@"%@", dic);
            }];
        }else{
            NSLog(@"error: %@", error);
        }
       
        
    });
    NSDictionary *info = @{@"data": @{
                                   @"score":[NSNumber numberWithInteger:1000],
                                   @"test":@"hello"
                                   },
                           @"callback":callback
                           };
    [GameCenterServicePlugin saveGame:info];
}
- (IBAction)doLoadGame:(id)sender {
    NSDictionary *info = @{
                           @"callback":  (^(NSArray *savedGames, NSError *error){
                               if (!error) {
                                   for (GKSavedGame *savedGame in savedGames) {
                                       [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                           [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
                                               NSDictionary *dic = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                               NSLog(@"savedGame: %@", dic);
                                           }];
                                       }];
                                   }
                               }else{
                                   NSLog(@"error: %@", error);
                               }
                               
                               
                           })
                           };
    [GameCenterServicePlugin loadGame:info];
}
- (IBAction)onShare:(id)sender {
    [FacebookSharePlugin fbShare:@{@"image": [UIImage imageNamed:@"ui_button_checkout_press"], @"viewController": self}];
}
@end
