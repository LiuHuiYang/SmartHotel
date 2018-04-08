
//
//  SHServiceButton.m
//  SmartHotel
//
//  Created by LHY on 2018/4/3.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SHServiceButton.h"

@implementation SHServiceButton

- (void)setUpUI {
    
    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    
//    self.backgroundColor = [UIColor greenColor];
//    self.titleLabel.backgroundColor = [UIColor purpleColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
         [self setUpUI];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUpUI];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.titleLabel.frame_x = self.frame_width * 0.5;
    self.titleLabel.frame_width = self.frame_width * 0.45;
    self.titleLabel.frame_height = self.frame_height * 0.7;
    self.titleLabel.frame_y = self.frame_height * 0.15;
}

@end
