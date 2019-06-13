//
//  SHChannelGroupViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHChannelGroupViewCell.h"

@interface SHChannelGroupViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *nameButton;


@end

@implementation SHChannelGroupViewCell

- (void)setChannelGroup:(SHChannelGroup *)channelGroup {
    
    _channelGroup = channelGroup;
    
    [self.nameButton setTitle:channelGroup.groupName forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.nameButton.highlighted = selected;
}


/// 行高
+ (CGFloat)rowHeight {
    
    return navigationBarHeight;
}

@end
