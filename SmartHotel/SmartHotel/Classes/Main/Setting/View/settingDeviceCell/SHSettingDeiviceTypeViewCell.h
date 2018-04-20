//
//  SHSettingDeiviceTypeViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/4/20.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSettingDeiviceTypeViewCell : UITableViewCell

/// 设备名称
@property (copy, nonatomic) NSString *deviceName;

/// 行高
+ (CGFloat)rowHeightForDeviceTypeViewCell;


@end
