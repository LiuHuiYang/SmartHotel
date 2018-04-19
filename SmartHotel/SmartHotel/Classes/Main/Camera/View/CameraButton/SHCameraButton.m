//
//  SHCameraButton.m
//  SmartHotel
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCameraButton.h"

@implementation SHCameraButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
     
    self.titleLabel.frame_y = self.frame_height * 0.2;
    self.titleLabel.frame_height = self.frame_height * 0.6;
    self.titleLabel.frame_x = self.frame_width * 0.45;
    self.titleLabel.frame_width = self.frame_width * 0.45;
}

- (void)setUpUi {


    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setUpUi];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUi];
    }
    
    return self;
}

@end
