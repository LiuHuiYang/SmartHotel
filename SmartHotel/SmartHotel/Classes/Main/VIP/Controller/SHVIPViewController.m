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

/// 按钮列表
@property (weak, nonatomic) IBOutlet UIView *buttonsView;


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
@property (nonatomic, assign) BOOL isDND;

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
    
    UInt16 operatorCode =
    ((recivedData[5] << 8) | recivedData[6]);
    
   
     if (operatorCode == 0x043F ||
         operatorCode == 0x044F) {
        
        // 房间信息
        if (data.length == (startIndex + 4) &&
            self.roomInfo.buildingNumber == recivedData[startIndex + 1] &&
            self.roomInfo.floorNumber ==
            recivedData[startIndex + 2] &&
            self.roomInfo.roomNumber ==
            recivedData[startIndex + 3]) {
            
            self.isDND =
            recivedData[startIndex + 0] ==
                SHRoomServerTypeDND;
            
            printLog(@"这是固件发出的");
            
            if (self.isDND) {
                
                // 开启DND取消所有已开通的服务
                for (SHServiceButton *serviceButton in self.buttonsView.subviews) {
                    
                    if (serviceButton.isSelected) {
                        
                        serviceButton.selected = NO;
                        
                        [self sendServiceRequest:serviceButton];
                    }
                }
            }
        
        } else if (data.length == (startIndex + 5)) {
            
            printLog(@"计算机发出来的");
        }
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
- (void)serviceButtonPress:(SHServiceButton *)serviceButton {
    
    // 等待
    if (serviceButton.serverType == SHRoomServerTypePleaseWait) {
        
        if (serviceButton.isSelected) {
            
            [self turnOffPleaseWait];
            
        } else {
            
            if (self.waitCount != 0) {
                return;
            }
            
            // waitFlicke_vip:
            NSTimer *timer =
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitVIP) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes] ;
            
            self.waitTimer = timer;
        }
        
        // 其它情况
    } else {
        
        if (!serviceButton.isSelected &&
            (serviceButton.serverType == SHRoomServerTypeCheckOut     ||
             serviceButton.serverType == SHRoomServerTypeTaxi        ||
             serviceButton.serverType == SHRoomServerTypeMyCar       ||
             serviceButton.serverType == SHRoomServerTypeDoctor      ||
             serviceButton.serverType == SHRoomServerTypePanic)) {
                
                self.currentService = serviceButton.serverType;
                
                TYCustomAlertView *alertView = [TYCustomAlertView alertViewWithTitle:
                                                [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:
                                                 @"HouseKeepingAndVIP" withSubTitle:@"Are you sure to select this service?"] message:nil isCustom:YES];
                
                [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"NO"] style:TYAlertActionStyleCancel handler:nil]];
                
                [alertView addAction: [TYAlertAction actionWithTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"YES"] style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                    
                    serviceButton.selected = !serviceButton.isSelected;
                    
                    [self sendServiceRequest:serviceButton];
                    
                    self.currentService = -1;
                    
                }]];
                
                TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
                
                alertController.backgoundTapDismissEnable = YES;
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
        
        // FIXME: - 暂不清楚为什么修理不能取消
//        if (serviceButton.isSelected && (serviceButton.serverType == SHRoomServerTypeMaintenance)) {
//
//
//            // return;
//        }
        
        // 更新状态
        serviceButton.selected = !serviceButton.isSelected;
    }
    
    
    [self sendServiceRequest:serviceButton];
}

/// 发送服务请求
- (void)sendServiceRequest:(SHServiceButton *)serviceButton {
    
    // 关闭DND
    [self turnOffDND];
    
    // 广播服务的状态
    Byte servicdeData[] = {
        serviceButton.serverType,
        serviceButton.isSelected,
        self.roomInfo.buildingNumber,
        self.roomInfo.floorNumber,
        self.roomInfo.roomNumber
    };
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x044F targetSubnetID:0xFF targetDeviceID:0xFF additionalContentData:[NSMutableData dataWithBytes:servicdeData length:sizeof(servicdeData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

/// 关闭DND服务
- (void)turnOffDND {
    
    if (self.isDND == NO) {
        return;
    }
    
    Byte dndServiceData[] = {
        SHRoomServerTypeDND,
        0,
        self.roomInfo.buildingNumber,
        self.roomInfo.floorNumber,
        self.roomInfo.roomNumber
    };
    
    NSMutableData *data =
        [NSMutableData dataWithBytes:dndServiceData
                              length:sizeof(dndServiceData)
        ];
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x040A targetSubnetID:
     self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:data remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x040A targetSubnetID:
     self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:data remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    self.isDND = NO;
}



/// 等待
- (void)waitVIP {
    
    ++self.waitCount;
    
    // 等20s
    if (self.waitCount >= 20) {
        
        [self turnOffPleaseWait];
        
        return;
    }
    
    self.pleaseWaitButton.selected = !self.pleaseWaitButton.selected;
}

/// 关闭等待
- (void)turnOffPleaseWait {
    
    self.pleaseWaitButton.selected = NO;
    self.waitCount = 0;
    
    [self.waitTimer invalidate];
    self.waitTimer = nil;
}

/// 读取服务状态
- (void)readServiceStatus {
    
    // 通过CardHolder读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    // 通过DoorBell读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

// MARK: - UI初始化

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self readServiceStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isDND = YES;
    
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
