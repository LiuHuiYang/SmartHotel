//
//  SHVIPViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHVIPViewController.h"
#import "SHServiceButton.h"

@interface SHVIPViewController ()

/// 出租车
@property (weak, nonatomic) IBOutlet SHServiceButton *taxiButton;

/// 我的车
@property (weak, nonatomic) IBOutlet SHServiceButton *myCarButton;

/// 需要修理
@property (weak, nonatomic) IBOutlet SHServiceButton *maintNeededButton;

/// 医生
@property (weak, nonatomic) IBOutlet SHServiceButton *doctorButton;

/// 服务生
@property (weak, nonatomic) IBOutlet SHServiceButton *buttlerButton;

/// 按摩
@property (weak, nonatomic) IBOutlet SHServiceButton *massageButton;

/// 电梯
@property (weak, nonatomic) IBOutlet SHServiceButton *elevtorButton;

/// 稍等
@property (weak, nonatomic) IBOutlet SHServiceButton *pleaseWaitButton;

/// 退房
@property (weak, nonatomic) IBOutlet SHServiceButton *checkoutButton;

/// 行李箱
@property (weak, nonatomic) IBOutlet SHServiceButton *bagesButton;

/// 急救
@property (weak, nonatomic) IBOutlet SHServiceButton *panicButton;

/// 打开了DND
@property (nonatomic, assign) BOOL isDNDOpen;

/// 旧代码一数值，不知道什么意思
@property (nonatomic, assign) NSUInteger waitCount;

/// 等待定时器
@property (weak, nonatomic) NSTimer *waitTimer;

/// 当前的服务
@property (assign, nonatomic) SHRoomServerType currentService;


@end

@implementation SHVIPViewController


/// 接收到了数据
- (void)analyzeReceiveData:(NSNotification *)notification {
    
    const Byte startIndex = 9;
    
    NSData *data = notification.object;
    
    Byte *recivedData = ((Byte *) [data bytes]);
    
    UInt16 operatorCode = ((recivedData[5] << 8) | recivedData[6]);
    
    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
    
    
    if (subNetID != self.roomInfo.subNetIDForCardHolder ||
        deviceID != self.roomInfo.deviceIDForCardHolder) {
        
        return;
    }
    
    switch (operatorCode) {
            
            // 服务反馈
        case 0X043F: {
            
            Byte servcieStatus = recivedData[startIndex];
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"服务状态 : %d", servcieStatus]];
            
        }
            break;
            
        case 0X040B: {
            
            if (recivedData[startIndex + 1]  == 0XF8) {
                
                Byte servcieStatus = recivedData[startIndex];
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"服务状态 : %d", servcieStatus]];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (operatorCode == 0X043F || operatorCode == 0X040B) {
        
        // 设置状态
        //        [self setServiceStatusForButton]
        [SVProgressHUD showSuccessWithStatus:@"准备进行设置状态"];
    }
}

// MARK: - 事件交互

/// 急救
- (IBAction)panicButtonButtonClick {
    
    [self serviceButtonPress:self.panicButton];
}

/// 行李箱
- (IBAction)bagesButtonClick {
    
    [self serviceButtonPress:self.bagesButton];
}

/// 退房
- (IBAction)checkoutButtonClick {
    
    [self serviceButtonPress:self.checkoutButton];
}

/// 稍等
- (IBAction)pleaseWaitButtonClick {
    
    [self serviceButtonPress:self.pleaseWaitButton];
}


/// 电梯
- (IBAction)elevtorButtonClick {
   
    [self serviceButtonPress:self.elevtorButton];
}

/// 按摩
- (IBAction)massageButtonButtonClick {
    
    [self serviceButtonPress:self.massageButton];
}

/// 服务生
- (IBAction)buttlerButtonClick {
    
    [self serviceButtonPress:self.buttlerButton];
}


/// 医生
- (IBAction)doctorButtonClick {
    
    [self serviceButtonPress:self.doctorButton];
}

/// 需要修理
- (IBAction)maintNeededButtonClick {
   
    [self serviceButtonPress:self.maintNeededButton];
}

/// 我的车
- (IBAction)myCarButtonClick {
   
    [self serviceButtonPress:self.myCarButton];
}


/// 出租车
- (IBAction)taxiButtonClick {
    
    [self serviceButtonPress:self.taxiButton];
}

// MARK: - 数据传递

/// 服务按钮按下
- (void)serviceButtonPress:(SHServiceButton *)serverButton {
    
    // 等待
    if (serverButton.serverType == SHRoomServerTypePleaseWait) {
        
        if (serverButton.isSelected) {
            
            [self turnOffPleaseWait];
            
        } else {
            
            // waitFlicke_vip:
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(waitVIP) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes] ;
            
            self.waitTimer = timer;
        }
    
    // 其它情况
    } else {
        
        if (!serverButton.isSelected &&
            (serverButton.serverType == SHRoomServerTypeCheckOut    ||
             serverButton.serverType == SHRoomServerTypeTaxi        ||
             serverButton.serverType == SHRoomServerTypeMyCar       ||
             serverButton.serverType == SHRoomServerTypeDoctor      ||
             serverButton.serverType == SHRoomServerTypePanic)) {
            
                self.currentService = serverButton.serverType;
                
                TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:
                    [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:
                     @"HouseKeepingAndVIP" withSubTitle:@"Are you sure to select this service?"] message:nil isCustom:YES];
                
                [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"NO"] style:TYAlertActionStyleCancel handler:nil]];
                
                [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"YES"] style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                    
                    [self updateServerButtonStatus:serverButton];
                    
                    // 发送DND的指令
                    if (self.isDNDOpen) {
                        
                        Byte dndServiceData[] = { SHRoomServerTypeDND, 0};
                        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X040A targetSubnetID:
                         self.roomInfo.subNetIDForCardHolder targetDeviceID:self.roomInfo.deviceIDForCardHolder additionalContentData:[NSMutableData dataWithBytes:dndServiceData length:sizeof(dndServiceData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
                        
                        self.isDNDOpen = NO;
                    }
                    
                    // 广播服务的状态
                    Byte servicdeData[] = {serverButton.serverType, 1, self.roomInfo.buildID,
                        self.roomInfo.floorID, self.roomInfo.roomNumber
                    };
                    
                    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X044F targetSubnetID:
                     0XFF targetDeviceID:0XFF additionalContentData:[NSMutableData dataWithBytes:servicdeData length:sizeof(servicdeData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
                    
                    self.currentService = -1;
                    
                }]];
                
                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
                
                alertController.backgoundTapDismissEnable = YES;
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;  
        }
        
        if (serverButton.isSelected && (serverButton.serverType == SHRoomServerTypeMaintenance)) {
            
            return;
        }
        
        // 更新状态
        [self updateServerButtonStatus:serverButton];
    }
    
    
    // 发送DND的指令
    if (self.isDNDOpen) {
        
        Byte dndServiceData[] = { SHRoomServerTypeDND, 0};
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X040A targetSubnetID:
         self.roomInfo.subNetIDForCardHolder targetDeviceID:self.roomInfo.deviceIDForCardHolder additionalContentData:[NSMutableData dataWithBytes:dndServiceData length:sizeof(dndServiceData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
        
        self.isDNDOpen = NO;
    }
    
    // 广播服务的状态
    Byte servicdeData[] = {serverButton.serverType, serverButton.isSelected, self.roomInfo.buildID,
        self.roomInfo.floorID, self.roomInfo.roomNumber
    };
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X044F targetSubnetID:
     0XFF targetDeviceID:0XFF additionalContentData:[NSMutableData dataWithBytes:servicdeData length:sizeof(servicdeData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}


/// 更新按钮的状态
- (void)updateServerButtonStatus:(SHServiceButton *)serviceButton {
    
    serviceButton.selected = !serviceButton.isSelected;
}

/// 等待
- (void)waitVIP {
    
    ++self.waitCount;
    
    if (self.waitCount >= 39) {
        
        // ....
        self.pleaseWaitButton.selected = NO;
        self.waitCount = 0;
        
        [self.waitTimer invalidate];
        self.waitTimer = nil;
        
        return;   
    }

    self.pleaseWaitButton.selected = YES;
}

/// 关闭等待
- (void)turnOffPleaseWait {
    
    self.waitCount = 40; // 不知道为什么要设置为 40
}

// MARK: - UI初始化

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 读取门铃状态
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X043E targetSubnetID:self.roomInfo.subNetIDForDoorBell targetDeviceID:self.roomInfo.deviceIDForDoorBell additionalContentData:nil remoteMacAddress:[SHUdpSocket getLocalSendDataWifi] needReSend:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDNDOpen = NO;
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"VIP"];
    
    // 设置服务类型
    self.taxiButton.serverType = SHRoomServerTypeTaxi;
    self.myCarButton.serverType = SHRoomServerTypeMyCar;
    self.maintNeededButton.serverType = SHRoomServerTypeMaintenance;
    self.doctorButton.serverType = SHRoomServerTypeDoctor;
    self.buttlerButton.serverType = SHRoomServerTypeButtler;
    self.massageButton.serverType = SHRoomServerTypeMassage;
    self.elevtorButton.serverType = SHRoomServerTypeElevrtor;
    self.pleaseWaitButton.serverType = SHRoomServerTypePleaseWait;
    self.checkoutButton.serverType = SHRoomServerTypeCheckOut;
    self.bagesButton.serverType = SHRoomServerTypeBags;
    self.panicButton.serverType = SHRoomServerTypePanic;
    
    // 文字适配
    [self.taxiButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Taxi"] forState:UIControlStateNormal];
    
    [self.myCarButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"My Car"] forState:UIControlStateNormal];
    
    [self.maintNeededButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Maint. Needed"] forState:UIControlStateNormal];
    
    [self.doctorButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Doctor"] forState:UIControlStateNormal];
    
    [self.buttlerButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Buttler"] forState:UIControlStateNormal];
    
    [self.massageButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Massage"] forState:UIControlStateNormal];
    
    [self.elevtorButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Elevetor"] forState:UIControlStateNormal];
    
    [self.pleaseWaitButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"PleaseWait"] forState:UIControlStateNormal];
    
    [self.checkoutButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Check Out"] forState:UIControlStateNormal];
    
    [self.bagesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Bages"] forState:UIControlStateNormal];
    
    [self.panicButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Panic"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.waitTimer invalidate];
    self.waitTimer = nil;
}

@end
