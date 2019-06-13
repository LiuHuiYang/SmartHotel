//
//  SHTVSettingViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHTVSettingViewCell.h"

@interface SHTVSettingViewCell ()

/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SHTVSettingViewCell

- (void)setChannelGroup:(SHChannelGroup *)channelGroup {
    
    _channelGroup = channelGroup;
    
    self.nameLabel.text =
    [NSString stringWithFormat:@"%zd - %@",
     channelGroup.groupID, channelGroup.groupName
     ];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle =
    UITableViewCellSelectionStyleNone;
}

/// 行高
+ (CGFloat)rowHeight {
    
    return navigationBarHeight + statusBarHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
