//
//  SHLightButton.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHLightButton.h"

@implementation SHLightButton

- (void)setUpUi {
    
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
    self.imageView.frame_x = 0;
    self.imageView.frame_y = 0;
    self.imageView.frame_width = self.frame_width;
    self.imageView.frame_height = self.frame_height * 0.45;
    
    self.titleLabel.frame_x = 0;
    self.titleLabel.frame_width = self.frame_width;
    self.titleLabel.frame_y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.frame_height = self.frame_height - self.titleLabel.frame_y;
}

@end
