//
//  SHTVChannelSettingCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTVChannelSettingCell : UITableViewCell

/// 频道分组
@property (strong, nonatomic) SHChannel *channel;

/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
