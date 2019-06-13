//
//  SHMacroSettingViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMacroSettingViewCell : UITableViewCell

/**
 宏对象模型
 */
@property (assign, nonatomic) SHMacro *macro;

/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
