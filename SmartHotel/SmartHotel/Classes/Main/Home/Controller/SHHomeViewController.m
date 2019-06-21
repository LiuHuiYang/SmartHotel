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
    
    UInt16 operatorCode =
        ((recivedData[5] << 8) | recivedData[6]);
   
    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
    
    switch (operatorCode) {
        
            /*
        case 0x040A: {
            
            if ((data.length == (startIndex + 5)) &&
                ((subNetID == self.roomInfo.doorBellSubNetID &&
                 deviceID == self.roomInfo.doorBellDeviceID)  ||
                (subNetID == self.roomInfo.cardHolderSubNetID &&
                 deviceID == self.roomInfo.cardHolderDeviceID) ||
                (subNetID == self.roomInfo.bedSideSubNetID &&
                 deviceID == self.roomInfo.bedSideDeviceID)
                )) {
                
                // 判断是否为NDN状态
                BOOL isDND =
                recivedData[startIndex + 0] ==
                SHRoomServerTypeDND;
                 
                if (isDND) {
                    
                    [self.dndButton setOn:
                     (recivedData[startIndex + 1] != 0)
                    ];
                }
            }
        }
            break;
             
             */
            
        // 接收到读取状态返回
        case 0x043F:
        // 接收到服务广播
        case 0x044F: {
            
            // 房间信息
            if (data.length == (startIndex + 4) &&
                self.roomInfo.buildingNumber == recivedData[startIndex + 1] &&
                self.roomInfo.floorNumber ==
                recivedData[startIndex + 2] &&
                self.roomInfo.roomNumber ==
                recivedData[startIndex + 3]) {
                
                // 不需要判断是谁发出来的
                
                // 判断是否为NDN状态
                BOOL isDND =
                recivedData[startIndex + 0] ==
                SHRoomServerTypeDND;
                
                [self.dndButton setOn:isDND];
            }
        }
            break;
            
            
            // 温度
        case 0xE3E8: {
            
            if (subNetID != self.roomInfo.temperatureSubNetID ||
                deviceID != self.roomInfo.temperatureDeviceID) {
                return;
            }
            
            if (!recivedData[startIndex]) { // 返回摄氏温度有效
                return;
            }
            
            // 温度绝对值
            NSUInteger valueIndex =
            startIndex +
            self.roomInfo.temperatureChannelNo;
            
            NSInteger temperature = recivedData[valueIndex]; // 只要第一个通道
            temperature =
            (recivedData[valueIndex + 8]) ?
            (0 - temperature) : temperature;
            
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
    
    if (self.roomInfo.temperatureChannelNo == 0) {
        self.roomInfo.temperatureChannelNo = 1;
    }
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE3E7 targetSubnetID:self.roomInfo.temperatureSubNetID targetDeviceID:self.roomInfo.temperatureDeviceID additionalContentData:[NSMutableData dataWithBytes:readTemperatureFlag length:sizeof(readTemperatureFlag)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}


// MARK: - 视图加载 与显示

/// 读取状态
- (void)readDNDStatus {
    
    // 通过CardHolder读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
    
    // 通过DoorBell读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}

/// dnd按钮点击
- (IBAction)dndButtonClick {
    
    self.dndButton.on = !self.dndButton.on;
    
    Byte dndServiceData[] = {
        SHRoomServerTypeDND,
        self.dndButton.on,
        self.roomInfo.buildingNumber,
        self.roomInfo.floorNumber,
        self.roomInfo.roomNumber
    };
    
    // CardHolder
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x040A targetSubnetID:
     self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:[NSMutableData dataWithBytes:dndServiceData length:sizeof(dndServiceData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    // doorBell
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x040A targetSubnetID:
     self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:[NSMutableData dataWithBytes:dndServiceData length:sizeof(dndServiceData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

/// 闹钟打开与关闭
- (IBAction)alarmTimeButtonClick {
    
    self.alarmTimeButton.on = !self.alarmTimeButton.on;
  
    [[NSUserDefaults standardUserDefaults] setBool:self.alarmTimeButton.on forKey:alarmClockOnOffKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!self.alarmTimeButton.on) {
        
        [[SHSoundTools shareSHSoundTools] stopSoundWithName:alarmSoundName];
    }
}

/// 显示当前温度
- (void)showCurrentTemperature:(NSInteger)temperature {
    
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%@ %zd °C ( %zd°F )", [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Room T."], temperature, (NSInteger)(temperature * 1.8 + 32)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    printLog(@"当前房间信息: %zd - %zd;",
             self.roomInfo.doorBellSubNetID,
             self.roomInfo.doorBellDeviceID);
    
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %zd", [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"Room NO"], self.roomInfo.roomNumber];
    
    self.alarmTimeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:alarmTimeStringKey];
    
    [self.alarmTimeButton setOn:[[NSUserDefaults standardUserDefaults] boolForKey:alarmClockOnOffKey]];
    
    if (!self.alarmTimeLabel.text.length) {
        [self.alarmTimeButton setOn:NO];
    }
    
    // 读取温度
    [self readTemperature];
    
    // 读取DND状态
    [self readDNDStatus];
}


- (void)viewDidLoad {
    [super viewDidLoad];
     
    // 当前选择的语言
    self.selectLanguageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAGUAGEZ_NAME"];
    
    [self.languageButton setTitle:self.selectLanguageName forState:UIControlStateNormal];
    
    // 添加时钟动画
    [self addClockLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    [self timeChange];
}

// MARK: - 中间表盘的处理

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
