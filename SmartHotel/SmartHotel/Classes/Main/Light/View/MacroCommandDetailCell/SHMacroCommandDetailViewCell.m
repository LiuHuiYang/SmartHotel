//
//  SHMacroCommandDetailViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroCommandDetailViewCell.h"

@interface SHMacroCommandDetailViewCell ()

/**
 参数名称
 */
@property (weak, nonatomic) IBOutlet UILabel *argsNameLabel;


/**
 参数值
 */
@property (weak, nonatomic) IBOutlet UILabel *argsValueLabel;

@end


@implementation SHMacroCommandDetailViewCell


- (void)setArgsName:(NSString *)argsName {
    
    _argsName = argsName.copy;
    
    self.argsNameLabel.text = argsName;
}

- (void)setArgValueText:(NSString *)argValueText {
    
    _argValueText = argValueText.copy;
    
    self.argsValueLabel.text = argValueText;
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
