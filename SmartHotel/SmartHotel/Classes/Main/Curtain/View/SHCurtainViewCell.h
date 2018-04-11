//
//  SHCurtainViewCell.h
//  SmartHotel
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCurtainViewCell : UITableViewCell


@property (strong, nonatomic) SHCurtain *curtain;


/// 行高
+ (CGFloat)rowHeightForCurtainViewCell;

@end
