//
//  SHChannelTypeViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHChannelTypeViewCell.h"

@interface SHChannelTypeViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *nameButton;


@end

@implementation SHChannelTypeViewCell

- (void)setChannelType:(SHChannelType *)channelType {
    
    _channelType = channelType;
    
    [self.nameButton setTitle:channelType.typeName forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.nameButton.highlighted = selected;
}


/// 行高
+ (CGFloat)rowHeightForChannelTypeViewCell {
    
    return navigationBarHeight;
}

@end
