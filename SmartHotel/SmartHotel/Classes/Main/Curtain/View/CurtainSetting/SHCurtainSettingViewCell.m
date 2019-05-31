//
//  SHCurtainSettingViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHCurtainSettingViewCell.h"

@interface SHCurtainSettingViewCell ()


/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SHCurtainSettingViewCell

- (void)setCurtain:(SHCurtain *)curtain {
    
    _curtain = curtain;
    
    self.nameLabel.text =
        [NSString stringWithFormat:@"%zd - %@ : %zd - %zd",
            curtain.curtainID, curtain.curtainName,
            curtain.subnetID, curtain.deviceID
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
