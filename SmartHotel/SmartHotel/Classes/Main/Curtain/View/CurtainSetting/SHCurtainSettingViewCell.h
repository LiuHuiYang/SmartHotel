//
//  SHCurtainSettingViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHCurtainSettingViewCell : UITableViewCell

@property (strong, nonatomic) SHCurtain *curtain;


/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
