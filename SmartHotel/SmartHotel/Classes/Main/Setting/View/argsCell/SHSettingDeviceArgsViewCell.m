//
//  SHSettingDeviceArgsViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSettingDeviceArgsViewCell.h"

@interface SHSettingDeviceArgsViewCell ()

/// 参数名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 参数值
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end


@implementation SHSettingDeviceArgsViewCell

- (void)setArgName:(NSString *)argName {
    
    _argName = argName.copy;
    
    self.nameLabel.text = argName;
}

- (void)setArgValue:(NSString *)argValue {
    
    _argValue = argValue;
    
    self.valueTextField.text = argValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.valueTextField
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/// 行高
+ (CGFloat)rowHeightForDeviceArgsViewCell {

    return navigationBarHeight;
}

@end
