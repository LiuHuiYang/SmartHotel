//
//  SHRelayCollectionViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHRelayCollectionViewCell.h"
#import "SHLightButton.h"

@interface SHRelayCollectionViewCell ()

@property (weak, nonatomic) IBOutlet SHLightButton *iconButton;

@property (weak, nonatomic) IBOutlet SHSwitchButton *switchButton;

@end


@implementation SHRelayCollectionViewCell

- (void)setLight:(SHLight *)light {

    _light = light;
    [self.iconButton setTitle:light.lightName forState:UIControlStateNormal];

    self.iconButton.selected = light.brightness;
    self.switchButton.on = light.brightness;
}

/// 图标按钮点击
- (IBAction)iconButtonClick {

    [self controlButtonClick];
}

/// 开关按钮
- (IBAction)switchButtonClick {

    [self controlButtonClick];
}

- (void)controlButtonClick {

    self.iconButton.selected = !self.iconButton.selected;
    self.switchButton.on = !self.switchButton.on;

    self.light.brightness = (self.iconButton.selected  || self.switchButton.on)? lightMaxBrightness: 0;
    
    Byte lightData[4] = {self.light.channelNo, self.light.brightness, 0, 0};

  [[SHUdpSocket shareSHUdpSocket] sendDataWithOperatorCode:0X0031 targetSubnetID:self.light.subnetID targetDeviceID:self.light.deviceID additionalContentData:[NSMutableData dataWithBytes:lightData length:sizeof(lightData)] remoteMacAddress:([SHUdpSocket getRemoteControlMacAddress]) needReSend:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.iconButton setTitleColor:SHDefualtTextColor forState:UIControlStateNormal];

//    [self controlButtonClick];
    
    
}

@end
