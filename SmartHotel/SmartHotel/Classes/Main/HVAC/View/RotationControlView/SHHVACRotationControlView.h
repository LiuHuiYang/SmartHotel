//
//  SHHVACRotationControlView.h
//  SmartHotel
//
//  Created by Mac on 2018/4/17.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHHVACRotationControlViewDelegate <NSObject>

@optional

- (void)changeTemperature:(CGFloat)angle isEndRotate:(BOOL)isEndRotate;

@end

@interface SHHVACRotationControlView : UIView

@property (weak, nonatomic) id<SHHVACRotationControlViewDelegate> delegate;


@end
