//
//  SHMacroDetailViewCell.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHMacroDetailViewCell.h"

@interface SHMacroDetailViewCell ()

/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SHMacroDetailViewCell

- (void)setMacroCommand:(SHMacroCommand *)macroCommand {
    
    _macroCommand = macroCommand;
    
    self.nameLabel.text =
    [NSString stringWithFormat:@"%zd - %@: %zd - %zd - %zd",
     macroCommand.macroCommandID,
     macroCommand.remark,
     macroCommand.commandType,
     macroCommand.subnetID,
     macroCommand.deviceID
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
