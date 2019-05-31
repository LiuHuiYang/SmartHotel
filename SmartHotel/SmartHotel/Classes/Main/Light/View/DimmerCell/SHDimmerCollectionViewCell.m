//
//  SHDimmerCollectionViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHDimmerCollectionViewCell.h"

@interface SHDimmerCollectionViewCell()

/// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 亮度
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;

/// 灯光图片
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

/// 亮度滑块
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@end

@implementation SHDimmerCollectionViewCell

/// 松手时才发送数据
- (IBAction)finishSlide {
    
    self.light.brightness = (Byte)self.brightnessSlider.value;
    
    Byte lightData[4] = {self.light.channelNo,  self.light.brightness, 0, 0};
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.light.subnetID targetDeviceID:self.light.deviceID additionalContentData:[NSMutableData dataWithBytes:lightData length:sizeof(lightData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
}


/// 移动块
- (IBAction)brightnessSlide {

    Byte brightness = self.brightnessSlider.value;
    
    self.brightnessLabel.text = [NSString stringWithFormat:@"%d%%", brightness];
    
    self.iconButton.selected = brightness;
}

/// 图标按钮
- (IBAction)iconButtonClick {
    
    self.iconButton.selected = !self.iconButton.selected;
    
    self.light.brightness = self.iconButton.selected ? lightMaxBrightness: 0;
    
    Byte lightData[4] = {self.light.channelNo, self.light.brightness, 0, 0};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.light.subnetID targetDeviceID:self.light.deviceID additionalContentData:[NSMutableData dataWithBytes:lightData length:sizeof(lightData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
    
    self.brightnessSlider.value = self.light.brightness;
    [self brightnessSlide];
}

- (void)setLight:(SHLight *)light {
    
    _light = light;
    
    self.nameLabel.text = light.lightName;
    self.iconButton.selected = light.brightness;
    self.brightnessSlider.value = light.brightness;
    self.brightnessLabel.text = [NSString stringWithFormat:@"%d%%", light.brightness];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.brightnessSlider setThumbImage:[UIImage imageNamed:@"Curtain_Sld_Thumb"] forState:UIControlStateNormal];
    
    [self.brightnessSlider setMinimumTrackImage:[UIImage imageNamed:@"Curtain_MaxmumTrack"] forState:UIControlStateNormal];
    
    [self.brightnessSlider setMaximumTrackImage:[UIImage imageNamed:@"Curtaia_MinnumTrack"] forState:UIControlStateNormal];
    
    [self brightnessSlide];
}

@end
