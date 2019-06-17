//
//  SHDeviceParametersDetailViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/4.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHDeviceParametersDetailViewCell : UITableViewCell

/**
 参数名称
 */
@property (copy, nonatomic) NSString *argName;


/**
 参数值
 */
@property (copy, nonatomic) NSString *argValue;

/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
