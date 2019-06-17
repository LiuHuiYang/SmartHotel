//
//  SHDeviceParametersDetailViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/4.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHDeviceParametersDetailViewCell.h"

@interface SHDeviceParametersDetailViewCell ()


/**
 参数名称
 */
@property (weak, nonatomic) IBOutlet UILabel *argsNameLabel;


/**
 参数值
 */
@property (weak, nonatomic) IBOutlet UILabel *argsValueLabel;

@end

@implementation SHDeviceParametersDetailViewCell

- (void)setArgName:(NSString *)argName {
    
    _argName = argName.copy;
    
    self.argsNameLabel.text = argName;
}

- (void)setArgValue:(NSString *)argValue {
    
    _argValue = argValue.copy;
    
    self.argsValueLabel.text = argValue;
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
