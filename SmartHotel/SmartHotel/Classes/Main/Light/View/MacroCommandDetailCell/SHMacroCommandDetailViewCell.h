//
//  SHMacroCommandDetailViewCell.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMacroCommandDetailViewCell : UITableViewCell

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
