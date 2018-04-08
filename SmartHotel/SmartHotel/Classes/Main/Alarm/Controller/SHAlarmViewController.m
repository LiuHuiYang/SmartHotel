//
//  SHAlarmViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHAlarmViewController.h"

@interface SHAlarmViewController ()

@end

@implementation SHAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Alarm"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
