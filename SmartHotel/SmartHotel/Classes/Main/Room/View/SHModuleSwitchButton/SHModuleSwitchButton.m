//
//  SHModuleSwitchButton.m
//  SmartHotel
//
//  Created by LHY on 2018/4/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SHModuleSwitchButton.h"

@implementation SHModuleSwitchButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setTextColor];
    }
    
    return self;
}

/// 设置颜色
- (void)setTextColor {
    
    self.titleLabel.numberOfLines = 0;
    
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    // 新版本 取消文字显示
    CGFloat scale = 0.80;
    self.imageView.frame_width = self.frame_height * scale;
    self.imageView.frame_x = (self.frame_width - self.imageView.frame_width) * 0.5;
    self.imageView.frame_height = self.frame_height * scale;
    self.imageView.frame_y = (self.frame_height - self.imageView.frame_height) * 0.5;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 旧版本
    if (self.currentTitle.length) {
        
        self.imageView.frame_x = 0;
        self.imageView.frame_y = 0;
        self.imageView.frame_width = self.frame_width;
        self.imageView.frame_height = self.frame_height * 0.65;
        
        self.titleLabel.frame_x = 0;
        self.titleLabel.frame_y = self.imageView.frame_height;
        self.titleLabel.frame_width = self.frame_width;
        self.titleLabel.frame_height = self.frame_height - self.imageView.frame_height;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel.font = [UIFont systemFontOfSize:22];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted {}


@end
