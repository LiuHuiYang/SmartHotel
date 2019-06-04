//
//  SHWordTimeViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHWordTimeViewCell.h"

@interface SHWordTimeViewCell ()

/// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation SHWordTimeViewCell

- (void)setShowName:(NSString *)showName {
    
    _showName = showName.copy;
    
    self.nameLabel.text = showName;
}

- (void)setShowTime:(NSString *)showTime {
    
    _showTime = showTime;
    
    self.timeLabel.text = showTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/// 行高
+ (CGFloat)rowHeight {
    
    return navigationBarHeight + statusBarHeight;
}

@end
