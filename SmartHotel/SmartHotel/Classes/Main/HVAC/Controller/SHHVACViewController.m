//
//  SHHVACViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACViewController.h"
#import "SHHVACRotationControlView.h"

@interface SHHVACViewController ()

/// 电源开关
@property (weak, nonatomic) IBOutlet SHSwitchButton *powerButton;


/// 制冷模式
@property (weak, nonatomic) IBOutlet UIButton *coldModelButton;

/// 凉快模式
@property (weak, nonatomic) IBOutlet UIButton *coolModelButton;

/// 制热模式
@property (weak, nonatomic) IBOutlet UIButton *heatModelButton;

/// 通风模式
@property (weak, nonatomic) IBOutlet UIButton *fanModelButton;

/// 自动模式
@property (weak, nonatomic) IBOutlet UIButton *autoModelButton;

/// 模式温度显示
@property (weak, nonatomic) IBOutlet UILabel *desiredLabel;

/// 控制摄氏温度按钮
@property (weak, nonatomic) IBOutlet UIButton *desiredCelsTemperatureButton;

/// 控制华氏温度按钮
@property (weak, nonatomic) IBOutlet UIButton *desiredFahrenheitTemperatureButton;

/// 当前温度显示
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;

/// 控制摄氏温度按钮
@property (weak, nonatomic) IBOutlet UIButton *currentCelsTemperatureButton;

/// 控制华氏温度按钮
@property (weak, nonatomic) IBOutlet UIButton *currentFahrenheitTemperatureButton;


// MARK: ------------------    增加几个属性 开关，模式，几个温度

@property (assign, nonatomic) BOOL isTurnOn;

@property (assign, nonatomic) NSInteger coolTemperture;

@property (assign, nonatomic) NSInteger heatTemperture;

@property (assign, nonatomic) NSInteger autoTemperture;

@property (assign, nonatomic) NSInteger indoorTemperature;

@property (assign, nonatomic) Byte acMode;

@property (assign, nonatomic) NSInteger startCoolTemperatureRange;

@property (assign, nonatomic) NSInteger endCoolTemperatureRange;

@property (assign, nonatomic) NSInteger startHeatTemperatureRange;

@property (assign, nonatomic) NSInteger endHeatTemperatureRange;

@property (assign, nonatomic) NSInteger startAutoTemperatureRange;

@property (assign, nonatomic) NSInteger endAutoTemperatureRange;

@end

@implementation SHHVACViewController

// MARK: - 解析

/// 收到广播数据
- (void)analyzeReceiveData:(NSNotification *)notification {
    
    NSData *data = notification.object;
    
    Byte *recivedData = ((Byte *) [data bytes]);
    
    UInt16 operatorCode = ((recivedData[5] << 8) | recivedData[6]);
  
    Byte subNetID = recivedData[1];
    Byte deviceID = recivedData[2];
    
    const Byte startIndex = 9;
    
    if ((subNetID != self.roomInfo.subNetIDForDDP) || (deviceID != self.roomInfo.deviceIDForDDP)) {
        return;
    }
    
    switch (operatorCode) {
        
        case 0XE3D9: {
            
            Byte operatorKind = recivedData[9]; // 获得操试方式
            Byte operatorResult = recivedData[10]; // 获得操作结果
            
            switch (operatorKind) {
                    
                    // AC on/off
                case SHAirConditioningControlTypeOnAndOFF: {
                    
                    self.isTurnOn = operatorResult; // 获得状态
                }
                    break;
                    
                    // 制冷温度
                case SHAirConditioningControlTypeCoolTemperatureSet: {
                    
                    self.coolTemperture = (operatorResult & 0X80) ? (0 - (0XFF - operatorResult + 1)) : operatorResult;
                }
                    break;
                    
                    // AC 工作模式
                case SHAirConditioningControlTypeAcModeSet: {
                    
                    self.acMode = operatorResult;
                }
                    break;
                    
                    // 制热温度
                case SHAirConditioningControlTypeHeatTemperatureSet: {
                    
                    self.heatTemperture = (operatorResult & 0X80) ? (0 - (0XFF - operatorResult + 1)) : operatorResult;
                }
                    break;
                    
                    // 自动温度
                case SHAirConditioningControlTypeAutoTemperatureSet: {
                    
                    self.autoTemperture = (operatorResult & 0X80) ? (0 - (0XFF - operatorResult + 1)) : operatorResult;
                }
                    break;
            }
        }
            
            break;
            
            
        case 0XE0ED: {
            
            self.isTurnOn = recivedData[9]; // 获得状态
            
            // 获得环境温度
            self.indoorTemperature = (recivedData[13] & 0X80) ? (0 - (0XFF - recivedData[13] + 1)) : recivedData[13];
            
            // 获得风速
//            self.currentHVAC.fanRange = recivedData[11] & 0X0F;
            
            // 获得工作用模式
            self.acMode = (recivedData[11] & 0XF0) >> 4;
            
            // 通风模式的温度
            self.coolTemperture = (recivedData[10] & 0X80) ? (0 - (0XFF - recivedData[10] + 1)) : recivedData[10];
            
            // 制热模式的温度
            self.heatTemperture = (recivedData[14] & 0X80) ? (0 - (0XFF - recivedData[14] + 1)) : recivedData[14];
            
            // 自动模式的温度
            self.autoTemperture = (recivedData[16] & 0X80) ? (0 - (0XFF - recivedData[16] + 1)) : recivedData[16];
        }
            break;
            
            
        case 0X1901: { // 获得不同模式的温度范围
            
            // 说明：由于协议中没有与温度传感器正负，而是使用了补码的方式来表示
            
            // 制冷温度范围
            Byte startCoolTemperatureRange = recivedData[startIndex];
            
            Byte endCoolTemperatureRange = recivedData[startIndex + 1];
            
            self.startCoolTemperatureRange = (startCoolTemperatureRange & 0X80) ? (0 - (0XFF - startCoolTemperatureRange + 1)) : startCoolTemperatureRange;
            
            self.endCoolTemperatureRange = (endCoolTemperatureRange & 0X80) ? (0 - (0XFF - endCoolTemperatureRange + 1)) : endCoolTemperatureRange;
            
            // 制热温度范围
            
            Byte startHeatTemperatureRange = recivedData[startIndex + 2];
            
            Byte endHeatTemperatureRange = recivedData[startIndex + 3];
            
            self.startHeatTemperatureRange = (startHeatTemperatureRange & 0X80) ? (0 - (0XFF - startHeatTemperatureRange + 1)) : startHeatTemperatureRange;
            
            self.endHeatTemperatureRange = (endHeatTemperatureRange & 0X80) ? (0 - (0XFF - endHeatTemperatureRange + 1)) : endHeatTemperatureRange;
            
            // 自动模式温度范围
            Byte startAutoTemperatureRange = recivedData[startIndex + 4];
            Byte endAutoTemperatureRange = recivedData[startIndex + 5];
            
            self.startAutoTemperatureRange = (startAutoTemperatureRange & 0X80) ? (0 - (0XFF - startAutoTemperatureRange + 1)) : startAutoTemperatureRange;
            
            self.endAutoTemperatureRange = (endAutoTemperatureRange & 0X80) ? (0 - (0XFF - endAutoTemperatureRange + 1)) : endAutoTemperatureRange;
        }
            break;
            
        default:
            break;
    }
    
    // 设置UI
    [self setACStatus];
}

/// 设置状态
- (void)setACStatus {
    
    // 开关
    self.powerButton.on = self.isTurnOn;
    
    // 环境温度
    [self.currentCelsTemperatureButton setTitle:[NSString stringWithFormat:@"%zd °C", self.indoorTemperature] forState:UIControlStateNormal];
    
    [self.currentFahrenheitTemperatureButton setTitle:[NSString stringWithFormat:@"%zd °F", (NSInteger)(self.indoorTemperature * 1.8 + 32)] forState:UIControlStateNormal];
    
    // 模式与模式温度
    self.coldModelButton.selected = NO;
    self.coolModelButton.selected = NO;
    self.heatModelButton.selected = NO;
    self.fanModelButton.selected = NO;
    self.autoModelButton.selected = NO;
    
    switch (self.acMode) {
            
        case SHAirConditioningModeKindCool: {
            
            self.coldModelButton.selected = YES;
            self.coolModelButton.selected = YES;
            [self updateDescriedTemperture:self.coolTemperture];
            
        }
            break;
            
        case SHAirConditioningModeKindHeat: {
            
            self.heatModelButton.selected = YES;
            [self updateDescriedTemperture:self.heatTemperture];
        }
            break;
            
        case SHAirConditioningModeKindFan: {
            
            self.fanModelButton.selected = YES;
            [self updateDescriedTemperture:self.coolTemperture];
        }
            break;
            
        case SHAirConditioningModeKindAuto: {
            
            self.autoModelButton.selected = YES;
            [self updateDescriedTemperture:self.autoTemperture];
        }
            break;
            
        default:
            break;
    }
}

/// 更新温度显示
- (void)updateDescriedTemperture:(Byte)temperature {
    
    [self.desiredCelsTemperatureButton setTitle:[NSString stringWithFormat:@"%d °C", temperature] forState:UIControlStateNormal];
    
    [self.desiredFahrenheitTemperatureButton setTitle:[NSString stringWithFormat:@"%zd °F", (NSInteger)(temperature * 1.8 + 32)] forState:UIControlStateNormal];
}

// MARK: - 控制数据

/// 自动
- (IBAction)autoModelButtonClick {
  
    [self controlHVACSelectButton:self.autoModelButton acModeValue:SHAirConditioningModeKindAuto setTempertureKind:SHAirConditioningControlTypeAutoTemperatureSet temperture:26];
}

/// 通风
- (IBAction)fanModelButtonClick {
    
    [self controlHVACSelectButton:self.fanModelButton acModeValue:SHAirConditioningModeKindFan setTempertureKind:SHAirConditioningControlTypeFanSpeedSet temperture:22];
}

/// 制热
- (IBAction)heatModelButtonClick {
    
    [self controlHVACSelectButton:self.heatModelButton acModeValue:SHAirConditioningModeKindHeat setTempertureKind:SHAirConditioningControlTypeHeatTemperatureSet temperture:30];
}

/// 凉快
- (IBAction)coolModelButtonClick {
    
    [self controlHVACSelectButton:self.coolModelButton acModeValue:SHAirConditioningModeKindCool setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:24];
}

/// 制冷
- (IBAction)coldModelButtonClick {
 
    [self controlHVACSelectButton:self.coldModelButton acModeValue:SHAirConditioningModeKindCool setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:18];
}

/// 快速控制空调
- (void)controlHVACSelectButton:(UIButton *)selectModelButton acModeValue:(SHAirConditioningModeKind)modeKind setTempertureKind:(Byte)tempertureKind temperture:(Byte )temperature {
    
    // 全部取消
    self.coldModelButton.selected = NO;
    self.coolModelButton.selected = NO;
    self.heatModelButton.selected = NO;
    self.fanModelButton.selected = NO;
    self.autoModelButton.selected = NO;
    
    // 选中的按钮
    selectModelButton.selected = YES;
    
    Byte controlModelData[2] = {SHAirConditioningControlTypeAcModeSet, modeKind};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlModelData length:sizeof(controlModelData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
    
    [NSThread sleepForTimeInterval:0.01];
    
    // 对应的温度
    Byte controlTempertureData[2] = {tempertureKind, temperature };
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlTempertureData length:sizeof(controlTempertureData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
    
    // 设置显示界面 updateModeButtonStatu
    [self updateDescriedTemperture:temperature];
}

/// 修改模式温度
- (void)changeModelTemperature:(NSInteger)temperature {
    
    // 发送温度
    Byte temperatureData[2] = { 0 };
    
    // 模式温度过滤
    switch (self.acMode) {
            
        case SHAirConditioningModeKindHeat: { // 制热
            
            temperatureData[0] = SHAirConditioningControlTypeHeatTemperatureSet;
            
            if (temperature < self.startHeatTemperatureRange || temperature > self.endHeatTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeKindFan:
        case SHAirConditioningModeKindCool: {
            
            temperatureData[0] = SHAirConditioningControlTypeCoolTemperatureSet;
            
            if (temperature < self.startCoolTemperatureRange || temperature > self.endCoolTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        case SHAirConditioningModeKindAuto: {
            
            temperatureData[0] = SHAirConditioningControlTypeAutoTemperatureSet;
            
            if (temperature < self.startAutoTemperatureRange || temperature > self.endAutoTemperatureRange) {
                
                [SVProgressHUD showInfoWithStatus:@"Exceeding the set temperature"];
                
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    // 如果是负数使用被码
    temperatureData[1] =  (temperature & 0X80) ? (0 - (0XFF - temperature + 1)) : temperature;
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:temperatureData length:sizeof(temperatureData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
}



/// 电源开关
- (IBAction)powerButtonClick {

    self.powerButton.on = !self.powerButton.on;
    
    Byte controlData[2] = {SHAirConditioningControlTypeOnAndOFF, self.powerButton.isOn};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // FIXME: 统一取成0，如果有问题再说。
    Byte readHVACdata[] = { 0 };
    
    // 2.读取空调的温度范围
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X1900 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:nil remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
    
    [NSThread sleepForTimeInterval:0.1];
    
    // 3.读取状态空调的开关状态
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE0EC targetSubnetID:self.roomInfo.subNetIDForDDP  targetDeviceID:self.roomInfo.deviceIDForDDP  additionalContentData:[NSMutableData dataWithBytes:readHVACdata length:sizeof(readHVACdata)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"AC"];
    
    [self.coldModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Cold"] forState:UIControlStateNormal];
    
    [self.coolModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Cool"] forState:UIControlStateNormal];
    
    [self.heatModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Heat"] forState:UIControlStateNormal];
    
    [self.fanModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Fan"] forState:UIControlStateNormal];
    
    [self.autoModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Auto"] forState:UIControlStateNormal];
    
    self.currentTemperatureLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Current Tempterature"];
    
    self.desiredLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Desired"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
