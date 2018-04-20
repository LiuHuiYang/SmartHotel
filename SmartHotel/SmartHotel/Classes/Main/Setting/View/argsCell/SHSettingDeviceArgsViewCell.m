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

/// 房间参数名称
@property (strong, nonatomic) NSMutableArray *roomArgNames;

/// 设备参数信息
@property (strong, nonatomic) NSMutableArray *deviceArgNames;

@end


@implementation SHSettingDeviceArgsViewCell

- (void)setSelectDevice:(SHRoomDevice *)selectDevice {
    
    _selectDevice = selectDevice;
    
    self.nameLabel.text = self.deviceArgNames[self.indexPath.row];
    
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
    
    self.nameLabel.text = self.roomArgNames[self.indexPath.row];
    
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

//- (void)setArgName:(NSString *)argName {
//    
//    _argName = argName.copy;
//    
//    self.nameLabel.text = argName;
//}
//
//- (void)setArgValue:(NSString *)argValue {
//    
//    _argValue = argValue;
//    
//    self.valueTextField.text = argValue;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roomArgNames = [NSMutableArray arrayWithObjects:
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Building ID"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Floor ID"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Room NO."],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Room NO. Display"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"RoomAlias"],
                     
                     [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"HotelName"],
                     
                     nil];
    
    
    self.deviceArgNames = [NSMutableArray arrayWithObjects:
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Subnet ID"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"PUBLIC" withSubTitle:@"Device ID"],
                      [[SHLanguageTools shareSHLanguageTools] getTextFromPlist:@"SETTINGS" withSubTitle:@"Remark"],
                      
                      nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/// 行高
+ (CGFloat)rowHeightForDeviceArgsViewCell {

    return navigationBarHeight;
}

@end
