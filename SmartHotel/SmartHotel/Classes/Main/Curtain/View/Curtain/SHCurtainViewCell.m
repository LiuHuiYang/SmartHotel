//
//  SHCurtainViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

/// 窗帘的状态
typedef NS_ENUM(NSUInteger, SHShadeStatus) {
    
    SHShadeStatusUnKnow,
    SHShadeStatusOpen,
    SHShadeStatusClose,
    SHShadeStatusStop
};

#import "SHCurtainViewCell.h"

@interface SHCurtainViewCell ()

/// 当前的窗帘的状态(增加属性 便于操作)
@property (assign, nonatomic) SHShadeStatus currentStatus;

/// 窗帘名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 打开标签
@property (weak, nonatomic) IBOutlet UILabel *openLabel;

/// 百分比标签
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

/// 关闭标签
@property (weak, nonatomic) IBOutlet UILabel *closeLabel;

/// 滑动条
@property (weak, nonatomic) IBOutlet UISlider *slider;


@end

@implementation SHCurtainViewCell

/// 打开窗帘
- (IBAction)openCurtain {
    
    self.currentStatus = SHShadeStatusOpen;
    
    if (self.curtain.curtainType) {  // 通用开关
        
        Byte controlData[2] =
            {self.curtain.openChannel, 0xFF};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE01C targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
    } else {  // 通道控制
        
        
        Byte controlData_G4[4] =
            {self.curtain.openChannel, 100, 0, 0};
        
        // G4
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G4 length:sizeof(controlData_G4)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
        [NSThread sleepForTimeInterval:0.03];
        
        // G3 0xE3E0
        
        Byte controlData_G3[2] =
            {self.curtain.openChannel, 100};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE3E0 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G3 length:sizeof(controlData_G3)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
    }
    
    [SVProgressHUD showSuccessWithStatus:@"Open curtain"];
}

/// 停止窗帘
- (IBAction)stopCurtain {
    
    self.currentStatus = SHShadeStatusStop;
    
    if (self.curtain.curtainType) {  // 通用开关
        
        Byte controlData[2] =
            {self.curtain.stopChannel, 0xFF};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE01C targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
    } else {
        
        // G4 == 三路 独立的窗帘停止通道
        if (self.curtain.stopChannel) {
            
            Byte controlData[4] = {self.curtain.stopChannel, 100, 0, 0}; // 这种类型的停止必须给100
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
            
        } else {
            
            // G4 == 两路
            Byte controlData_G4[4] =
                {(self.currentStatus == SHShadeStatusOpen) ? self.curtain.openChannel : self.curtain.closeChannel, 0, 0, 0};
            
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G4 length:sizeof(controlData_G4)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
            
            [NSThread sleepForTimeInterval:0.03];
            
            // 兼容G3
            Byte controlData_G3[2] =
                {(self.currentStatus == SHShadeStatusOpen) ? self.curtain.openChannel : self.curtain.closeChannel, 0};
            
            // G3 0XE3E0
            [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3E0 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G3 length:sizeof(controlData_G3)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
            
        }
        
    }
    
     [SVProgressHUD showSuccessWithStatus:@"Stop curtain"];
}

/// 关闭窗帘
- (IBAction)closeCurtain {
    
    self.currentStatus = SHShadeStatusClose;
    
    if (self.curtain.curtainType) {  // 通用开关
        
        Byte controlData[2] = {self.curtain.closeChannel, 0xFF};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0xE01C targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData length:sizeof(controlData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
    } else {
        
        Byte controlData_G4[4] = {self.curtain.closeChannel, 100, 0, 0};
        
        // G4
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G4 length:sizeof(controlData_G4)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
        
        [NSThread sleepForTimeInterval:0.03];
        
        // G3 0XE3E0
        
        Byte controlData_G3[2] = {self.curtain.closeChannel, 100};
        
        [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0XE3E0 targetSubnetID:self.curtain.subnetID targetDeviceID:self.curtain.deviceID additionalContentData:[NSMutableData dataWithBytes:controlData_G3 length:sizeof(controlData_G3)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
    }
    
    [SVProgressHUD showSuccessWithStatus:@"Close curtain"];
}


/// 滑动条正在滑动 （这个功能只是做一个延时发送指令，不是开启的比例）
- (IBAction)sliderValueChange {
    
    self.percentLabel.text = [NSString stringWithFormat:@"%@%%", @((NSInteger)self.slider.value)];
}

- (void)setCurtain:(SHCurtain *)curtain {
    
    _curtain = curtain;
    
    self.nameLabel.text = curtain.curtainName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    
    self.openLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Open"];
    
    self.closeLabel.text = [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Close"];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"Curtain_Sld_Thumb"] forState:UIControlStateNormal];
    
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"Curtain_MaxmumTrack"] forState:UIControlStateNormal];
    
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"Curtaia_MinnumTrack"] forState:UIControlStateNormal];
    
    [self sliderValueChange];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


/// 行高
+ (CGFloat)rowHeightForCurtainViewCell {
    
    return navigationBarHeight + tabBarHeight;
    
}

@end
