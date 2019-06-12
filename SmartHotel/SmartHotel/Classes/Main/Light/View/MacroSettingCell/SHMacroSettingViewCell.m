//
//  SHMacroSettingViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroSettingViewCell.h"

@interface SHMacroSettingViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end


@implementation SHMacroSettingViewCell

- (void)setMacro:(SHMacro *)macro {
    
    _macro = macro;
    
    self.iconView.image = [UIImage imageNamed:macro.macroIconName];
    
    self.nameLabel.text = macro.macroName;
}
 

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
