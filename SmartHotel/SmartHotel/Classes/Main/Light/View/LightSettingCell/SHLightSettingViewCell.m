//
//  SHLightSettingViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHLightSettingViewCell.h"

@interface SHLightSettingViewCell ()
    
/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SHLightSettingViewCell
    
- (void)setLight:(SHLight *)light {
    
    _light = light;
    
    self.nameLabel.text =
    [NSString stringWithFormat:@"%zd - %@ : %zd - %zd - %zd",
        light.lightID, light.lightName,
        light.subnetID, light.deviceID, light.channelNo
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
