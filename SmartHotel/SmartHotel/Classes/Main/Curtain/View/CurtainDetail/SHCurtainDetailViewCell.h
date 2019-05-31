//
//  SHCurtainDetailViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHCurtainDetailViewCell : UITableViewCell


/**
 参数名称
 */
@property (copy, nonatomic) NSString *argsName;


/**
 参数值
 */
@property (copy, nonatomic) NSString *argValueText;

/// 行高
+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
