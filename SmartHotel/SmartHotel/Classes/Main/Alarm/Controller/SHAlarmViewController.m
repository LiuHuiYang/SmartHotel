//
//  SHAlarmViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHAlarmViewController.h"

@interface SHAlarmViewController ()

/// 当地时间
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;

/// 显示当地时间
@property (weak, nonatomic) IBOutlet UILabel *showCurrentLocalTimeLabel;

/// 醒来时间
@property (weak, nonatomic) IBOutlet UILabel *wakeUpTimeLabel;

/// 设置闹钟
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;

/// 闹钟开启
@property (weak, nonatomic) IBOutlet UILabel *wakeUpActivateLabel;

/// 闹钟开关
@property (weak, nonatomic) IBOutlet SHSwitchButton *alarmEnableButton;

/// 闹钟响铃次数
@property (assign, nonatomic) NSUInteger alarmCount;

@property (weak, nonatomic) NSTimer *timer;



@end

@implementation SHAlarmViewController

- (IBAction)alarmEnableButtonClick {
    
    self.alarmEnableButton.on = !self.alarmEnableButton.on;
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SHAlarmTimeEnabelNotification object:@(self.alarmEnableButton.on)];
}


- (void)showCurrentLocalTime {
    
    // 获得当前时间
    NSDateComponents *currentTime = [NSDate getCurrentDateComponents];
    
    // 更新当前时间
    self.showCurrentLocalTimeLabel.text =  [NSString stringWithFormat:@"%02zd:%02zd", currentTime.hour, currentTime.minute];
    
}

/// 设置闹钟是否开启
- (void)setAlalrmTimeEnable:(NSNotification *)notification {
    
    self.alarmEnableButton.on = [notification.object boolValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlalrmTimeEnable:) name:SHAlarmTimeEnabelNotification object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCurrentLocalTime) userInfo:nil repeats:YES];
    
    [self showCurrentLocalTime];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Alarm"];
    
    self.localTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Current Local Time"];
    
    self.wakeUpTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Wake Up Time"];
    
    self.remainingTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Remaining Time To Wake Up"];
    
    self.wakeUpActivateLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"On Wake Up Activate Wake Up Mode"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
 
@end
