//
//  SHAlarmViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

/*

 1.全局的闹钟
 2.获得最初的时间，没有默认07:30
 3.时间选择器中时间的保存
 4.按钮的处理

 */

#import "SHAlarmViewController.h"

@interface SHAlarmViewController ()

/// 当地时间
@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;

/// 显示当地时间
@property (weak, nonatomic) IBOutlet UILabel *showCurrentLocalTimeLabel;

/// 醒来时间
@property (weak, nonatomic) IBOutlet UILabel *wakeUpTimeLabel;

/// 显示设定闹钟时间
@property (weak, nonatomic) IBOutlet UILabel *showWakeUpTimeLabel;


/// 设置闹钟
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;

/// 闹钟开启
@property (weak, nonatomic) IBOutlet UILabel *wakeUpActivateLabel;

/// 闹钟开关
@property (weak, nonatomic) IBOutlet SHSwitchButton *alarmEnableButton;

/// 闹钟响铃次数的标签
@property (weak, nonatomic) IBOutlet UILabel *alarmCountLabel;

/// 闹钟响铃次数
@property (assign, nonatomic) NSUInteger alarmCount;

/// 日期格式化字符串
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) NSTimer *timer;


// MARK: - 设置闹钟时间部分

/// 中心点的位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewCenterYConstraint;

/// 时间选择器
@property (weak, nonatomic) IBOutlet UIView *dateShowView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) SHAlarm *alarm;

@end

@implementation SHAlarmViewController


/// 点击确定
- (IBAction)sureButtonClick {
    
    NSDateComponents *com = [NSDate getCurrentDateComponentsFrom:self.datePickerView.date];
    
    NSString *timeString =  [NSString stringWithFormat:@"%02zd:%02zd", com.hour, com.minute];
    
    self.showWakeUpTimeLabel.text = timeString;
    
//    self.alarm.alarmNumber = 1;
    self.alarm.alarmSongName = alarmSoundName;
    self.alarm.alarmTime = timeString;
    self.alarm.alarmIntervalTime = self.alarmCount;
    
    // 时间存储于沙盒
    [[NSUserDefaults standardUserDefaults] setObject: self.alarm.alarmTime forKey:alarmTimeStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 只有启用闹钟才可以发送通知
    if (self.alarmEnableButton.on) {
        
        [self postLocalNoticfition:self.alarm];
    }
    
    self.baseViewCenterYConstraint.constant = 0;
    self.dateShowView.hidden = YES;
}

/// 点击取消
- (IBAction)cancelButtonClick {
    
    self.baseViewCenterYConstraint.constant = 0;
    self.dateShowView.hidden = YES;
}





/// 发送本地通知
- (void)postLocalNoticfition:(SHAlarm *)alarm {
    
    // 测试一下本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    UILocalNotification *localNoticfition = [[UILocalNotification alloc] init];
    
    localNoticfition.alertBody = [NSString stringWithFormat:@"Alarm %@", alarm.alarmTime];
    localNoticfition.alertAction = @"Allow";
    localNoticfition.soundName = UILocalNotificationDefaultSoundName;
//    localNoticfition.repeatInterval = NSCalendarUnitDay;
    
    NSDateComponents *components = [NSDate getCurrentDateComponents];
    
    NSInteger hour = [[[alarm.alarmTime componentsSeparatedByString:@":"]
                       firstObject] integerValue];
    NSInteger min = [[[alarm.alarmTime componentsSeparatedByString:@":"]
                      lastObject] integerValue];
    
    [components setSecond:0];
    [components setMinute:min];
    [components setHour:hour];
    
    localNoticfition.fireDate = [[NSCalendar currentCalendar]
                                 dateFromComponents:components];
    
    localNoticfition.userInfo = [NSDictionary dictionaryWithObjects:
                                 @[@(alarm.alarmIntervalTime),
                                   alarm.alarmSongName]
                                forKeys:@[@"alarmIntervalTime", @"alarmSongName"]];
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoticfition];
}

 

- (IBAction)setAlarmTime {
    
    
    [UIView animateWithDuration:0.3 animations:^{
    
        if (!self.baseViewCenterYConstraint.constant) {
            
            
            self.baseViewCenterYConstraint.constant = -44;
            self.dateShowView.hidden = NO;
            
        } else  {
            
             self.dateShowView.hidden = YES;
            self.baseViewCenterYConstraint.constant = 0;
        }
        
    }];
   
    
 
//    CGFloat scale = 1.6;
//    CGFloat moveMarign = 216 * scale;
//    if (CGAffineTransformEqualToTransform(self.datePicker.transform, CGAffineTransformIdentity)) {
//        self.datePicker.transform = CGAffineTransformMakeScale(scale, scale);
//    }
}



/// 减小响铃次数
- (IBAction)alarmCountDown {

    NSInteger count = self.alarmCountLabel.text.integerValue;
    
    --count;
    
    if (count <= 0) {
        count = 0;
    }
    
    self.alarmCount = count;
    
    self.alarmCountLabel.text = [NSString stringWithFormat:@"%@", @(self.alarmCount)];
}

/// 增加响令次数
- (IBAction)alarmCountUp {
    
    NSInteger count = self.alarmCountLabel.text.integerValue;
    
    ++count;
   
    self.alarmCount = count;
    
    self.alarmCountLabel.text = [NSString stringWithFormat:@"%@", @(self.alarmCount)];
}


- (IBAction)alarmEnableButtonClick {
    
    self.alarmEnableButton.on = !self.alarmEnableButton.on;
    
    [[NSUserDefaults standardUserDefaults] setBool:self.alarmEnableButton.on
                                                forKey:alarmClockOnOffKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.alarmEnableButton.on) {
        
        [[SHSoundTools shareSHSoundTools] stopSoundWithName:alarmSoundName];
    }
}


- (void)showCurrentLocalTime {
   
    NSDateComponents *currentTime = [NSDate getCurrentDateComponents];
    
    self.showCurrentLocalTimeLabel.text =  [NSString stringWithFormat:@"%02zd:%02zd", currentTime.hour, currentTime.minute];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.alarmEnableButton setOn:[[NSUserDefaults standardUserDefaults] boolForKey:alarmClockOnOffKey]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.sureButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"OK"]
                     forState:UIControlStateNormal] ;
    
    [self.cancelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Cancel"]
                     forState:UIControlStateNormal] ;
    
    [self.datePickerView setValue:[UIColor colorWithWhite:215/255.0 alpha:1.0] forKey:@"textColor"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showCurrentLocalTime) userInfo:nil repeats:YES];
    
    [self showCurrentLocalTime];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Alarm"];
    
    self.localTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Current Local Time"];
    
    self.wakeUpTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Wake Up Time"];
    
    self.remainingTimeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"Remaining Time To Wake Up"];
    
    self.wakeUpActivateLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"ALARM" withSubTitle:@"On Wake Up Activate Wake Up Mode"];
    
    SHAlarm *alarm = [[SHAlarm alloc] init];
    self.alarm = alarm;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:MM";
    }
    return _dateFormatter;
}

- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
 
@end
