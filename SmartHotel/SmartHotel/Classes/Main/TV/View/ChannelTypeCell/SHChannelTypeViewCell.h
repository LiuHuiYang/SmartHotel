//
//  SHChannelTypeViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHChannelTypeViewCell : UITableViewCell

/// 频道类型
@property (strong, nonatomic) SHChannelType *channelType;

/// 行高
+ (CGFloat)rowHeightForChannelTypeViewCell;

@end
