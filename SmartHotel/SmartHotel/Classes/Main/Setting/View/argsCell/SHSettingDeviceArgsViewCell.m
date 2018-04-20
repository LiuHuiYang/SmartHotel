//
//  SHSettingDeviceArgsViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSettingDeviceArgsViewCell.h"

@interface SHSettingDeviceArgsViewCell () <UITextFieldDelegate>

/// 参数名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 参数值
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;


@end


@implementation SHSettingDeviceArgsViewCell

// MARK: - 代理

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    printLog(@"编辑结束");
}

/// 确定返回
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

// MARK: - 设置属性

- (void)setSelectDevice:(SHRoomDevice *)selectDevice {
    
    _selectDevice = selectDevice;
    
    switch (self.indexPath.row) {
        case 0:
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(selectDevice.subnetID)];
            break;
            
        case 1:
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(selectDevice.deviceID)];
            break;
            
        case 2:
            self.valueTextField.text = self.selectDevice.deviceRemark;
            break;
            
        default:
            break;
    }
}

- (void)setCurrentRoomInfo:(SHRoomBaseInfomation *)currentRoomInfo {
    
    _currentRoomInfo = currentRoomInfo;

    switch (self.indexPath.row) {
            
        case 0: {
            
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(currentRoomInfo.buildID)];
        }
            break;
            
        case 1: {
            
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(currentRoomInfo.floorID)];
        }
            break;
            
        case 2: {
            
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(currentRoomInfo.roomNumber)];
        }
            break;
            
        case 3: {
            
            self.valueTextField.text = [NSString stringWithFormat:@"%@", @(currentRoomInfo.roomNumberDisplay)];
        }
            break;
            
        case 4: {
            
            self.valueTextField.text = currentRoomInfo.roomAlias;
        }
            break;
            
        case 5: {
            
            self.valueTextField.text = currentRoomInfo.hotelName;
        }
            break;
            
            
        default:
            break;
    }
}

- (void)setArgName:(NSString *)argName {
    
    _argName = argName.copy;
    
    self.nameLabel.text = argName;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/// 行高
+ (CGFloat)rowHeightForDeviceArgsViewCell {

    return navigationBarHeight;
}

@end
