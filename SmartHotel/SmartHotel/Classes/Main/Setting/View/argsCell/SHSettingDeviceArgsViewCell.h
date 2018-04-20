//
//  SHSettingDeviceArgsViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSettingDeviceArgsViewCell : UITableViewCell

/// 参数名称
@property (copy, nonatomic) NSString *argName;

/// 当前的房间信息
@property (strong, nonatomic) SHRoomBaseInfomation *currentRoomInfo;

/// 选择的设备
@property (strong, nonatomic) SHRoomDevice *selectDevice;

/// 位置
@property (strong, nonatomic) NSIndexPath *indexPath;

/// 行高
+ (CGFloat)rowHeightForDeviceArgsViewCell;

@end
