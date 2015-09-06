//
//  ViewController.h
//  FGEPluginsDemo
//
//  Created by Loy Liu on 15/7/13.
//  Copyright (c) 2015年 Loy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UITextField *textField;
    IBOutlet UIPickerView *languagePicker;
    IBOutlet UISlider *slider;
    IBOutlet UISlider *speedSlider;
    
    IBOutlet UILabel *label1, *label2;
}


-(IBAction)onDoSth:(id)sender;
-(IBAction)onValueChanged:(id)sender;
@end

