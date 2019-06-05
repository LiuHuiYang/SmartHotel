//
//  SHMacroSettingViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroSettingViewCell.h"

@interface SHMacroSettingViewCell ()



@end


@implementation SHMacroSettingViewCell
 

/// 行高
+ (CGFloat)rowHeight {
    
    return navigationBarHeight + statusBarHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle =
    UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
