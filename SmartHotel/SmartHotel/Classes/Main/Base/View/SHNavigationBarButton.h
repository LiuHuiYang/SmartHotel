//
//  SHNavigationBarButton.h
//  SmartHotel
//
//  Created by LHY on 2018/4/4.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHNavigationBarButton : UIButton


+ (instancetype)navigationBarButton:(NSString *)text font:(UIFont *)font image:(UIImage *)image isDefault:(BOOL)isDefault addGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;

@end
