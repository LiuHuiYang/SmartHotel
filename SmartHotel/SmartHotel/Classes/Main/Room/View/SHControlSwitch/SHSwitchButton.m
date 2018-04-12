//
//  SHSwitchButton.m
//  SmartHotel
//
//  Created by Mac on 2018/4/12.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHSwitchButton.h"

@interface SHSwitchButton ()

@end

@implementation SHSwitchButton


/// 状态开启的图片
- (void)setOnImage:(UIImage *)onImage {
    
    _onImage = onImage;
    [self setImage:onImage forState:UIControlStateSelected];
}

/// 状态关闭的图片
- (void)setOffImage:(UIImage *)offImage {
    
    _offImage = offImage;
    
    [self setImage:offImage forState:UIControlStateNormal];
}

- (void)setUpUi {
    
    _on = self.selected;  // 获取它的默认值 
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUi];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setUpUi];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame_y = self.frame_height * 0.1;
    self.imageView.frame_height = self.frame_height * 0.8;
    self.imageView.frame_width = self.frame_width * 0.4;
    
    
    if (self.selected) {
        
        self.imageView.frame_x = self.frame_width * 0.55;
        
    } else {
        
        self.imageView.frame_x = self.frame_width * 0.05;
        
    }
    
}

- (void)setOn:(BOOL)on {
    
    _on = on;
    self.selected = on;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    _on = selected;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self layoutIfNeeded];
    }];
 
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
