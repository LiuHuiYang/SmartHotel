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

/// 参数值
@property (copy, nonatomic) NSString *argValue;

/// 行高
+ (CGFloat)rowHeightForDeviceArgsViewCell;

@end
