//
//  SHCameraViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCameraViewCell : UITableViewCell

/// 摄像头的名称
@property (copy, nonatomic) NSString *camereName;

/// 行高
+ (CGFloat)rowHeightForCameraViewCell;

@end
