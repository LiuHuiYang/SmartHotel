//
//  SHHomeViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHomeViewController.h"

//每一秒旋转的度数
#define perSecA (6)

//每一分旋转的度数
#define perMinA (6)

//每一小时旋转的度数
#define perHourA (30)

//每一分,时针旋转的度数
#define perMinHour (0.5)

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface SHHomeViewController ()

/// 语言按钮
@property (weak, nonatomic) IBOutlet UIButton *languageButton;

/// 当前最后选中的语言名称
@property (copy, nonatomic) NSString *selectLanguageName;

/// 时钟
@property (weak, nonatomic) IBOutlet UIImageView *clockView;

//// 当前的秒针
@property (nonatomic, weak)   CALayer *secLayer;

/// 当前的分针
@property (nonatomic, weak)   CALayer *minLayer;

/// 当前的时针
@property (nonatomic, weak)   CALayer *hourLayer;

/// 当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

/// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/// 环境温度显示
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;

/// 闹钟时间显示
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;

/// 开关按钮
@property (weak, nonatomic) IBOutlet SHSwitchButton *alarmTimeButton ;

/// DND按钮
@property (weak, nonatomic) IBOutlet SHSwitchButton *dndButton;


@end

@implementation SHHomeViewController

// MARK: -  数据传输


/// 接收到了数据
- (void)analyzeReceiveData:(NSNotification *)notification {
 
    const Byte startIndex = 9;
    
    NSData *data = notification.object;
    
    Byte *recivedData = ((Byte *) [data bytes]);
    
    UInt16 operatorCode = ((recivedData[5] << 8) | recivedData[6]);
   
    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
    
    if (subNetID != self.roomInfo.subNetIDForDDP ||
        deviceID != self.roomInfo.deviceIDForDDP) {
        return ;
    }
    
    switch (operatorCode) {
            
        case 0XE3E8: {
            
            if (!recivedData[startIndex]) { // 返回摄氏温度有效
                return;
            }
            
            // 温度绝对值
            NSInteger temperature = recivedData[startIndex + 1]; // 只要第一个通道
            temperature = (recivedData[startIndex + 8 + 1]) ? (0 - temperature) : temperature;
            
            [self showCurrentTemperature:temperature];
        }
            break;
            
        default:
            break;
    }
}

/// 读取温度
- (void)readTemperature {
    
    Byte readTemperatureFlag[] = { 1 }; // 暂时先读摄氏度
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3E7 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:readTemperatureFlag length:sizeof(readTemperatureFlag)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}


// MARK: - 视图加载 与显示


/// dnd按钮点击
- (IBAction)dndButtonClick {
    
    self.dndButton.on = !self.dndButton.on;
    
    Byte dndServiceData[] = { SHRoomServerTypeDND, self.dndButton.on};
   
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X040A targetSubnetID:
     self.roomInfo.subNetIDForCardHolder targetDeviceID:self.roomInfo.deviceIDForCardHolder additionalContentData:[NSMutableData dataWithBytes:dndServiceData length:sizeof(dndServiceData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

/// 闹钟打开与关闭
- (IBAction)alarmTimeButtonClick {
    
    self.alarmTimeButton.on = !self.alarmTimeButton.on;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHAlarmTimeEnabelNotification object:@(self.alarmTimeButton.on)];
}

/// 设置闹钟是否开启
- (void)setAlalrmTimeEnable:(NSNotification *)notification {
    
    self.alarmTimeButton.on = [notification.object boolValue];
}

/// 显示当前温度
- (void)showCurrentTemperature:(NSInteger)temperature {
    
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%@ %zd °C ( %zd°F )", [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Room T."], temperature, (NSInteger)(temperature * 1.8 + 32)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %zd", [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Room NO"], self.roomInfo.roomNumberDisplay];
    
    /// 读取温度
    [self readTemperature];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlalrmTimeEnable:) name:SHAlarmTimeEnabelNotification object:nil];
    
    
    
    // 当前选择的语言
    self.selectLanguageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAGUAGEZ_NAME"];
    
    [self.languageButton setTitle:self.selectLanguageName forState:UIControlStateNormal];
    
    // 添加时钟动画
    [self addClockLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    [self timeChange];
}

- (void)timeChange {
    
    // 获得当前时间
    NSDateComponents *currentTime = [NSDate getCurrentDateComponents];
    
    // 获得要移动的秒数
    NSUInteger second = currentTime.second + 1; // 下一秒
    self.secLayer.transform = CATransform3DMakeRotation(angle2Rad(second * perSecA), 0, 0, 1);
    
    // 分钟
    NSUInteger minute = currentTime.minute;
    self.minLayer.transform = CATransform3DMakeRotation(angle2Rad(minute * perMinA), 0, 0, 1);
    
    //angle  = 当前多少小时 * 每一小时旋转多少度.
    NSUInteger hour = currentTime.hour;
    self.hourLayer.transform = CATransform3DMakeRotation(angle2Rad(hour * perHourA + minute * perMinHour), 0, 0, 1);
    
    [self updateTimeShow];
}

/// 添加时钟动画
- (void)addClockLayer {
    
    CALayer *hourLayer = [CALayer layer];
    hourLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + statusBarHeight);
    hourLayer.contents = (id)[UIImage imageNamed:@"main_ClockH_iPad"].CGImage;
    hourLayer.anchorPoint = CGPointMake(0.5, 0.64);
    hourLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:hourLayer];
    self.hourLayer = hourLayer;
    
    CALayer *minLayer = [CALayer layer];
    minLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + statusBarHeight);
    minLayer.contents = (id)[UIImage imageNamed:@"main_ClockM_iPad"].CGImage;
    minLayer.anchorPoint =CGPointMake(0.5, 0.64);
    minLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:minLayer];
    self.minLayer = minLayer;
    
    CALayer *secLayer = [CALayer layer];
    secLayer.bounds = CGRectMake(0, 0, 15, navigationBarHeight + navigationBarHeight + tabBarHeight);
    secLayer.contents = (id)[UIImage imageNamed:@"main_ClockS_iPad"].CGImage;
    secLayer.anchorPoint = CGPointMake(0.5, 0.64);
    secLayer.position = CGPointMake(self.clockView.bounds.size.width * 0.5, self.clockView.bounds.size.height * 0.5);
    [self.clockView.layer addSublayer:secLayer];
    self.secLayer = secLayer;
}


/// 更新时间显示
- (void)updateTimeShow {
    
    // 获得当前时间
    NSDateComponents *currentTime = [NSDate getCurrentDateComponents];
    
    // 更新当前时间
    self.currentTimeLabel.text =  [NSString stringWithFormat:@"%02zd:%02zd", currentTime.hour, currentTime.minute];
    
    // 更新日期
    NSString *week = nil;
    switch (currentTime.weekday) {
        case NSDateWeekSunday:
            week = @"Sunday";
            break;
            
        case NSDateWeekMonday:
            week = @"Monday";
            break;
            
        case NSDateWeekTuesday:
            week = @"Tuesday";
            break;
            
        case NSDateWeekWednesday:
            week = @"Wednesday";
            break;
            
        case NSDateWeekThuesday:
            week = @"Thuesday";
            break;
            
        case NSDateWeekFriday:
            week = @"Friday";
            break;
            
        case NSDateWeekSaturday:
            week = @"Saturday";
            break;
            
        default:
            break;
    }
    
    NSString *month = nil;
    
    switch (currentTime.month) {
        
        case NSDateMonthJanuary:
            month = @"January";
            break;
            
        case NSDateMonthFebruary:
            month = @"February";
            break;
            
        case NSDateMonthMarch:
            month = @"March";
            break;
            
        case NSDateMonthApril:
            month = @"April";
            break;
            
        case NSDateMonthMay:
            month = @"May";
            break;
            
        case NSDateMonthJune:
            month = @"June";
            break;
            
        case NSDateMonthJuly:
            month = @"July";
            break;
            
        case NSDateMonthAugust:
            month = @"August";
            break;
            
        case NSDateMonthSeptember:
            month = @"September";
            break;
        case NSDateMonthOctober:
            month = @"October";
            break;
            
        case NSDateMonthNovember:
            month = @"November";
            break;
            
        case NSDateMonthDecember:
            month = @"December";
            break;
            
        default:
            break;
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ %zd, %zd", week, month, currentTime.day, currentTime.year];
}

// MARK: - 语言设置

/// 保存语言设置
- (void)saveLanguageSetting:(NSString *)languageName {
    
    if (languageName.length <= 0 || [self.selectLanguageName isEqualToString:languageName]) {
        return;
    }
    
    self.selectLanguageName = languageName;
    
    [self.languageButton setTitle:self.selectLanguageName forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectLanguageName forKey:@"LAGUAGEZ_NAME"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SHLanguageTools shareSHLanguageTools] setLanguage];
    
    [SVProgressHUD showSuccessWithStatus:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Saved Successed!You should to restart app"]];
}


/// 设置语言
- (IBAction)setLanguage {
    
    TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:nil message:nil isCustom:YES];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"中文" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self saveLanguageSetting:@"中文"];
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"English" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        [self saveLanguageSetting:@"English"];
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    
    alertController.backgoundTapDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
