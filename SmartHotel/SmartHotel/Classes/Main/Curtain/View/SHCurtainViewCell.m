//
//  SHCurtainViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCurtainViewCell.h"

@interface SHCurtainViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

 
@end

@implementation SHCurtainViewCell

/// 打开窗帘
- (IBAction)openCurtain {

    printLog(@"");
}

/// 停止窗帘
- (IBAction)stopCurtain {
    
    printLog(@"");
}

/// 关闭窗帘
- (IBAction)closeCurtain {
    
    printLog(@"");
}


- (void)setCurtain:(SHCurtain *)curtain {
    
    _curtain = curtain;
    
    self.nameLabel.text = curtain.curtainName;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/// 行高
+ (CGFloat)rowHeightForCurtainViewCell {

    return navigationBarHeight + tabBarHeight;
    
}

@end
