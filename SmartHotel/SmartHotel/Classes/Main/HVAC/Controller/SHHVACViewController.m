//
//  SHHVACViewController.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACViewController.h"

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

@end

@implementation SHHVACViewController

/// 自动
- (IBAction)autoModelButtonClick {
  
    [self controlHVACSelectButton:self.autoModelButton acModeValue:SHAirConditioningModeKindCool setTempertureKind:SHAirConditioningControlTypeAutoTemperatureSet temperture:25];
}

/// 通风
- (IBAction)fanModelButtonClick {
    
    [self controlHVACSelectButton:self.fanModelButton acModeValue:SHAirConditioningModeKindFan setTempertureKind:SHAirConditioningControlTypeFanSpeedSet temperture:23];
}

/// 制热
- (IBAction)heatModelButtonClick {
    
    [self controlHVACSelectButton:self.heatModelButton acModeValue:SHAirConditioningModeKindHeat setTempertureKind:SHAirConditioningControlTypeHeatTemperatureSet temperture:27];
}

/// 凉快
- (IBAction)coolModelButtonClick {
    
    [self controlHVACSelectButton:self.coolModelButton acModeValue:SHAirConditioningModeKindCool setTempertureKind:SHAirConditioningControlTypeCoolTemperatureSet temperture:23];
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
    
    // 对应的温度
    Byte controlTempertureData[2] = {tempertureKind, temperature };
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlTempertureData length:sizeof(controlTempertureData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}

/// 电源开关
- (IBAction)powerButtonClick {

    self.powerButton.on = !self.powerButton.on;
    
    Byte controlData[2] = {SHAirConditioningControlTypeOnAndOFF, self.powerButton.isOn};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3D8 targetSubnetID:self.roomInfo.subNetIDForDDP targetDeviceID:self.roomInfo.deviceIDForDDP additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:[SHUdpSocket getRemoteControlMacAddress] needReSend:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"MAINVIEW" withSubTitle:@"AC"];
    
    [self.coldModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Cold"] forState:UIControlStateNormal];
    
    [self.coolModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Cool"] forState:UIControlStateNormal];
    
    [self.heatModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Heat"] forState:UIControlStateNormal];
    
    [self.fanModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Fan"] forState:UIControlStateNormal];
    
    [self.autoModelButton setTitle:[[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"AC" withSubTitle:@"Auto"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
