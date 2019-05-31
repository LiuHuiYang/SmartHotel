//
//  SHSettingDeiviceTypeViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/20.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSettingDeiviceTypeViewCell.h"

@interface SHSettingDeiviceTypeViewCell ()


@property (weak, nonatomic) IBOutlet UIButton *nameButton;


@end

@implementation SHSettingDeiviceTypeViewCell

- (void)setDeviceName:(NSString *)deviceName {
    
    _deviceName = deviceName.copy;
    
    [self.nameButton setTitle:deviceName forState:UIControlStateNormal];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.nameButton.highlighted = selected;
}

/// 行高
+ (CGFloat)rowHeightForDeviceTypeViewCell {
    
    return navigationBarHeight;
}


@end
