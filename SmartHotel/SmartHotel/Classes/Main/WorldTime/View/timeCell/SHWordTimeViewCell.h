//
//  SHWordTimeViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHWordTimeViewCell : UITableViewCell

/// 显示时间
@property (copy, nonatomic) NSString *showTime;

/// 显示名称
@property (copy, nonatomic) NSString *showName;


/// 行高
+ (CGFloat)rowHeight;

@end
