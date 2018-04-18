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



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self getRotateAngle:touches isMoveEnd:NO];
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    CGFloat x = currentPoint.x - self.frame_width * 0.5;
    CGFloat y = currentPoint.y - self.frame_height * 0.5;

    CGFloat square = fabs(x * x) + fabs(y * y);
    CGFloat base = (self.frame_width * 0.5) * (self.frame_width * 0.5);

    if (square < base) {

        CGFloat adjustedAngle = [self angleBetweenCenterAndPoint:currentPoint];

        if (adjustedAngle >= 0 && adjustedAngle <= M_PI) {

            if ([self.delegate respondsToSelector:@selector(changeTemperature: isEndRotate:)]) {

                [self.delegate changeTemperature:adjustedAngle isEndRotate:NO];
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self getRotateAngle:touches isMoveEnd:YES];
}

- (void)getRotateAngle:(NSSet<UITouch *> *)touches isMoveEnd:(BOOL)isMoveEnd {
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    CGFloat x = currentPoint.x - self.frame_width * 0.5;
    CGFloat y = currentPoint.y - self.frame_height * 0.5;
    
    CGFloat square = fabs(x * x) + fabs(y * y);
    CGFloat base = (self.frame_width * 0.5) * (self.frame_width * 0.5);
    
    if (square < base) {
        
        CGFloat adjustedAngle = [self angleBetweenCenterAndPoint:currentPoint];
        
        if (adjustedAngle >= 0 && adjustedAngle <= M_PI) {
            
            if ([self.delegate respondsToSelector:@selector(changeTemperature: isEndRotate:)]) {
                
                [self.delegate changeTemperature:adjustedAngle isEndRotate:isMoveEnd];
            }
        }
    }
}

- (CGFloat)angleBetweenCenterAndPoint:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.frame_width * 0.5, self.frame_height * 0.5);
    
    CGFloat origAngle = atan2(center.y - point.y, point.x - center.x);
    
    origAngle = origAngle > 0 ? ((M_PI - origAngle) + M_PI) : fabs(origAngle);
   
    //  fmodf 求两数整除后的余数
    origAngle = fmodf(origAngle+(M_PI), 2*M_PI);
    
    return origAngle ;
}



@end
