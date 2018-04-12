//
//  SHSwitchButton.h
//  SmartHotel
//
//  Created by Mac on 2018/4/12.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSwitchButton : UIButton

/// 当前状态开与关
@property (nonatomic, getter = isOn) BOOL on;

/// 打开图片
@property(nullable, nonatomic, strong) UIImage *onImage ;

/// 关闭图片
@property(nullable, nonatomic, strong) UIImage *offImage;

@end
