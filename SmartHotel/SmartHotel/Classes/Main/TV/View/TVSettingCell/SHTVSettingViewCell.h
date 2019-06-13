//
//  SHTVSettingViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTVSettingViewCell : UITableViewCell

/// 频道分组
@property (strong, nonatomic) SHChannelGroup *channelGroup;

/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
