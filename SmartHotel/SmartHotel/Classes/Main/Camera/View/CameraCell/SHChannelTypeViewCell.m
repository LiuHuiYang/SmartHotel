//
//  SHCameraViewCell.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCameraViewCell.h"

@interface SHCameraViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *nameButton;



@end

@implementation SHCameraViewCell

- (void)setCamereName:(NSString *)camereName {
    
    _camereName = camereName.copy;
    
    [self.nameButton setTitle:camereName forState:UIControlStateNormal];
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
+ (CGFloat)rowHeightForCameraViewCell {
    
    return navigationBarHeight;
}

@end
