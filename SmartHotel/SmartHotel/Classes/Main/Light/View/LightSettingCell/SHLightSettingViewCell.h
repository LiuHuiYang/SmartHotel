//
//  SHLightSettingViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHLightSettingViewCell : UITableViewCell

/// light
@property (strong, nonatomic) SHLight *light;
    
/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
