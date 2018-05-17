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


/// 闹钟响铃次数的标签
@property (weak, nonatomic) IBOutlet UILabel *alarmCountLabel;

/// 闹钟响铃次数
@property (assign, nonatomic) NSUInteger alarmCount;

/// 设置时间的占位图
@property (weak, nonatomic) IBOutlet UIView *setDateView;

/// 时间选择器
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/// 日期格式化字符串
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/// 基准约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewCenterYConstraint;

@property (weak, nonatomic) NSTimer *timer;


@end

@implementation SHAlarmViewController


- (IBAction)test:(id)sender {
    
    [self postLocalNoticfition];
}


/// 发送本地通知
- (void)postLocalNoticfition {
    
    // 测试一下本地通知
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    SHAlarm *alarm = [[SHAlarm alloc] init];
    alarm.alarmNumber = 1;
    alarm.alarmSongName = @"schedulesound.wav";
    alarm.alarmTime = @"09:25";
    alarm.alarmIntervalTime = self.alarmCount;
    
    // 准备通知
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
                                                            forKeys:@[@"alarmIntervalTime",
                                                                      @"alarmSongName"]];
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoticfition];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    printLog(@"所有的本地通知: %@", localNotifications);
}

/// 取消
- (IBAction)cancelButtonClick {
    
    self.baseViewCenterYConstraint.constant = 0;
}

/// 确定按钮
- (IBAction)sureButtonClick {
    
    [self cancelButtonClick];
}


/// 时间修改
- (IBAction)dateChange {
    
    printLog(@"时间修改");
}


- (IBAction)setAlarmTime {
    
    self.setDateView.hidden = NO;
    
    self.baseViewCenterYConstraint.constant -= self.setDateView.frame_height;
    
//    CGFloat scale = 1.6;
//    CGFloat moveMarign = 216 * scale;
//
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
    
    self.setDateView.hidden = YES;
    self.datePicker.backgroundColor = [UIColor redColor];
    
    [self.datePicker setValue:[UIColor colorWithWhite:215/255.0 alpha:1.0] forKey:@"textColor"];
    
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
