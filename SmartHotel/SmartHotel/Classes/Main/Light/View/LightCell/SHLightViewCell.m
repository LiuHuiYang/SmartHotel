//
//  SHLightViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHLightViewCell.h"
#import "SHLightButton.h"

@interface SHLightViewCell()

/// 亮度变化滑块
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet SHSwitchButton *switchButton;

/**
 图标按钮
 */
@property (weak, nonatomic) IBOutlet SHLightButton *iconButton;


/**
 亮度标签
 */
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;

@end

@implementation SHLightViewCell

/// 开关按钮
- (IBAction)switchButtonClick {
    
    [self iconButtonClick];
}

/**
 滑动松手
 */
- (IBAction)finishedMove {
    

    self.light.brightness =
        (Byte)self.brightnessSlider.value;
    
    Byte lightData[4] = {self.light.channelNo,  self.light.brightness, 0, 0};
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.light.subnetID targetDeviceID:self.light.deviceID additionalContentData:[NSMutableData dataWithBytes:lightData length:sizeof(lightData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:YES];
}


/**
 移动滑块
 */
- (IBAction)brightnessSliderChange {
    
    Byte brightness = self.brightnessSlider.value;
    
    self.brightnessLabel.text =
        [NSString stringWithFormat:@"%d%%", brightness];
    
    self.iconButton.selected = brightness;
}


- (IBAction)iconButtonClick {
    
    self.iconButton.selected = !self.iconButton.selected;
    self.switchButton.on = !self.switchButton.on;
    
    self.light.brightness =
        (self.iconButton.selected  || self.switchButton.on)? lightMaxBrightness: 0;
    
    Byte lightData[4] = {self.light.channelNo, self.light.brightness, 0, 0};
    
    [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0x0031 targetSubnetID:self.light.subnetID targetDeviceID:self.light.deviceID additionalContentData:[NSMutableData dataWithBytes:lightData length:sizeof(lightData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
    
    self.brightnessSlider.value = self.light.brightness;
    [self brightnessSliderChange];
}

    
- (void)setLight:(SHLight *)light {
    
    _light = light;
    
    [self.iconButton setTitle:light.lightName forState:UIControlStateNormal];
    self.iconButton.selected = light.brightness;
    self.switchButton.on = light.brightness;
    
    self.brightnessSlider.value = light.brightness;
    self.brightnessLabel.text = [NSString stringWithFormat:@"%d%%", light.brightness];
    
    switch (light.lightType) {
            
        case SHLightTypeDimmable: {
            self.brightnessSlider.hidden = NO;
            self.switchButton.hidden = YES;
        }
            break;
            
        case SHLightTypeNotDimmable: {
            self.brightnessSlider.hidden = YES;
            self.switchButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

/// 行高
+ (CGFloat)rowHeight {
    
    return navigationBarHeight + statusBarHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.brightnessSlider.maximumValue =
        lightMaxBrightness;
    self.brightnessSlider.minimumValue = 0;
    
    [self.brightnessSlider setThumbImage:[UIImage imageNamed:@"Curtain_Sld_Thumb"] forState:UIControlStateNormal];
    
    [self.brightnessSlider setMinimumTrackImage:[UIImage imageNamed:@"Curtain_MaxmumTrack"] forState:UIControlStateNormal];
    
    [self.brightnessSlider setMaximumTrackImage:[UIImage imageNamed:@"Curtaia_MinnumTrack"] forState:UIControlStateNormal];
    
    self.brightnessSlider.hidden = YES;
    self.switchButton.hidden = YES;
}

@end
