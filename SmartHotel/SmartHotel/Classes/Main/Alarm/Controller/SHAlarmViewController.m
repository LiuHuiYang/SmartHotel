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

/// 日期格式化字符串
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) NSTimer *timer;


// MARK: - 设置闹钟时间部分

/// 中心点的位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewCenterYConstraint;

/// 日期选择器的中心约束

@property (weak, nonatomic) IBOutlet UIView *countView;

@property (weak, nonatomic) IBOutlet UIView *enabelArarmView;

/// 时间选择器
@property (weak, nonatomic) IBOutlet UIView *dateShowView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) SHAlarm *alarm;

@end

@implementation SHAlarmViewController

/// 保存闹钟时间
- (void)saveAlarmTime {
    
    //    self.alarm.alarmNumber = 1;
    self.alarm.alarmSongName = alarmSoundName;
    self.alarm.alarmTime = self.showWakeUpTimeLabel.text;
    self.alarm.alarmIntervalTime = [self.alarmCountLabel.text integerValue];
    
    // 时间存储于沙盒
    [[NSUserDefaults standardUserDefaults] setObject: self.alarm.alarmTime forKey:alarmTimeStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.alarm.alarmIntervalTime forKey:alarmDelayTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 只有启用闹钟才可以发送通知
    if (self.alarmEnableButton.on) {
        
        [self postLocalNoticfition:self.alarm];
    }
}

/// 点击确定
- (IBAction)sureButtonClick {
    
    NSDateComponents *com = [NSDate getCurrentDateComponentsFrom:self.datePickerView.date];
    
    NSString *timeString =  [NSString stringWithFormat:@"%02zd:%02zd", com.hour, com.minute];
    
    self.showWakeUpTimeLabel.text = timeString;
    
    // 保存闹钟时间
    [self saveAlarmTime];
    
    [self cancelButtonClick];
}

/// 点击取消
- (IBAction)cancelButtonClick {
    
    self.baseViewCenterYConstraint.constant = 0;
    self.dateShowView.hidden = YES;
    self.countView.hidden = NO;
    self.enabelArarmView.hidden = NO;
    self.baseViewCenterYConstraint.constant = 0;
}

/// 发送本地通知
- (void)postLocalNoticfition:(SHAlarm *)alarm {
    
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
                                                            forKeys:
                                 @[@"alarmIntervalTime", @"alarmSongName"]];
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoticfition];
}



- (IBAction)setAlarmTime {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (!self.baseViewCenterYConstraint.constant) {
            
            self.baseViewCenterYConstraint.constant = 0 - navigationBarHeight;
            self.dateShowView.hidden = NO;
            self.countView.hidden = YES;
            self.enabelArarmView.hidden = YES;
            
            if (CGAffineTransformEqualToTransform(self.datePickerView.transform, CGAffineTransformIdentity)) {
                self.datePickerView.transform =
                CGAffineTransformMakeScale(1.2, 1.2);
            }
        }
    }];
}



/// 减小响铃次数
- (IBAction)alarmCountDown {
    
    NSInteger count = self.alarmCountLabel.text.integerValue;
    
    --count;
    
    if (count <= 0) {
        count = 0;
    }
    
    self.alarmCountLabel.text = [NSString stringWithFormat:
                                 @"%@", @(count)];
    
    [self saveAlarmTime];
}

/// 增加响令次数
- (IBAction)alarmCountUp {
    
    NSInteger count = self.alarmCountLabel.text.integerValue;
    
    ++count;
    
    self.alarmCountLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    
    [self saveAlarmTime];
}


- (IBAction)alarmEnableButtonClick {
    
    self.alarmEnableButton.on = !self.alarmEnableButton.on;
    
    [[NSUserDefaults standardUserDefaults] setBool:self.alarmEnableButton.on
                                            forKey:alarmClockOnOffKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.alarmEnableButton.on) {
        
        [[SHSoundTools shareSHSoundTools] stopSoundWithName:alarmSoundName];
    }
    
    [self saveAlarmTime];
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
    
    // 闹钟相关
    SHAlarm *alarm = [[SHAlarm alloc] init];
    self.alarm = alarm;
    
    self.alarm.alarmTime = [[NSUserDefaults standardUserDefaults] objectForKey:alarmTimeStringKey];
    
    if (!self.alarm.alarmTime.length) {
        
        self.alarm.alarmTime = @"07:30";
    }
    
    self.showWakeUpTimeLabel.text = self.alarm.alarmTime;
    
    self.alarmCountLabel.text = [NSString stringWithFormat:
                                 @"%@", @([[NSUserDefaults standardUserDefaults] integerForKey:alarmDelayTimeKey])];
    
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
