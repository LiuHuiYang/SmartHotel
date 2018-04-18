//
//  SHHVACRotationControlView.m
//  SmartHotel
//
//  Created by Mac on 2018/4/17.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHHVACRotationControlView.h"

@interface SHHVACRotationControlView ()

@property (nonatomic, strong) UIImage *rotateImage;
@property (nonatomic, strong) CALayer *rotateLayer;

@end

@implementation SHHVACRotationControlView

/// 设置界面
- (void)setUpUi {
    
    // 背景图片
//    UIImage *backgrounImage = [UIImage imageNamed:@"ac_circle_bg"];
//    CALayer *backgroundLayer = [CALayer layer];
//    backgroundLayer.contents = (id)(backgrounImage.CGImage);
//    backgroundLayer.anchorPoint = CGPointMake(0.5 , 0.5);
//
//    backgroundLayer.frame = CGRectMake(self.frame_width* 0.5- backgrounImage.size.width* 0.5, self.frame_height * 0.5 - backgrounImage.size.height* 0.5 + 7, backgrounImage.size.width, backgrounImage.size.height);
//
//    backgroundLayer.contentsCenter = CGRectMake(self.frame_width * 0.5, self.frame_height * 0.5, backgrounImage.size.width, backgrounImage.size.height);
//
//    [self.layer addSublayer:backgroundLayer];
    
//    // 旋转图片
//    self.rotateImage = [UIImage imageNamed:@"ac_circle_In"];
//    CALayer *rotateLayer = [CALayer layer];
//    rotateLayer.contentsScale = [UIScreen mainScreen].scale;
//    rotateLayer.contents = (id)self.rotateImage.CGImage;
//    rotateLayer.anchorPoint = CGPointMake(0.5 , 0.5);
//  
//    self.rotateLayer.frame = CGRectMake(self.frame_width * 0.5 - self.rotateImage.size.width * 0.5, self.frame_height * 0.5 - self.rotateImage.size.height * 0.5, self.rotateImage.size.width, self.rotateImage.size.height);
//    
//    
//    self.rotateLayer.contentsCenter = CGRectMake(self.frame_width * 0.5, self.frame_height * 0.5, self.rotateImage.size.width, self.rotateImage.size.height);
//    
//    [self.layer addSublayer:rotateLayer];
//    
//    self.rotateLayer = rotateLayer;
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

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    CGPoint currentPoint = [[touches anyObject] locationInView:self];
//    CGFloat x = currentPoint.x - self.frame_width * 0.5;
//    CGFloat y = currentPoint.y - self.frame_height * 0.5;
//    
//    CGFloat square = fabs(x * x) + fabs(y * y);
//    CGFloat base = (self.frame_width * 0.5 - 10) * (self.frame_width * 0.5 - 10);
//    
//    if (square > 50 && square < base) {
//       
//        printLog(@"达到要求");
//        CGFloat adjustedAngle = [self angleBetweenCenterAndPoint:currentPoint];
//        
//        if (adjustedAngle >= 0 && adjustedAngle <= M_PI)
//        {
//            
//            self.rotateLayer.transform = CATransform3DMakeRotation(adjustedAngle , 0, 0, 1);
// 
//            if ([self.delegate respondsToSelector:@selector(changeTemperature:)]) {
//                
//                [self.delegate changeTemperature:adjustedAngle];
//            }
//        }
//    }
//}


- (CGFloat)angleBetweenCenterAndPoint:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.frame_width * 0.5, self.frame_height * 0.5);
    
    CGFloat origAngle = atan2(center.y - point.y, point.x - center.x);
    
    origAngle = origAngle > 0 ? ((M_PI - origAngle) + M_PI) : fabs(origAngle);
   
    //  fmodf 求两数整除后的余数
    origAngle = fmodf(origAngle+(M_PI), 2*M_PI);
    
    return origAngle ;
}



@end
