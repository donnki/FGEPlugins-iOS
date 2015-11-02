//
//  ViewController.m
//  FGEPluginsDemo
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import "ViewController.h"
#import "FGEPlugins.h"
#import <AVFoundation/AVFoundation.h>
static AVSpeechSynthesizer *synthesizer;
@interface ViewController (){
    NSArray *_products;
    NSInteger selectedIndex;
}

@end

@implementation ViewController
- (IBAction)onGTMFireEvent:(id)sender {
    [[TagManagerPlugin sharedInstance] pushEvent:@"home_clk_setting"];
}

- (IBAction)onGTMRefresh:(id)sender {
    [TagManagerPlugin refresh];
}

-(void)onContainerRefreshed:(NSNotification*)nofiy{
    NSDictionary* dic = [nofiy object];
    NSLog(@"%@", dic);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContainerRefreshed:) name:GTM_CONTAINER_REFRESHED object:nil];
    [[TagManagerPlugin sharedInstance] doInit:@[@"description", @"button_word", @"gift_type", @"expire_date", @"LuckPlayers"]];
    _products = @[@"com.banabala.jellyddd.sandyclockdozen",
                           @"com.banabala.jellyddd.sandyclockfew",
                           @"com.banabala.jellyddd.sandyclockmany"];
    
//    [AppStoreIAPPlugin requestProuducts:@{@"products":_products}];
//    [AppStoreIAPPlugin payForProductID:@"Hello test" successCallback:1 failedCallback:1];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setFrame:CGRectMake(100, 100, 100, 100)];
//    [button setTitle:@"do something" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(onDoSth:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
//    synthesizer = [[AVSpeechSynthesizer alloc] init];
//    
//    int t = 0;
//    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
//        if([voice.language isEqualToString:@"en-US"]){
//            selectedIndex = t;
//            break;
//        }
//        t++;
//    }

//     [languagePicker selectRow:selectedIndex inComponent:0 animated:YES];
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView)]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(onDoSth:)];
}

-(void)onClickView{
    [textField resignFirstResponder];
}
-(void)onValueChanged:(id)sender{
    if (sender == slider) {
        [label1 setText:[NSString stringWithFormat:@"%.2f", slider.value]];
    }else{
        [label2 setText:[NSString stringWithFormat:@"%.2f", speedSlider.value]];
    }
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
//    [GameCenterServicePlugin loadLeaderboardScore:@{@"leaderboardID": GAMECENTER_LEADERBOARD_ID}];
//    [GameCenterServicePlugin submitLeaderboardScore:@{@"leaderboardID": GAMECENTER_LEADERBOARD_ID, @"score": [NSNumber numberWithInt:1984]}];
//    [AdmobPlugin showInterstitialAD:nil];
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"yo, yo, score"];
    //    [utterance setRate:1.1f];
    //    [synthesizer speakUtterance:utterance];
//    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices]) {
//        NSLog(@"%@", voice.language);
//    }

    
    NSString* title = [[[AVSpeechSynthesisVoice speechVoices] objectAtIndex:selectedIndex] language];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:textField.text];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:title];
    
    // all these values are optional
    utterance.rate = speedSlider.value;
    utterance.pitchMultiplier = slider.value;
    utterance.voice = voice;
    
    [synthesizer speakUtterance:utterance];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[AVSpeechSynthesisVoice speechVoices] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [[[AVSpeechSynthesisVoice speechVoices] objectAtIndex:row] language];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
