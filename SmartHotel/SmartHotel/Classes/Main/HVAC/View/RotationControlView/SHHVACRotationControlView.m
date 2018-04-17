//
//  SHHVACRotationControlView.m
//  SmartHotel
//
//  Created by Mac on 2018/4/17.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACRotationControlView.h"

@interface SHHVACRotationControlView ()


@end

@implementation SHHVACRotationControlView

/// 设置界面
- (void)setUpUi {
    
    
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

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    CGFloat x = currentPoint.x - self.frame_width * 0.5;
    CGFloat y = currentPoint.y - self.frame_height * 0.5;
    
    CGFloat square = fabs(x * x) + fabs(y * y);
    
    if (square > 50 && ) {
        
            printLog(@"");
    }
}

@end
