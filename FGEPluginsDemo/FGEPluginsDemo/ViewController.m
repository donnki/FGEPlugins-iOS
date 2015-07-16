//
//  ViewController.m
//  FGEPluginsDemo
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "ViewController.h"
#import "FGEPlugins.h"

@interface ViewController (){
    NSArray *_products;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _products = @[@"com.banabala.jellyddd.sandyclockdozen",
                           @"com.banabala.jellyddd.sandyclockfew",
                           @"com.banabala.jellyddd.sandyclockmany"];
    
    [AppStoreIAPPlugin requestProuducts:@{@"products":_products}];
    //    [AppStoreIAPPlugin payForProductID:@"Hello test" successCallback:1 failedCallback:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"do something" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onDoSth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)onDoSth:(id)sender{
//    NSLog(@"onBuySth:%@", [_products objectAtIndex:0]);
//    [StatisticPlugin onStatisticEvent:@{
//                                        @"eventId":@"TestEvent",
//                                        @"data":@{@"test":[NSNumber numberWithInt:1]}
//                                        }];
//    [AppStoreIAPPlugin payForProduct:@{
//                                       @"productID":[_products objectAtIndex:0],
//                                       @"successCallback":(^(NSDictionary *param){
//        NSLog(@"sucessCallback: %@", param);
//    })
//                                       }
//     ];
//    [GameCenterServicePlugin showLeaderboards:nil];
    [GameCenterServicePlugin loadLeaderboardScore:@{@"leaderboardID": GAMECENTER_LEADERBOARD_ID}];
//    [GameCenterServicePlugin submitLeaderboardScore:@{@"leaderboardID": GAMECENTER_LEADERBOARD_ID, @"score": [NSNumber numberWithInt:1984]}];
//    [AdmobPlugin showInterstitialAD:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
