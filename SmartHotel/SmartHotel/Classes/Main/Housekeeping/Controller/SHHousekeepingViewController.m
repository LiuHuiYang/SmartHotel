//
//  SHHousekeepingViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHousekeepingViewController.h"
#import "SHServiceButton.h"

@interface SHHousekeepingViewController ()

/// 服务按钮视图
@property (weak, nonatomic) IBOutlet UIView *serviceButtonView;

/// 洗衣服
@property (weak, nonatomic) IBOutlet SHServiceButton *laudryButton;

/// 擦鞋
@property (weak, nonatomic) IBOutlet SHServiceButton *cleanShoesButton;

/// 收拾餐具
@property (weak, nonatomic) IBOutlet SHServiceButton *takePlatesButton;

/// 请勿打扰
@property (weak, nonatomic) IBOutlet SHServiceButton *dndButton;

/// 毛巾 浴巾
@property (weak, nonatomic) IBOutlet SHServiceButton *towelsRobeButton;

/// 红酒
@property (weak, nonatomic) IBOutlet SHServiceButton *refillMiniBarButton;

/// 枕头 毛毯
@property (weak, nonatomic) IBOutlet SHServiceButton *pillowBlanketButton;

/// 冰激凌
@property (weak, nonatomic) IBOutlet SHServiceButton *iceButton;

/// 打扫
@property (weak, nonatomic) IBOutlet SHServiceButton *cleanButton;

/// 铺床
@property (weak, nonatomic) IBOutlet SHServiceButton *readyBedButton;

/// 早餐
@property (weak, nonatomic) IBOutlet SHServiceButton *breakfastButton;

@end

@implementation SHHousekeepingViewController

// MARK: - 广播解析

/// 接收到了数据
- (void)analyzeReceiveData:(NSNotification *)notification {
    
    const Byte startIndex = 9;

    NSData *data = notification.object;

    Byte *recivedData = ((Byte *) [data bytes]);

    UInt16 operatorCode = ((recivedData[5] << 8) | recivedData[6]);

    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
  
    switch (operatorCode) {
        
            // 接收到读取状态返回
        case 0x043F:
            
            // 接收到服务广播
        case 0x044F: {
            
            // 房间信息
            if (self.roomInfo.buildingNumber == recivedData[startIndex + 1] &&
                self.roomInfo.floorNumber ==
                recivedData[startIndex + 2] &&
                self.roomInfo.roomNumber ==
                recivedData[startIndex + 3]) {
                
                SHRoomServerType service = recivedData[startIndex + 0];
                
                [self setServiceStatusForButton:service];
            }
        }
            
        case 0x040B: {
            
            if (recivedData[startIndex + 1]  == 0xF8) {
                
                Byte servcieStatus = recivedData[startIndex];
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"服务状态 : %d", servcieStatus]];
            }
        }
            break;

        default:
            break;
    }
    
    
    // 0x040B // 发控制相同的
}


// MARK: - 事件交互

/// 早餐
- (IBAction)breakfastButtonClick {
    
    [self serviceButtonPress:self.breakfastButton];
}

/// 铺床
- (IBAction)readyBedButtonClick {
    
    [self serviceButtonPress:self.readyBedButton];
}

/// 打扫
- (IBAction)cleanButtonClick {
    
    [self serviceButtonPress:self.cleanButton];
}

/// 冰激凌
- (IBAction)iceButtonClick {
    
    [self serviceButtonPress:self.iceButton];
}


/// 毛巾 浴巾
- (IBAction)towelsRobeButtonClick {
    
    [self serviceButtonPress:self.towelsRobeButton];
}

/// 红酒
- (IBAction)refillMiniBarButtonClick {
    
    [self serviceButtonPress:self.refillMiniBarButton];
}

/// 枕头 毛毯
- (IBAction)pillowBlanketButtonClick {
    
    [self serviceButtonPress:self.pillowBlanketButton];
}


/// 请勿打扰
- (IBAction)dndButtonClick {
    
    [self serviceButtonPress:self.dndButton];
}

/// 收拾餐具
- (IBAction)takePlatesButtonClick {
   
    [self serviceButtonPress:self.takePlatesButton];
}

/// 擦鞋
- (IBAction)cleanShoesButtonClick {
   
    [self serviceButtonPress:self.cleanShoesButton];
}

/// 洗衣服
- (IBAction)laudryButtonClick {
 
    [self serviceButtonPress:self.laudryButton];
}

/// 服务按钮按下
- (void)serviceButtonPress:(SHServiceButton *)serverButton {
    
    // 如果当前是打扰模式
    if (serverButton.serverType == SHRoomServerTypeDND) {
        
        for (SHServiceButton *button in self.serviceButtonView.subviews) {
            
            if (button != self.dndButton && button.selected) {
                
                button.selected = NO;
            }
        }
    
    } else {  // 非打扰模式下
        
        // 打扫 && 洗衣服关闭打扰模式
        [self turnOffDNDService: (serverButton.serverType == SHRoomServerTypeClean || serverButton.serverType == SHRoomServerTypeLaudry )];
    }
    
    // 更新当前按钮的状态
    serverButton.selected = !serverButton.selected;
    
    // 普通服务指令
    if (serverButton.serverType == SHRoomServerTypeLaudry ||
        
        serverButton.serverType == SHRoomServerTypeClean  ||
        
        serverButton.serverType == SHRoomServerTypeDND) {
        
        Byte data[] = {
            serverButton.serverType,
            serverButton.selected,
            self.roomInfo.buildingNumber,
            self.roomInfo.floorNumber,
            self.roomInfo.roomNumber
        };
        
        // 通过CardHolder发送
        [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x040A targetSubnetID:self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:[NSMutableData dataWithBytes:data length:sizeof(data)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
        
        // 通过DoorBell发送
        [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x040A targetSubnetID:self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:[NSMutableData dataWithBytes:data length:sizeof(data)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    // 其它服务发送给计算机 (主动报告状态)
    } else {
    
        Byte data[5] = {serverButton.serverType, serverButton.selected, self.roomInfo.buildingNumber, self.roomInfo.floorNumber, self.roomInfo.roomNumber};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x044F targetSubnetID:0xFF targetDeviceID:0xFF additionalContentData:[NSMutableData dataWithBytes:data length:sizeof(data)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    }
    
}

/// 关闭DND模式
- (void)turnOffDNDService:(BOOL)off {
    
    // 关闭
    if (self.dndButton.selected) {
        self.dndButton.selected = NO;
    }
    
    // 关闭DND服务
    if (off) {
    
        Byte data[2] = {SHRoomServerTypeDND, 0};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x040A targetSubnetID:self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:[NSMutableData dataWithBytes:data length:sizeof(data)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
    }
}



/// 设置服务按钮
- (void)setServiceStatusForButton:(SHRoomServerType)service {
    
    for (SHServiceButton *button in self.serviceButtonView.subviews) {
        
        button.selected = NO;
    }
    
    switch (service) {
            
        case SHRoomServerTypeClean: {
            self.cleanButton.selected = YES;
        }
            break;
            
        case SHRoomServerTypeDND: {  // DND
            self.dndButton.selected = YES;
        }
            break;
            
        case SHRoomServerTypeLaudry: {
            self.laudryButton.selected = YES;
        }
            break;
            
        case SHRoomServerTypeCleanLaundry: {
        
            self.cleanButton.selected = YES;
            self.laudryButton.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

/// 读取服务状态
- (void)readServiceStatus {
    
    // 通过CardHolder读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.cardHolderSubNetID targetDeviceID:self.roomInfo.cardHolderDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    // 通过DoorBell读取
    [SHUdpSocket.shareSHUdpSocket sendDataWithOperatorCode:0x043E targetSubnetID:self.roomInfo.doorBellSubNetID targetDeviceID:self.roomInfo.doorBellDeviceID additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

// MARK: - 视图初始化

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self readServiceStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"HouseKeeping"];
    
    // 设置服务类型
    self.laudryButton.serverType = SHRoomServerTypeLaudry;
    self.cleanShoesButton.serverType = SHRoomServerTypeCleanShoes;
    self.takePlatesButton.serverType = SHRoomServerTypeTakePlates;
    self.dndButton.serverType = SHRoomServerTypeDND;
    self.towelsRobeButton.serverType = SHRoomServerTypeTowels;
    self.refillMiniBarButton.serverType = SHRoomServerTypeRefillMiniBar;
    self.pillowBlanketButton.serverType = SHRoomServerTypePillow;
    self.iceButton.serverType = SHRoomServerTypeICE;
    self.cleanButton.serverType = SHRoomServerTypeClean;
    self.readyBedButton.serverType = SHRoomServerTypeReadyBed;
    self.breakfastButton.serverType = SHRoomServerTypeBreakfast;
    
    // 文字适配
    [self.laudryButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Laudry"] forState:UIControlStateNormal];
    
    [self.cleanShoesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"CleanShoes"] forState:UIControlStateNormal];
    
    [self.takePlatesButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"TakePlates"] forState:UIControlStateNormal];
    
    [self.dndButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"DND"] forState:UIControlStateNormal];
    
    [self.towelsRobeButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Towels&Robe"] forState:UIControlStateNormal];
    
    [self.refillMiniBarButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"RefillMiniBar"] forState:UIControlStateNormal];
    
    [self.pillowBlanketButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Pillow&Blanket"] forState:UIControlStateNormal];
    
    [self.iceButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"ICE"] forState:UIControlStateNormal];
    
    [self.cleanButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Clean"] forState:UIControlStateNormal];
    
    [self.readyBedButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"ReadyBed"] forState:UIControlStateNormal];
    
    [self.breakfastButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"HouseKeepingAndVIP" withSubTitle:@"Breakfast"] forState:UIControlStateNormal];
}


@end
