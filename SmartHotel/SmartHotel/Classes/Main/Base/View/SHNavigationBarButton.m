//
//  SHNavigationBarButton.m
//  SmartHotel
//
//  Created by LHY on 2018/4/4.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SHNavigationBarButton.h"

@interface SHNavigationBarButton ()

@property (assign, nonatomic) BOOL isDefault;

@end

@implementation SHNavigationBarButton


+ (instancetype)navigationBarButton:(NSString *)text font:(UIFont *)font image:(UIImage *)image isDefault:(BOOL)isDefault addGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer {
    
    SHNavigationBarButton *button = [[self alloc] init];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    
//    button.titleLabel.textAlignment = image ? NSTextAlignmentCenter : NSTextAlignmentRight;
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:SHDefualtTextColor forState:UIControlStateNormal];
    
    button.titleLabel.font = font;
    
    button.isDefault = isDefault;
    [button addGestureRecognizer:gestureRecognizer];
    
    [button sizeToFit];
    
    return button;
}

- (void)setUpUi{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.isDefault) {
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
//    self.backgroundColor = [UIColor redColor];
//    self.imageView.backgroundColor = [UIColor orangeColor];
//    self.titleLabel.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.isDefault) {
     
        self.imageView.frame_width = MIN(self.frame_height, self.frame_width);
        self.imageView.frame_height = self.imageView.frame_width;
        
        self.imageView.frame_x = 0;
        self.imageView.frame_y = (self.frame_height - self.imageView.frame_height) * 0.5;
        
        self.titleLabel.frame_x = CGRectGetMaxX(self.imageView.frame) + statusBarHeight * 0.5;
        self.titleLabel.frame_y = self.imageView.frame_y;
        self.titleLabel.frame_height = self.imageView.frame_height;
        self.titleLabel.frame_width = self.frame_width - self.titleLabel.frame_x;
        
    } else {
        
        self.imageView.frame_width = MIN(self.frame_height, self.frame_width);
        self.imageView.frame_height = self.imageView.frame_width;
        
        self.imageView.frame_x = self.frame_width - self.imageView.frame_width;
        self.imageView.frame_y = (self.frame_height - self.imageView.frame_height) * 0.5;
        
        self.titleLabel.frame_x = 0;
        self.titleLabel.frame_y = self.imageView.frame_y;
        self.titleLabel.frame_height = self.imageView.frame_height;
        self.titleLabel.frame_width = self.frame_width - self.imageView.frame_width;
    }
    
    if (!self.imageView.image) {
        
        self.titleLabel.frame = self.bounds;
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpUi];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUpUi];
}


@end
